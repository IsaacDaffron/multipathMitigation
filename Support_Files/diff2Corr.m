% Performs Correlation based on the second derivative of the reference
% signal
% developed referencing:
%   [1] Weill, L. R2. (1997). A GPS multipath mitigation by means of correlator reference waveform design, Proc. of the of ION NTM, CA, USA, pp. 197–206.
%   [2] C. Lee, S. Yoo, S. Yoon, and S. Y. Kim, “A novel multipath mitigation scheme based on slope differential of correlator output for Galileo systems,” in Proceedings of the 8th International Conference Advanced Communication Technology (ICACT '06), vol. 2, pp. 1360–1363, February 2006.
% Inputs:
%       'rxSig' - the received signal with which to correlate
%       'refSig' - the reference signal to try to find in rxSig
%       'fs' - (Hz) the sampling frequency of the signal
%   Outputs:
%       'offset' - the sample offset at which the LTE frame begins
%       'corr' - the fcorrelation subset near the conventional correlation
%          peak

function [offset, corr] = diff2Corr(rxSig, refSig, fs)

     % First, perform Conventional Correlation to get an initial estimate
    [ccOff, ccorr, ~] = convCorr(rxSig, refSig, fs, 'Modified', 0);
    
    % shift conventional correlation result
    subRange = round(2.213541666666667e-06*fs); % number of samples on either side of intial estimate to pull out
    ccorrShft = circshift(ccorr, [-ccOff+subRange,0]);
    
    % Pull out a subsection around the peak
    subs = (ccorrShft(1:2*subRange + 1));
    subs = subs/max(abs(subs));
    % Take the second derivative of the correlation subset
    diff2Subs = abs(diff(diff(subs)));
    diff2Subs = diff2Subs/max(abs(diff2Subs));
    
    % Decide how to determine output
    [~, offset] = max(real(diff2Subs));
    suboffset = offset-1;

    offset = suboffset-subRange+ccOff+1;
    corr = diff2Subs;
    % Inherent offsect scale adjustment (for each differntiation
%     plot(real(diff2Subs));
%     hold on;
%     plot(abs(subs));
%     xlim([suboffset-10, suboffset+10]);
%     hold off
    
end