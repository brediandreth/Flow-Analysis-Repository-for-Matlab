function plothmp(varargin)
%PLOTHMP  plots a 2d or 3d heatmap using bin outer edges if defined as
%xlim, ylim, zlim assuming evenly-distributed bins along axes, otherwise
%plots on [0 1]
%   PLOTHMP(colordata)	colordata is a 2D or 3D array of values arranged
%   (x,y) or (x,y,z) respectively.
%
%   PLOTHMP(__,Name,Value)  specifies the axes properties using one or
%   more Name, Value pair arguments.
%
%   PLOTHMP(ax,__)  plots into the axes specified by ax instead of in
%   the current axes (gca). The option ax can precede any of the input
%   argument combinations in the previous syntaxes.
    
    nargs = numel(varargin);
    if nargs ==0 
        % not allowed
        error('Not enough input arguments.')
    elseif nargs == 1 
        % should just be colordata
        if isa(varargin{1},'double')
            colordata = varargin{1};
            ax = gca;
        else
            error('Not enough input arguments.')
        end
    elseif nargs == 2
        %should be ax followed by colordata
        if isa(varargin{1},'matlab.graphics.axis.Axes') && isa(varargin{2},'double')
            ax = varargin{1};
            colordata = varargin{2};
        else
            error('Not enough input arguments.')
        end
    elseif mod(nargs,2)
        % odd number: has colordata and at least one Name, Value pair
        if isa(varargin{1},'double')
            props = varargin(2:nargs);
            colordata = varargin{1};
            ax = gca;
        else
            error('Error in argument')
        end
    else
        % even number: has ax, colordata and at least one Name, Value pair
        if isa(varargin{1},'matlab.graphics.axis.Axes') && isa(varargin{2},'double')
            props = varargin(3:nargs);
            ax = varargin{1};
            colordata = varargin{2};
        else
            error('Error in argument')
        end
    end
    
    
    
    %decide whether to assign xlim, ylim, zlim, zscale or default
    if exist('props')
        
        if any(strcmp('xlim',props))
            xlim = props{find(strcmp('xlim',props))+1};
        else
            xlim = [0 1];
        end
        
        if any(strcmp('ylim',props))
            ylim = props{find(strcmp('ylim',props))+1};
        else
            ylim = [0 1];
        end
        
        if any(strcmp('zlim',props))
            zlim = props{find(strcmp('zlim',props))+1};
        else
            zlim = [0 1];
        end
        
        if any(strcmp('zscale',props))
            zscale = props{find(strcmp('zscale',props))+1};
        else
            zscale = 'linear';
        end
        
    else
        xlim = [0 1];
        ylim = [0 1];
        zlim = [0 1];
        zscale = 'linear';
    end
        
    
    
            
    
    if ismatrix(colordata)

        colormap(parula)
        colordata2d = colordata';

        % desired z position of the image plane.
        imgzposition = 0;

        % plot the image plane using surf.
        surf(ax,[xlim],[ylim],repmat(imgzposition, [2 2]),...
        colordata2d,'facecolor','texture')

        %determine
        view(0,90)


    elseif ndims(colordata) == 3
        hold on
        nzi = size(colordata,3);
        switch zscale
            case 'linear'
                zpos = linspace(zlim(1),zlim(2),nzi);
            case 'log'
                zpos = logspace(log10(zlim(1)),log10(zlim(2)),nzi);
        end

        for zi = 1:nzi
            colormap(parula)

            colordata2d = colordata(:,:,zi)';

            % desired z position of the image plane.
            imgzposition = zpos(zi);

            % plot the image plane using surf.
            surf(ax,[xlim],[ylim],repmat(imgzposition, [2 2]),...
                colordata2d,'facecolor','texture')

        end
        %determine
        view(-45,30)
    else
        error('This function can only plot 3 dimensions')

    end

    %set rest of axes properties passed in to function
    if exist('props')
        set(ax,props{:})
    end


end