% One Hot Code output for use with the standard pss reference signal at an
% LTE BW of 5 MHz.

function [offset, netOut] = NN3_5MHz_main(rxSig, refSig, fs, range)
   

    % First, perform Conventional Correlation to get an initial estimate
    [ccOff, ccorr, ~] = convCorr(rxSig, refSig, fs, 'Modified', 0);
    
    % shift conventional correlation result
    subRange = range;
    ccorrShft = circshift(ccorr, [-ccOff+subRange,0]);
    
    % Pull out a subsection around the peak
    
    subs = abs(ccorrShft(1:2*subRange + 1));
    
    % Run subsection through Stage 1 to get course reconstruction of input
    netOut = NN3_5MHz_nnfunc(subs);
    
    % Calculate LOS delay estimate
    [~, netOff] = max(netOut);
    adj = 0;
    
    % Use the Early prompt late correlator from Modified Conventional
    % Correlation. 
    if netOut(netOff-1) - netOut(netOff+1) > .005
        d = abs(netOut(netOff) - netOut(netOff-1));
        if (d > .5)
            adj = -.5;
        else
            adj = -2*(d-.5)^2;
        end
    elseif -netOut(netOff-1) + netOut(netOff+1) > .005
        d = abs(netOut(netOff) - netOut(netOff+1));
        if (d > .5)
            adj = .5;
        else
            adj = 2*(d-.5)^2;
        end
    end
    
    
    
    offset = ccOff + netOff + adj - subRange-1;
end