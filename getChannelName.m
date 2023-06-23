function chName=getChannelName(fcshdrfile,chNum)
% GETCHANNELNAME(FCSHDRFILE,CHNUM) gets the channel name from fcs data
%   CHNAME = GETCHANNELNAME(FCSHDR, CHNUM) returns the column name(s)
%   corresponding to the color channel(s) indicated by chNum, where
%    FCSHDRFILE - Can either be header data obtained from FCA_READFCS or
%    an fcs file name
%    CHNUM - Scalar or vector of channel numbers
%
%   Example:
%       [fcsdat, fcshdr, fcsdatscaled, fcsdatcomp] = fca_readfcs('sample.fcs');
%       chNames = getChannelName(fcshdr,[3,5]);
%

    % check whether header file or file name passed in
    if isa(fcshdrfile,'char')
        [fcsdat, fcshdr, fcsdatscaled, fcsdatcomp] = fca_readfcs(fcshdrfile);
    else
        fcshdr = fcshdrfile;
    end

    chName = fcshdr.par(chNum).name;
end