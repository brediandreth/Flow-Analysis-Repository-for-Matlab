function out = cmap_red(varargin)
%CMAP_RED Linear red to white scaled color map
    %CMAP_RED(M) returns an M-by-3 matrix containing a gray-scale colormap.
    %CMAP_RED, by itself, is the same length as the current figure's
    %colormap. If no figure exists, MATLAB uses the length of the
    %default colormap.

    switch nargin
        case 0 % no size was passed in
            g = groot;
            if isempty(g.Children) % no figure exists
                M = size(colormap,1); %get size of default colormap
            else
                M = size(get(gcf,'colormap'),1);
            end
        case 1
            M = varargin{1};
        otherwise
            error();
    end
    
    color1 = [1 0 0];
    color2 = [1 0.8 0.8];
    
    color1 = [0 0 1];
    color2 = [0.8 0.8 1];
    
    color1 = [1 0 0];
    color2 = [0 0 1];
    
    color1 = [1 0.8 0.8];
    color2 = [0.8 0.8 1];
    
%     color1 = [1 0.5 1];
%     color2 = [0.8 0 1];
    
%     color1 = [1 0.5 1];
%     color2 = [1 0 0];

% color1 = [0.2 0.6 0.7];
color1 = [0.1 0.5 0.7];
    color2 = [0.8 0.8 0.1];
    
    out = [linspace(color1(1), color2(1), M)' linspace(color1(2), color2(2), M)' linspace(color1(3), color2(3), M)'];
    
        
end