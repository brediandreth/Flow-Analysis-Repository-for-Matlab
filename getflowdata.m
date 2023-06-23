function data_raw = getflowdata(file,channelIDs,gate)

% allow passing in multiple files (concatenates them)
% make channelIDs an optional variable
% make gate an optional variable and allow more than one

    if isa(file,'char')
        file = {file};
    end
    data =[];
    
    for f = 1:numel(file)
        [fcsdat, fcshdr, fcsdatscaled, fcsdatcomp] = fca_readfcs(file{f});
        data = [data; fcsdat];
    end
    
    if exist('gate','var')
        
        data_gated = applyGate(data,gate);

    else
        data_gated = data;
    end
    
    data_raw = data_gated(:,channelIDs);

end