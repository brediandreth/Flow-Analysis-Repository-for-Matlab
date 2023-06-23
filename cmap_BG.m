function out = cmap_BG(varargin)
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
    
%     color1 = [0.1 0.5 0.7];
%     color2 = [0.8 0.8 0.1];
    
%     color1 = [0 48 143]./255;
%     color2 = [172 225 175]./255;
% 
%     out = [linspace(color1(1), color2(1), M)' linspace(color1(2), color2(2), M)' linspace(color1(3), color2(3), M)'];
    
    
    color1 = [0.1 0.1504 0.6603];
    color12 = [0.5 0.8 0.3];
    color2 = [0.9769 0.9839 0.0805];
    
    M1 = floor(M/2);
    M2 = M-M1;
    
    out1 = [linspace(color1(1), color12(1), M1)' linspace(color1(2), color12(2), M1)' linspace(color1(3), color12(3), M1)'];
    out2 = [linspace(color12(1), color2(1), M2)' linspace(color12(2), color2(2), M2)' linspace(color12(3), color2(3), M2)'];
    
    out = [out1;out2];
    
        
end