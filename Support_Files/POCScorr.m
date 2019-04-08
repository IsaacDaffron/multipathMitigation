function [offset, corr, timescale] = POCScorr(rxSig,refSig, G, range, fs)
%corrPOCS computes the offset of the rxSig relative to the refSig based on
%the POCS algorithm presented
%   The POCS Algorithm estimates the channel impulse response of the
%   subsequent reflected paths.
%   Inputs:
%       'rxSig' - the time domain waveform of which we want the offset
%       'refSig' - PRN code embedded in the timedomain waveform
%       'G' - Autocorrelation matrix of refSig. Generated using companion
%           function, 'POCSgetG'
%       'range' - POCS one-sided range constraint of where to search for multipath
%           around conventional Correlation peak (in samples)
%       'fs' - (Hz) the sampling frequency of the signal
%   Outputs:
%       'offset' - the sample offset at which the LTE frame begins
%       'corr' - Impulse response vector estimation
%       'timescale' - the time against which to plot 'corr'


    % Check to see if signal is vertical/horizontal
    [rxRow, rxCol] = size(rxSig);
    if rxRow < rxCol
        rxSig = rxSig';
        refSig = refSig';
    end
    
    % Check to see how man coherent integration periods
    if (size(rxSig,2) > 1)
        rxSig = sum(rxSig,2);
    end
    
    % Normalize incoming arguments
    rxSig = rxSig./max(abs(rxSig));
    refSig = refSig./max(abs(refSig));
    G = G./max(max(abs(G)));   
    
    % Perform Conventional Correlation
    convCorr = xcorr(rxSig, refSig);
    convCorr = (convCorr(length(rxSig):end));
    
    %convCorr = Correlate(rxSig, refSig);
    
    % Extract General Timing from Conventional Correlation
    [~, convOff] = max(abs(convCorr));
    y = circshift(convCorr, [-convOff + range, 0]);
    y = y(1:2*range+1);

    % Apply POCS Algorithm
    iterLim = 10;    % Iteration limit
    %nv =var(real(convCorr)) + 1i*var(imag(convCorr));   % noise Variance
    nv = 1;
    hhat = zeros(2*range+1, iterLim);   % Each column of hhat cumulatively adds the previous column plus a new estimate change.
    nveye = nv^2*eye(2*range+1);
    GG = G'*G;
    nvGG = nveye + GG;
    pinvGG = nvGG\G';   % Calculate psuedoinverse
    hhat(:, 1) = pinvGG*y;  % Initial Value of hhat
    err = zeros(1, iterLim);
    for i = 2:iterLim
        % hhat = pinv(xb)*y = inv(c' * c) * c' * y
        hhat(:, i) = hhat(: ,i-1) + pinvGG*(y-G*hhat(:, i-1));
        %h(i,:) = h(i-1,:) + pinv(G)*y;
        err(i) = mean(abs((y-G*hhat(:, i-1))))^2;
    end
    % Normalize hhat
    corr = abs(hhat(:,end))/max(abs(hhat(:,end)));
    
    % Determine offset using the Early Prompt Late Correlator and
    % Intelligent Peak selection of Modified Conventional Correlation.
    offset = pocsOffsetFinder(corr);
    
    %[~, offset] = max(abs(hhat(:, end)));
    offset = offset-range+convOff-1;
    timescale = 0:1/fs:(1/fs)*(length(corr)-1);
end

function offset = pocsOffsetFinder(in)
    % Find Statistics
    smean = mean(in);
    sstd = std(in);

    % Next, find the local peaks above a threshold
    [~, loc] = findpeaks(in, 'minPeakHeight', smean + (sstd*2));

    if isempty(loc)
        [~, offset] = findpeaks(in, 'NPeaks', 1, 'SortStr', 'descend');
    else
        offset = loc(1);
        % Use Early Prompt Late Correlators
        % The true offset may lie between two samples.
        if in(loc(1)-1) - in(loc(1)+1) > .005
            d = abs(in(loc(1)) - in(loc(1)-1));
            if (d > .5)
                adj = 0;
            else
                adj = 2*(d-.5)^2;
            end
            offset = offset - adj;
        elseif -in(loc(1)-1) + in(loc(1)+1) > .005
            d = abs(in(loc(1)) - in(loc(1)+1));
            if (d > .5)
                adj = 0;
            else
                adj = 2*(d-.5)^2;
            end
            offset = offset + adj;
        end
    end

end