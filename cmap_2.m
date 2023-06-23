function out = cmap_BGY(varargin)
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

% %     color1 = [0.1 0.1504 0.6603];
% %     color12 = [0.5 0.8 0.3];
% %     color2 = [0.9769 0.9839 0.0805];
%     
%     color1 = [37 52 148]./255;
%     color12 = [65 182 196]./255;
%     color2 = [237 248 177]./255;
    
    
    color1 = [64,7,126]./255;
    color2 = [96,246,255]./255;
    
        out = [linspace(color1(1), color2(1), M)' linspace(color1(2), color2(2), M)' linspace(color1(3), color2(3), M)'];

    
        
end