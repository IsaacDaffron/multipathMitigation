% getlte returns an lte signal structure for a specific configuration.
% Input arguments:
%   'getltecfg' - lte configuration structure.
%   'getltecfg.bw' - lte BW
%   'getltecfg.snr' - SNR of received signal
%   'getltecfg.ct' - reference signal type
%   'getltecfg.cin' - coherent integration number
%   'getltecfg.random' - boolean to use provided multipath parameters (0)
%       or random ones (1)
%   'getltecfg.mpParams' - (optional) required if getltecfg.random == 0.
%       This is a struct containing the delays and gains of the los and
%       reflected paths.

function lte = getlte(getltecfg)
    % ct is a string describing the correlation type. It should either be
    % 'pss' or 'prn'
    if (~strcmpi(getltecfg.ct, 'pss') && ~strcmpi(getltecfg.ct, 'prn'))
        error('The reference signal type is not valid. getltecfg.ct should be ''pss'' or ''prn''');
    end

    % Set Signal Parameters
    BW = getltecfg.bw;  % (Hz)  LTE Bandwidth
    [fs, NSLRB, ~] = sigParamsFromBW(BW); % Get Sampling Rate (Hz) and Number of Side Link Resource Blocks.
    sampsPframe = 10e-3*fs;    % Samples per frame
    nFrames = 1; % number of frames to test

    %## Create a UE configuration
    ue = struct('NSLRB', NSLRB, 'NDLRB', NSLRB, ...
            'NCellID', 10, 'NSLID', 10, ...
            'CyclicPrefixSL','Normal',...
            'CellRefP', 1, ...
            'DuplexMode', 'TDD', ...
            'ct', getltecfg.ct);
    if (strcmpi(getltecfg.ct, 'zchu'))
        cfg.zchuLength = NSLRB*12;  % number of resource blocks * 12 resource elements per block
    end

    % Set Channel Model/CEC Configuration
    %## Channel Model Configuration
    cfg.Seed = 1;                  % Channel seed
    cfg.NRxAnts = 1;               % 1 receive antenna
    cfg.DopplerFreq = 0;           % 0Hz Doppler frequency
    cfg.MIMOCorrelation = 'Low';   % Low (no) MIMO correlation
    cfg.InitTime = 0;              % Initialize at time zero
    cfg.NTerms = 16;               % Oscillators used in fading model
    cfg.ModelType = 'GMEDS';       % Rayleigh fading model type
    cfg.InitPhase = 'Random';      % Random initial phases
    cfg.NormalizePathGains = 'On'; % Normalize delay profile power
    cfg.NormalizeTxAnts = 'On';    % Normalize for transmit antennas
    cfg.DelayProfile = 'Custom';      % EVA delay spread
    cfg.cin = getltecfg.cin;        % Coherent integration number
    cdRange = round(2.018229166666667e-6*fs)+1; % Code delay range (samples).

    % Generate Multipath Signal Parameters. If the cfg.random == 1, the
    % los delay will be set to a random value between 0 and 4 ms
    if (getltecfg.random)
        delay = .004*rand(1);
        cfg.mpParams = getmpParams(delay);
    else
        delay = getltecfg.mpParams.delays(1);
        cfg.mpParams = getltecfg.mpParams;
    end
    cfg.SNRdB = getltecfg.snr;
            
    % Generate DL signal with multipath
    [rxWaveform, ue] = transmitSig(ue, cfg);
    rxWaveform = rxWaveform(1:sampsPframe*nFrames,:);
    refSig = getltecfg.currRefSig;
    
    % Create a struct for output
    lte = struct();
    lte.rxSig = rxWaveform;
    lte.refSig = refSig;
    lte.fs = fs;
    lte.range = cdRange;
    lte.losDelaySamps = delay*fs;
    lte.losDelayTime = delay;
    lte.mpParams = cfg.mpParams;
    lte.mpParams.relDelays = lte.mpParams.delays - lte.losDelayTime;
    lte.snr = cfg.SNRdB;
    lte.ue = ue;
end

