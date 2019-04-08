% This is the simulation testbed as described in the Thesis. It must be in
% the same directory as all correlation test methods, or the folder to
% those methods must be included in the path. The MATLAB LTE Toolbox must
% also be installed.
% Author: Isaac Daffron
clearvars;

% Set the Overall Test parameters:
% nTrials is the number of simulations over which to average for a given
% TOA estimation method.
% refSigTypes is a cell array consisting of a string to determine the type
% of reference signal to use for the simulations. Can be 1x1 or 1x2.
% lteBWs is a vector to determine over which LTE BWs to test the TOA
% estimation algorithms.
% snrs is a vector to determine over which SNRs to test.
% The total number of trials run is
% nTrials*length(refSigTypes)*length(lteBWs)*length(snrs)''
% toaEstMethod is a string to decide which TOA Estimation Method to use.
% Allowable toaEstMethod strings:
%   'cc' - conventional correlation
%   'sd' - slope differential
%   'mcc' - modified conventional correlation
%   'pocs' - projection onto convex sets
%   'nn1' - Single output network
%   'nn2' - 2 stage shallow network
%   'nn3' - 1 hot code output network

nTrials = 500;
refSigTypes = {'pss','prn'};
lteBWs = [5e6, 10e6, 20e6];
snrs = [10, 15, 25];
toaEstMethod = 'cc';

% Add support file link to all toa estimation method functions
p = genpath('C:\Users\isaac\Documents\NIST Project\MatLab Scripts\Support_Files');
addpath(p);
c = 3e8;    % Speed of light (m/s)



% Set LTE Signal Structure Parameters
% A random number generator may be set here to produce predictable random
% values.
% cfg is the configuration for the lte signal and channel parameters. If
% cfg.random == 1, the channel parameters are section to random values
% based on the distribution discussed in the thesis. If cfg.random == 0,
% the channel parameters can be set by the user, in the following if/end
% block.

% rng('default'); % Reset random number geneterator to produce predictable values
cfg.random = 0;  % Boolean to decide if the delay & multipath configuration of the channel should be random
if (~cfg.random)
    cfg.losDelay = 7680e-9; % (s) time delay of the los signal, if cfg.random is set to 0
    cfg.mpParams.delays = cfg.losDelay + [0, 0];   % relative time delay of each reflected path
    cfg.mpParams.gains = [1, 0];    % relative gains of each path
    cfg.snr = 10;  % set SNR parameter
end
cfg.cin = 1;    % Coherent Integration Periods. Assumes signal does not change over integration time.
cfg = preGenRefSig(cfg, lteBWs, refSigTypes);   % Pre generate the different reference signals before testing to reduce computation time



% Initialize Error Tracking. After simulation, results.table is a table
% where the columns (1-5) represent, for a single toa estimation method, 
% (1) Average Sample Error, (2) Average Error (meters), (3) Max error
% (meters), (4) Std. Deviation in error across all trials (m), and (5) the
% number of times the reference signal was not detected. The rows are
% dependent upon the refSigTypes, lteBWs, and snrs vectors. E.g. the first
% row is refSigTypes(1), lteBWs(1), and snrs(1). the second row is
% refSigTypes(1), lteBWs(1), and snrs (2). This pattern continues through
% all snrs, then the lteBW increases. All snrs are evaluated again, then
% the lteBW increases to the next element. Once all elements of lteBWs have
% been evaluated, refSigTypes increments to the next element and the
% process repeats.
results.table = zeros(length(snrs)*length(lteBWs)*length(refSigTypes), 5);


