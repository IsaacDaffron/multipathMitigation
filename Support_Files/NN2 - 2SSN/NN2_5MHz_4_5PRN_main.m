% 2 Stage shallow network for use with custom 4.5 MHz BW reference signal at
% an LTE bw of 5 MHz.
function [offset, recon] = NN2_5MHz_4_5PRN_main(rxSig, refSig, fs)
   

    % First, perform Conventional Correlation to get an initial estimate
    [ccOff, ccorr, ~] = convCorr(rxSig, refSig, fs, 'Modified', 0);
    
    % shift conventional correlation result
    subRange = round(2.213541666666667e-06*fs); % number of samples on either side of intial estimate to pull out
    ccorrShft = circshift(ccorr, [-ccOff+subRange,0]);
    
    % Pull out a subsection around the peak
    
    subs = abs(ccorrShft(1:2*subRange + 1));
    
    % Run subsection through Stage 1 to get course reconstruction of input
    corRecon = NN2_stage1_5MHz_4_5PRN_nnfunc(subs);
    
    % Run course Reconstruction through autoencoder
    recon = NN2_stage2_5MHz_4_5PRN_autoenc(corRecon);
    
    % Calculate LOS delay estimate
    [~, reconOffset] = max(recon);
    offset = ccOff + reconOffset - subRange-1;
end