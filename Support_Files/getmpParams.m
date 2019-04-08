% getmpParams generates mulitpath channel parameters with a random number
% of reflected signals, delays, and gains, based on normal distributions 
% of indoor channel model values. These parameters are within a
% specified range (based on input arguments)
% Inputs:
%   'overallDelay' - overall delay of the entire signal (s)
function mpParams = getmpParams(overallDelay)
    nmpMean = 6;    % number of multipath means
    nmpSD = 3;  % number of multipath standard deviation
    maxDelay = 1000e-9;    % max reflected signal time is 1000 ns.
    minGain = -25.2;
    maxGain = 6.9;
    
    nmp = round(nmpSD.*randn(1,1) + nmpMean);  % pick a random number of reflected paths from 1 to 15
    mpDelays = maxDelay*rand(1,nmp);  % Assign random relative delays to each reflected path
    mpDelays = sort(mpDelays);  % Sort delays in ascending order
    mpGains = ( maxGain-minGain ).*rand(1, nmp) + minGain; % Assign random gains to each reflected path from -6 to +3 dB
    % The multipath components are relative of the transmitted signal
    % components. 
    mpParams = struct('delays', overallDelay + [0,mpDelays], ...
                'gains', [0, mpGains], ...
                'reflSigs', nmp);
end