% Main TOA Estimation Method Evaluation Loop
% Loop thru all the reference signal types:
for ref = 1:length(refSigTypes)
    
    % Change lte reference signal parameter of configuration
    cfg.ct = refSigTypes{ref};
    
    % reset max error counter
    maxBwErrSamps = 0; % holds the max error of the current BW
    
    % Loop thru all lte BWs to test:
    for ltebw = 1:length(lteBWs)
        
        % Change the lte BW
        cfg.bw = lteBWs(ltebw);
        if (strcmpi(cfg.ct, 'pss'))
            % scale the offset if needed
            offset_scale = -7680*(cfg.bw/5e6);
        else
            offset_scale = 0;
        end
        
        % change reference signal (which changes with lteBW b/c of sampling
        % frequency (pss) or length (custom prn code).
        cfg.currRefSig = cfg.refSigs{ref,ltebw};
        
        % Loop through all snrs to test:
        for snr = 1:length(snrs)
            % Reset counter variables for next test
            cfg.snr = snrs(snr);
            nUndetected = 0;
            testErrSamps = zeros(1, nTrials);
            
            % Loop thru nTrials independent trials of each signal type:
            for k = 1:nTrials
                exitLoop = false;
                while ~(exitLoop)
                    % A While loop is used to prevent estimation when the
                    % reference signal is not even detected. The trial is
                    % effectively run once more.
                    
                    % Generate Received signal w/ noise & multipath fading
                    r = getlte(cfg);

                    % Estimate LOS delay with specific method:
                    if (strcmpi(toaEstMethod, 'cc'))
                        [offsetSamps, corr, t] = convCorr(r.rxSig, r.refSig, r.fs, r.range, 'Modified', 0);
                    elseif (strcmpi(toaEstMethod, 'mcc'))
                        [offsetSamps, corr, t] = convCorr(r.rxSig, r.refSig, r.fs, r.range, 'Modified', 1);
                    elseif (strcmpi(toaEstMethod, 'sd'))
                        [offsetSamps, corr] = diff2Corr(r.rxSig, r.refSig, r.fs);
                    elseif (strcmpi(toaEstMethod, 'pocs')) 
                        G = POCSgetG(r.refSig, r.range);
                        [offsetSamps, corr] = POCScorr(r.rxSig, r.refSig, G, r.range, r.fs);
                    elseif (strcmpi(toaEstMethod, 'nn1')) 
                        [offsetSamps, corr] = nnPicker(r, cfg, 1);
                    elseif (strcmpi(toaEstMethod, 'nn2')) 
                        [offsetSamps, corr] = nnPicker(r, cfg, 2);
                    elseif (strcmpi(toaEstMethod, 'nn3')) 
                        [offsetSamps, corr] = nnPicker(r, cfg, 3);
                    else
                        error('Please enter a valid TOA estimation method');
                    end

                    % Check which half of the correlation output it has
                    % synched to. We do not care about frame identification
                    % so it does not really matter here.
                    if(offsetSamps+offset_scale >= length(r.rxSig)/2)
                        % Check if offset is synched to the first half or second
                        % half of frame. Adjust accordingly
                        offsetSamps = offsetSamps - length(r.rxSig)/2;
                    end
                    offsetSamps = offsetSamps + offset_scale;   % scale offset

                    % Calculate current error in meters and samples
                    currErrSamps = abs( offsetSamps-r.losDelaySamps );  % temp variable to hold current errror (samples)

                    % Determine if los was actually detected
                    if (currErrSamps > 2*r.range+1)
                        nUndetected = nUndetected + 1;
                        if (nUndetected > 100)
                            error('stuck in undetected loop');
                        end
                        exitLoop = false;
                    else
                        testErrSamps(k) = currErrSamps;
                        exitLoop = true;
                    end
               
                end
                
            end
            
            % Calculate Performance Metrics and fill in table
            avgErrSamps = mean(testErrSamps);
            avgErrMeters = avgErrSamps*(1/r.fs)*c;
            maxErrMeters = max(testErrSamps)*(1/r.fs)*c;
            stdDevMeters = std((testErrSamps.*((1/r.fs)*c)));
            
            results.table( length(lteBWs)*length(snrs)*(ref-1)+length(snrs)*(ltebw-1)+(snr), 1) = avgErrSamps;
            results.table( length(lteBWs)*length(snrs)*(ref-1)+length(snrs)*(ltebw-1)+(snr), 2) = avgErrMeters;
            results.table( length(lteBWs)*length(snrs)*(ref-1)+length(snrs)*(ltebw-1)+(snr), 3) = maxErrMeters;
            results.table( length(lteBWs)*length(snrs)*(ref-1)+length(snrs)*(ltebw-1)+(snr), 4) = stdDevMeters;
            results.table( length(lteBWs)*length(snrs)*(ref-1)+length(snrs)*(ltebw-1)+(snr), 5) = nUndetected;
            
        end
        
    end
    
end



