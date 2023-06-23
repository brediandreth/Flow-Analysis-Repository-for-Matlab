function out = cmap_4(varargin)
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


    
    color1 = [37 52 148]./255;
    color2 = [65 182 196]./255;
%     color3 = [237 248 177]./255;
    color3 = [225 210 150]./255;
    color4 = [225 110 148]./255;

    
    M1 = floor(M/3);
    M2 = ceil(M/3);
    M3 = M-M1-M2;
    
    if M1 == 1
        out1 = color1;
    else
        out1 = [linspace(color1(1), color2(1), M1)' linspace(color1(2), color2(2), M1)' linspace(color1(3), color2(3), M1)'];
    end
    out2 = [linspace(color2(1), color3(1), M2+1)' linspace(color2(2), color3(2), M2+1)' linspace(color2(3), color3(3), M2+1)'];
    out3 = [linspace(color3(1), color4(1), M3+1)' linspace(color3(2), color4(2), M3+1)' linspace(color3(3), color4(3), M3+1)'];
    
    out = [out1;out2(2:end,:);out3(2:end,:)];
    
        
end