%% Transmit takes in the mpParams we have created, and sends a downlink
% signal thru a channel, adding awgn noise, as well. This was taken from a
% MATLAB downlink LTE example
% Inputs
%   'ue' - User Equipment Configuration
%   'cfg' - channgel model configuration
%   'mpParams' - a struct of mulitpath signal parameters
%   'SNRdB' - the SNR of the signal (dB)
% Output
%   'rxWaveform' - the received time domain waveform
function [rxWaveform, ue] = transmitSig(ue, cfg)
    cohInt = cfg.cin;    % Coherent Integration periods
    SNR = 10^(cfg.SNRdB/20);    % Linear SNR Value
    
    if (strcmpi(cfg.DelayProfile, 'Custom'))
        cfg.AveragePathGaindB = cfg.mpParams.gains;
        cfg.PathDelays = cfg.mpParams.delays;
    end

    %nFrames = 1; % number of frames to test
    channelEff = struct('addFade', true, ...
                        'addNoise', true);
    
    %## Subframe Resource Grid Size
    gridsize = lteDLResourceGridSize(ue);
    K = gridsize(1);    % Number of subcarriers
    L = gridsize(2);    % Number of OFDM symbols in one subframe
    P = gridsize(3);    % Number of transmit antenna ports

    % Transmit Resource Grid
    txGrid = [];

    %## Payload Data Generation
    % Data sent over the channel is random QPSK modulated symbols. A subframe
    % (1ms) worth of symbols is created, mapping to every resource element.
    % Other signals required for transmission will overwrite the place-holding
    % random symbols.
    % Number of bits needed is size of resource grid (K*L*P) * number of bits
    % per symbol (2 for QPSK)
    numberOfBits = K*L*P*2;

    % Create random bit stream
    inputBits = randi([0 1], numberOfBits, 1);

    % Modulate input bits
    inputSym = lteSymbolModulate(inputBits,'QPSK');

    %## Frame Generation
    % A loop generates 10 individual subframes, which are all appended together.
    % The appended subframes are stored in txGrid. We will be simulated a
    % channel (which will cause a delay), so an extra subframe is generated and
    % appended to the txGrid. For each subframe, the Cell-Specific Reference
    % Signal (Cell RS), Primary Sidelink Synchronization Signal (PSSS), and
    % Secondary Synchronization Signal (SSSS) are added. The PSSS and SSSS only
    % occur in subframes 0 and 5.
    % For all subframes within the frame
    for sf = 0:10

        % Set subframe number
        ue.NSubframe = mod(sf,10);

        % Generate empty subframe
        subframe = lteDLResourceGrid(ue);

        % Map input symbols to grid
        subframe(:) = inputSym;

        % Generate synchronizing signals
        pssSym = ltePSS(ue);
        ssSym = lteSSS(ue);
        pssInd = ltePSSIndices(ue);
        sssInd = lteSSSIndices(ue);

        % Map synchronizing signals to the grid
        subframe(pssInd) = pssSym;
        subframe(sssInd) = ssSym;

        % Generate cell specific reference signal symbols and indices
        cellRsSym = lteCellRS(ue);
        cellRsInd = lteCellRSIndices(ue);

        % Map cell specific reference signal to grid
        subframe(cellRsInd) = cellRsSym;
        
        % Add custom Correlation Signal
        if sf == 0 || sf == 5
            if (strcmpi(ue.ct, 'prn'))
                % Add a custom zadoff chu sequence
                zc = zchu(ue.NSLRB*12, 29); % 29 is the actuall pss used
                subframe(1:length(zc)) = zc;    % insert into subframe                
            end
        end

        % Append subframe to grid to be transmitted
        txGrid = [txGrid subframe]; %#ok

    end    
    

    %## OFDM Modulation
    % txWaveform is the time domain waveform
    [txWaveform,info] = lteOFDMModulate(ue,txGrid);
    %txGrid = txGrid(:,1:140);

    %## Channel Effects
    % Channel Fading
    cfg.SamplingRate = info.SamplingRate;

    % Pass data through the fading channel model
    if channelEff.addFade
        [fadedWaveform, ~] = lteFadingChannel(cfg, txWaveform);
        fadedWaveform = circshift(fadedWaveform, [-7, 0]); % Compensate for inherent 7-sample shift
    else
        fadedWaveform = zeros(size(txWaveform)); % signal remains the same
    end
    
    % Channel Noise
    % Noise added before OFDM Modulation will be amplified by the FFT. To
    % normalize the SNR at the receiver (after demodulation) the noise is
    % scaled here.
    % Based on the coherent Integration Number, 'cohInt,' consecutive signals
    % will be averaged together.
    
    if channelEff.addNoise
        N0 = 1/(sqrt(2.0*ue.CellRefP*double(info.Nfft))*SNR); % Calculate noise gain
        rxWaveform = repmat(fadedWaveform, [1,cohInt]);
        
        for i = 1:cohInt
            % Create additive white Gaussian noise
            noise = N0*complex(randn(size(fadedWaveform)),randn(size(fadedWaveform)));

            % Add noise to the received time domain waveform
            rxWaveform(:,i) = rxWaveform(:, i) + noise;
        end

    else
        rxWaveform = fadedWaveform; % signal remains the same
    end
end


