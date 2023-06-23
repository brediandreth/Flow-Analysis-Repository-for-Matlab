function ch=getChannelNum(fcshdrfile,strName)
% GETCHANNELNUM(FCSHDRFILE,STRNAME) gets the channel number from fcs data
%   CH = GETCHANNELNUM(FCSHDR, STRNAME) returns the column number(s)
%   corresponding to the color channel(s) indicated by strName, where
%    FCSHDRFILE - Can either be header data obtained from FCA_READFCS or
%    an fcs file name
%    STRNAME - String or string array used to uniquely identify (each) channel name.  Can be
%     partial channel name
%
%   Example:
%       [fcsdat, fcshdr, fcsdatscaled, fcsdatcomp] = fca_readfcs('sample.fcs');
%       GreenChannel = getChannelNum(fcshdr,'FIT');
%       GreenData = fcsdat(:,GreenChannel);
%

    % check whether header file or file name passed in
    if isa(fcshdrfile,'char')
        [fcsdat, fcshdr, fcsdatscaled, fcsdatcomp] = fca_readfcs(fcshdrfile);
    else
        fcshdr = fcshdrfile;
    end

    %check whether more than one channel supplied
    if isa(strName, 'char')
        % only one channel supplied
        ch = checkstring(strName);
    else
        %more than one channel supplied so loop through
        ch = zeros(1,numel(strName));
        for str_ind = 1:numel(strName)
            ch(str_ind) = checkstring(strName{str_ind});
        end
    end
    
    function ch_out = checkstring(chanstr)
        ch_inds_name = contains({fcshdr.par(:).name},chanstr) & ~contains({fcshdr.par(:).name},'Ratio');
        ch_inds = find(ch_inds_name);

        switch length(ch_inds)
            case 0
                error(['Channel for "' chanstr '" not found. Try a different string identifier. Here are the channel names: ' strjoin({fcshdr.par(:).name},', ')])
            case 1
                ch_out = ch_inds;
            otherwise
                error(['More than one channel found for "' chanstr '" : ' strjoin({fcshdr.par(ch_inds).name},', ') '. Try a different string identifier'])
        end
    end
end