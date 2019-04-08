function offset = losOffsetFromCorr(corr, varargin)
% losOffsetFromCorr

p = inputParser;
addOptional(p,'PeakThreshold', 6);
parse(p,varargin{:});
pkThresh = p.Results.PeakThreshold;

% Find Statistics of correlation result
smean = mean(corr); % sample mean
sstd = std(corr);   % sample Standard Deviation


% First, find the maximum. If the noise is not too great, the LOS should be
% near this value. Circularly shift corr such that the max index is element
% 50
[maxVal, maxIndex] = max(corr);


if length(corr) < 100
    upperbound = length(corr);
    corrShft = corr;
    centerShift = 0;
else
    upperbound = 100;
    centerShift = 50;
    corrShft = circshift(corr, [-maxIndex + centerShift, 0]);
end

lowerbound = 1;



% Next, find the local peaks above a threshold
[~, loc] = findpeaks(abs(corrShft(lowerbound: upperbound)), 'minPeakHeight', maxVal*.5);

if isempty(loc)
    offset = maxIndex-1;
else
    offset = maxIndex - (centerShift - loc(1))-1;
    % Use Early Prompt Late Correlators
    % The true offset may lie between two samples.
    adj = 0;
    if corrShft(loc(1)-1) - corrShft(loc(1)+1) > .005
        d = abs(corrShft(loc(1)) - corrShft(loc(1)-1));
        if (d > .5)
            adj = 0;
        else
            adj = -2*(d-.5)^2;
        end
    elseif -corrShft(loc(1)-1) + corrShft(loc(1)+1) > .005
        d = abs(corrShft(loc(1)) - corrShft(loc(1)+1));
        if (d > .5)
            adj = 0;
        else
            adj = 2*(d-.5)^2;
        end
    end
    offset = offset + adj;
end



end

