function out=lin2logicleNaN(S)
% LIN2LOGICLE(S) converts a vector of values from a linear scale to a logicle scale 
%   OUT = LIN2LOGICLE(S) returns a vector of values corresponding to the values 
%   in X transformed from a linear scale to a logicle one using
%   the conversion function described by Parks, et al. "A New Logicle
%   Display Method Avoids Deceptive Effects of Logarithmic Scaling for Low
%   Signals and Compensated Data" Equation (5), where
%     S - a vector of linear 'raw' values
%     out - a vector of logicle converted values from S
%
%   Example:
%       out = lin2logicle(linspace(0,1000));
%

[T,M,r] = getLogicleParams;

W=(M-log10(T/abs(r)))/2;

A=0;

% out=M.*logicleTransform(S,T,W,M,A);


% Bre edit 3/18/2019 to allow for NaN values. Change to really negative
% value and change back after
Ss = S;
Si = isnan(S);
Ss(Si) = 1;

out0=M.*logicleTransform(Ss,T,W,M,A);

% add back NaN
out0(Si) = NaN;
out = out0;

end