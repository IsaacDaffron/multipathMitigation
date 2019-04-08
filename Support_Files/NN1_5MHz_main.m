% The single output network for use with the PSS reference signal at an LTE BW of 5 MHz.

function [offset, ccorr, t] = NN1_5MHz_main(rxSig, refSig, fs)
     % First, perform Conventional Correlation to get an initial estimate
    [ccOff, ccorr, ~] = convCorr(rxSig, refSig, fs, 'Modified', 0);
    
    % shift conventional correlation result
    subRange = round(2.213541666666667e-06*fs); % number of samples on either side of intial estimate to pull out
    ccorrShft = circshift(ccorr, [-ccOff+subRange,0]);
    
    % Pull out a subsection around the peak
    subs = abs(ccorrShft(1:2*subRange + 1));
    
    % Enter the subset into the network
    subsOff = neuralNetworkFunction_5MHz(subs);
    
    % Calculate the global toa estimate
    offset = subsOff-subRange+ccOff-1;
    
end
