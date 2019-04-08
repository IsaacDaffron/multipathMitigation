% Chooses an appropriate neural network method to run based on
% configuration parameters. Each network is designed for a different
% version of lte bw (5 MHz or 10 MHz) and reference signal type (pss or 
% custom prn code) combination.
%   Inputs:
%       'r' - the received signal struct. Is created using the getlte()
%       function. Must contain fs and range properties.
%       'cfg' - the lte configuration struct. Must contain bw property,
%           and ct property.
%   Outputs:
%       'offsetSamps' - the overall toa estimation in terms of samples
%       'corr' - the conventional correlation result near the peak of
%           conventional correlation

function [offsetSamps, corr] = nnPicker(r,cfg, nn)

    % First, check inputs have proper elements.
    if (cfg.bw ~= 5e6 && cfg.bw ~= 10e6)
        error('configuration BW is not valid.');
    elseif (~strcmpi(cfg.ct, 'pss') && ~strcmpi(cfg.ct, 'prn'))
        error('reference signal type not valid');
    end

    % Sort methods by neural network type
    if nn == 1
        % Sort methods by LTE BW
        if cfg.bw == 5e6
            % NN1 LTE BW 5 MHz 
            if strcmpi(cfg.ct, 'pss')
                [offsetSamps, corr] = NN1_5MHz_main(r.rxSig, r.refSig, r.fs);
            elseif strcmpi(cfg.ct, 'prn')
                [offsetSamps, corr] = NN1_5MHz_4_5PRN_main(r.rxSig, r.refSig, r.fs);
            end

        elseif cfg.bw == 10e6
            % NN1 LTE BW 10 MHz 
            if strcmpi(cfg.ct, 'pss')
                [offsetSamps, corr] = NN1_10MHz_main(r.rxSig, r.refSig, r.fs, r.range);
            elseif strcmpi(cfg.ct, 'prn')
                [offsetSamps, corr] = NN1_10MHz_9PRN_main(r.rxSig, r.refSig, r.fs, r.range);
            end
        end
        
    elseif nn == 2
        % Sort methods by LTE BW
        if cfg.bw == 5e6
            % NN2 LTE BW 5 MHz 
            if strcmpi(cfg.ct, 'pss')
                [offsetSamps, corr] = NN2_5MHz_main(r.rxSig, r.refSig, r.fs);
            elseif strcmpi(cfg.ct, 'prn')
                [offsetSamps, corr] = NN2_5MHz_4_5PRN_main(r.rxSig, r.refSig, r.fs);
            end

        elseif cfg.bw == 10e6
            % NN2 LTE BW 10 MHz 
            if strcmpi(cfg.ct, 'pss')
                 [offsetSamps, corr] = NN2_10MHz_main(r.rxSig, r.refSig, r.fs, r.range);
            elseif strcmpi(cfg.ct, 'prn')
                [offsetSamps, corr] = NN2_10MHz_9PRN_main(r.rxSig, r.refSig, r.fs, r.range);
            end
        end
        
    elseif nn == 3
        % Sort methods by LTE BW
        if cfg.bw == 5e6
            % NN3 LTE BW 5 MHz 
            if strcmpi(cfg.ct, 'pss')
                [offsetSamps, corr] = NN3_5MHz_main(r.rxSig, r.refSig, r.fs, r.range);                
            elseif strcmpi(cfg.ct, 'prn')
                [offsetSamps, corr] = NN3_5MHz_4_5PRN_main(r.rxSig, r.refSig, r.fs, r.range);  
            end

        elseif cfg.bw == 10e6
            % NN3 LTE BW 10 MHz 
            if strcmpi(cfg.ct, 'pss')
                [offsetSamps, corr] = NN3_10MHz_main(r.rxSig, r.refSig, r.fs, r.range);
            elseif strcmpi(cfg.ct, 'prn')
                [offsetSamps, corr] = NN3_10MHz_9PRN_main(r.rxSig, r.refSig, r.fs, r.range);
            end
        end
    end
        
    
    

    
   

    


end