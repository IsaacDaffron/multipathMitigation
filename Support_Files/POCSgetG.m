function G = POCSgetG(refSig, range)
%POCSgetG returns the autocorrelation matrix of the refSig. Companion
%function to POCScorr
%   Inputs:
%       'refSig' - the reference signal used for correltion
%       'range' - one-sided range in which to investigate multipath around
%           conventional correlation peak (samples)
%   Outputs
%       'G' - The matrix in which each row is a shifted version of the
%           autocorrelation of the reference signal.
    
    % Check to see if signal is vertical/horizontal
    [rxRow, rxCol] = size(refSig);
    if rxRow < rxCol
        refSig = refSig';
    end

    % Perform conventional correlation of the reference signal.
    g = pocsGcorrelate(refSig, refSig);
    g = g/max(abs(g));

    G = zeros(2*range+1, 2*range+1);
    for i = 0:2*range
        currShift = circshift(g, [i,0]);
        G(:,i+1) = currShift(1:2*range+1);
    end
end

function [ correlation_result ] = pocsGcorrelate( vector1, vector2, v1_freq, v2_freq )
    %pocsGcorrelate: Correlates two given vectors through the frequency domain
    %method
    %   Takes the fft of both vectors, takes the complex conjugate of one fft
    %   and multiplies it by the complex conjugate of another fft.
    %   Optional argument v1_freq and v2_freq specifies if the given vectors, v1
    %   and v2, are given in the frequency domain form. If they are true, their
    %   corresponding vectors are given in the frequency domain, otherwise
    %   false.

    if ~exist('v1_freq', 'var')
        v1_freq = false;
    end
    if ~exist('v2_freq', 'var')
        v2_freq = false;
    end

    % ---- determine short/long vector ----
    if length(vector1) < length(vector2)
        sv = vector1;
        lv = vector2;
    elseif length(vector2) < length(vector1)
        sv = vector2;
        lv = vector1;
    end


    if ~exist('sv', 'var')
        % if both vectors are the same length
        if ~v1_freq
            vector1 = fft(vector1);
        end
        if ~v2_freq
            vector2 = fft(vector2);
        end
        % Find correlation:
        correlation_result = ifft(vector1.*conj(vector2));

    else
        % if we have different sized vectors
        if mod(length(lv),length(sv)) ~= 0
            % zero pad lv until its length is a multiple of sv
            modlen = mod(length(lv), length(sv));
            lv(end:end+modlen,1 ) = zeros(modlen+1, 1);
        end

        % now the length of lv is a multiple of length of sv
        % loop thru sections of lv at sv windows
        correlation_result = zeros(1, length(lv));
        for i = 1:length(lv)/length(sv)
            v1 = lv((i-1)*length(sv)+1:i*length(sv));
            correlation_result((i-1)*length(sv)+1:i*length(sv)) = ifft(fft(sv).*conj(fft(v1)),[],1);
        end
    end

end



