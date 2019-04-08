function [offset, corr, timescale] = convCorr(rxSig, refSig, fs, varargin)
%convCorr Performs conventional Correlation on the rxSig, using the refSig
%as a reference. Note this does not take into account frame identification.
%If 'Modified', 1 is used as an input argument, Modified Conventional
%Correlation is performed.
%   Inputs:
%       'rxSig' - the received signal with which to correlate
%       'refSig' - the reference signal to try to find in rxSig
%       'fs' - (Hz) the sampling frequency of the signal
%       'Modified' - (optional boolean) Name value pair. Value of 1
%           (default) modifies conventional correlation to search for the first
%           main peak (not necessarily the largest). Value of 0 finds offset
%           traditionally.
%       'PeakThreshold' - (optional scalar) Name Value pair. Determines the
%           number of std devs above the mean the threshold for a peak is.
%           Only applies if Modified is not 0. Default is 3.
%   Outputs:
%       'offset' - the sample offset at which the LTE frame begins
%       'corr' - the full frame conventional correlation result
%       'timescale' - the time against which to plot 'corr'

    p = inputParser;
    addOptional(p,'Modified',1);
    parse(p,varargin{:});
    modified = p.Results.Modified;

     % Check to see if signal is vertical/horizontal
    [rxRow, rxCol] = size(rxSig);
    if rxRow < rxCol
        % make the columns the rxsignals
        rxSig = rxSig';
        refSig = refSig';
    end
    
    % Combines signals if doing coherent integration
    if size(rxSig,2) > 1
        rxSig = sum(rxSig,2);
    end
    
    % Normalize Signals
    rxSig = rxSig./max(abs(rxSig));
    refSig = refSig./max(abs(refSig));
    
    corr = xcorr(rxSig, refSig);
    corr = (corr(length(rxSig):end));
    corr = corr./max(abs(corr));
    
    % Decide how to determine output
    if (~modified)
        [~, offset] = max(corr);
        offset = offset-1;
    else
        offset = losOffsetFromCorr(abs(corr));
    end
    
    timescale = 0:1/fs:(1/fs)*(length(corr)-1);
end

