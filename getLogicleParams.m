function [T,M,r] = getLogicleParams
%GETLOGICLEPARAMS() returns the saved T,M,r values from metadata, otherwise
%saves a new file with the default values below

    if exist('metadata','dir')~=7
        mkdir('metadata')
    end
    % check if logicle_conv_params has already been defined
    if exist('metadata/LogicleParams.mat','file')==2
        logicle_conv_params = load('metadata/LogicleParams.mat');
        T = logicle_conv_params.T;
        M = logicle_conv_params.M;
        r = logicle_conv_params.r;
    else
        % DEFAULT VALUES
        T=2^18;   % The top data value
        M=4.5;      % Breadth of the display in decades
        r=-150;    % Negative range reference value
     
        logicle_conv_params.T = T;
        logicle_conv_params.M = M;
        logicle_conv_params.r = r;
        save('metadata/LogicleParams.mat','-struct','logicle_conv_params')
    end
end