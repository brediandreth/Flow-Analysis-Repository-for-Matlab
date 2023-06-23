function gateout = createGate(fileName, channels, varargin) 
% CREATEGATE(fileName, channels, gates, axisScales, compAF, compCoeff)    has the user draw a 
% gate using a given fcs file ('fileName') and channel numbers ('channels'). 
% If a [1xN] gate struct is provided ('gates'), these gates are first applied before
% plotting using axisScales ('loglog', 'semilogy', 'semilogx', 'linear', 'biexp') if
% provided (linear axis otherwise).
% 
% Returns a gate struct which contains the fields 'chs' and 'pos'
% 
% See also createMorphoGate

% check if gates or axisScales paramteres passed in
    
    [axisScales, gates] = checkinputs(varargin{:});
    


    if ~isempty(gates)
        data = getflowdata(fileName, channels, gates);
    else
        data = getflowdata(fileName, channels);
    end

%     gateout.chs = channels;

%     xdat = data(:,1);
%     ydat = data(:,2);
% 
    figure
    xlabel(getChannelName(fileName,channels(1)))
    ylabel(getChannelName(fileName,channels(2)))
    gateout = drawGate(data,axisScales,channels,gcf);
%     switch axisScales
%         case 'loglog'
%             loglog(xdat,ydat,'.','MarkerSize',2)
%             set(gca, 'XScale', 'log','YScale', 'log')
%         case 'semilogy'
%             semilogy(xdat,ydat,'.','MarkerSize',2)
%             set(gca, 'YScale', 'log')%,'xlim', [0 250000])
%         case 'semilogx'
%             semilogx(xdat,ydat,'.','MarkerSize',2)
%             set(gca, 'XScale', 'log')
%         case 'linear'
%             plot(xdat,ydat,'.','MarkerSize',2)
%         case 'biexp'
%             plot(lin2logicle(xdat),lin2logicle(ydat),'.','MarkerSize',2)
%             biexpaxis(gca)
%     end
%     hold on
%     h = impoly;
%     position = wait(h);


%     if strcmp(axisScales,'biexp')
%         gateout.pos = logicle2lin(position);
%     else
%         gateout.pos = position;
%     end


function [axisScales, gates] = checkinputs(varargin)
    
    for n = 1:nargin
        switch class(varargin{n})
            case 'char'
                if ~exist('axisScales','var')
                    axisScales = varargin{n};
                else
                    error('Bad inputs');
                end
            case 'struct'
                if ~exist('gates','var')
                    gates = varargin{n};
                else
                    error('Bad inputs');
                end
            otherwise
                error('Bad inputs');
        end
    end
    
    if ~exist('axisScales','var')
        axisScales = 'linear';
    end
    if ~exist('gates','var')
        gates = []';
    end

    end
%     switch nargin
%         case 0
%             gates = [];
%             axisScales = 'linear';
%         case 1
%             class(varargin{1})
%             switch class(varargin{1})
%                 case 'char'
%                     axisScales = varargin{1};
%                     gates = [];
%                 case 'struct'
%                     gates = varargin{1};
%                     axisScales = 'linear';
%                 otherwise
%                     error('BAD');
%             end
%         case 2 
%             if isa(varargin{1}, 'char') && isa(varargin{2}, 'struct')
%                 axisScales = varargin{1};
%                 gates = varargin{2};
%             elseif isa(varargin{2}, 'char') && isa(varargin{1}, 'struct')
%                 axisScales = varargin{2};
%                 gates = varargin{1};
%             else
%                 error('BAD');
%             end
%         otherwise
%             error('BAD');
%     end
end
    
