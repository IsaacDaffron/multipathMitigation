%% genPssRef generates a PSS reference signal based upon the given enb
% configuration.
function cfg = preGenRefSig(cfgin, lteBWs, refSigTypes)
    cfg = cfgin;   % Set reference configuration to enb config
    
    
    for i = 1:length(refSigTypes)
        cfg.ct = refSigTypes{i};
        
       for j = 1:length(lteBWs)
           [~, NSLRB, ~] = sigParamsFromBW(lteBWs(j));
           %## Create a UE configuration
           ue = struct('NSLRB', NSLRB, 'NDLRB', NSLRB, ...
                    'NCellID', 10, 'NSLID', 10, ...
                    'CyclicPrefixSL','Normal',...
                    'CellRefP', 1, ...
                    'DuplexMode', 'TDD', ...
                    'ct', cfg.ct);
                
           if (strcmpi(ue.ct, 'pscch'))
                % Add the reference signal for the existing data
                subframe = lteDLResourceGrid(ue);
                custRefSf = zeros(size(subframe));
                if ~(exist('sldata', 'var'))
                    load sldata.mat sldata;
                end
                custRefSym = sldata;
                custRefSf(1:length(custRefSym)) = custRefSym;
                refSig = lteOFDMModulate_id(ue, custRefSf);
            elseif (strcmpi(ue.ct, 'prn'))
                % Add a custom Zadoff Chu Sequence
                subframe = lteDLResourceGrid(ue);
                custRefSf = zeros(size(subframe));
                zc = zchu(ue.NSLRB*12, 29); % 29 is the actuall pss used. 12 Resource elements per block. want to use all available elements.
                custRefSf(1:length(zc)) = zc;
                refSig = lteOFDMModulate_id(ue, custRefSf);
            else
                % Add reference data for normal pss
                ue.NSubframe = 1;
                pssGrid=lteDLResourceGrid(ue);
                pssGrid(ltePSSIndices(ue))=ltePSS(ue);
                refSig=lteOFDMModulate_id_newSC(ue,pssGrid);    
           end
           cfg.refSigs{i,j,1} = refSig;
       end
    end
    
end