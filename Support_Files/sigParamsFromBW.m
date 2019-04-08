%% sigParamsFromBW uses the LTE standard to determine sampling frequency and
% the number of physical resource blocks from a given bandwidth (in Hz). It will
% return NaN for both if an invalid BW is used.
function [fs, prb, fftsize] = sigParamsFromBW(bw)
    switch bw
        case 1.4e6
            prb = 6;
            fs = 1.92e6;
            fftsize = 128;
        case 3e6
            prb = 12;
            fs = 3.84e6;
            fftsize = 256;
        case 5e6
            prb = 25;
            fs = 7.68e6;
            fftsize = 512;
        case 10e6
            prb = 50;
            fs = 15.36e6;
            fftsize = 1024;
        case 15e6
            prb = 75;
            fs = 23.04e6;
            fftsize = 1536;
        case 20e6
            prb = 100;
            fs = 30.72e6;
            fftsize = 2048;
        otherwise
            assert(0, 'Please Enter a Valid LTE BW (1.4, 3, 5, 10, 15, or 20 MHz');
    end
end