function out=logicle2lin(X)
% LOGICLE2LIN(X) converts a vector of values from a logicle scale to a linear scale 
%   OUT = LOGICLE2LIN(X) returns a vector of values corresponding to the values 
%   in X transformed from a logicle scale to a linear one using
%   the conversion function described by Parks, et al. "A New Logicle
%   Display Method Avoids Deceptive Effects of Logarithmic Scaling for Low
%   Signals and Compensated Data" Equation (5), where
%     X - a vector of logicle values
%     out - a vector of linear converted values from X
%
%   Example:
%       out = logicle2lin(linspace(0,4));


[T,M,r] = getLogicleParams;

W=(M-log10(T/abs(r)))/2;
A=0;

out=logicleInverseTransform(X./M,T,W,M,A);

end