% 2 Stage shallow network for use with the standard pss reference signal at
% an LTE bw of 10 MHz. 
function [offset, recon] = NN2_10MHz_main(rxSig, refSig, fs, range)

    % First, perform Conventional Correlation to get an initial estimate
    [ccOff, ccorr, ~] = convCorr(rxSig, refSig, fs, 'Modified', 0);
    
    % shift conventional correlation result
    subRange = range;
    ccorrShft = circshift(ccorr, [-ccOff+subRange,0]);
    
    % Pull out a subsection around the peak
    subs = abs(ccorrShft(1:2*subRange + 1));
    
    % Run subsection through Stage 1 to get course reconstruction of input
    corRecon = NN2_stage1_10MHz_70HN(subs);
    
    % Run course Reconstruction through autoencoder
    recon = NN2_stage2_10MHz_autoenc(corRecon);
    
    % Calculate LOS delay estimate
    [~, reconOffset] = max(recon);
    offset = ccOff + reconOffset - subRange-1;
end