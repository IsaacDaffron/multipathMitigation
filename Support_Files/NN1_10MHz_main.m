% The single output network for use with the PSS reference signal at an LTE
% BW of 10 MHz.

function [offset, ccorr, t] = NN1_10MHz_main(rxSig, refSig, fs, range)
     % First, perform Conventional Correlation to get an initial estimate
    [ccOff, ccorr, ~] = convCorr(rxSig, refSig, fs, 'Modified', 0);
    
    % shift conventional correlation result
    subRange = range; % number of samples on either side of intial estimate to pull out
    ccorrShft = circshift(ccorr, [-ccOff+subRange,0]);
    
    % Pull out a subsection around the peak
    subs = abs(ccorrShft(1:2*subRange + 1));
    
    % Enter subsection as an input to the network.
    subsOff = NN1_10MHz_nnfunc(subs);
    
    % Determine global toa estimation
    offset = subsOff-subRange+ccOff-1;
end