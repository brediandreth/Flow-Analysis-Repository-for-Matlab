function plot2Dline(varargin)
%PLOTSURFLINE  plots a 2d array as a surface plot with lines along either the x
%or y direction
%   PLOTSURFLINE(xvals, yvals, Z, linedir) plots the values in Z using the
%   two vector arguments xvals and yvals must have length(x) = n and 
%   length(y) = m where [n,m] = size(Z).
%
%   PLOTSURFLINE(Z)	Z is a 2D array of values arranged (x,y). uses xvals =
%   1:n and yvals =1:m.
%
%   PLOTSURFLINE(__,Name,Value)  specifies the plotsurfline properties using one or
%   more Name, Value pair arguments specified below.
%
%   PLOTSURFLINE(ax,__)  plots into the axes specified by ax instead of in
%   the current axes (gca). The option ax can precede any of the input
%   argument combinations in the previous syntaxes.
%
%
%   Properties: 'linedir'   :   {'x','y'}
%               'colormap'  :   {char} e.g. 'parula'