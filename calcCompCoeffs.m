function [autofluor, coefficients] = calcCompCoeffs(SC_files, channelIDs, morpho_gate)
    

% todo: optional flag for linear or robust fitting


    numCh = numel(SC_files);

    % check if compcoeffs exists
    % first check if metadata folder has been created
    if exist('metadata','dir')~=7
        mkdir('metadata')
    end
    % first check if Compensation folder has been created
    if exist('metadata/Compensation','dir')~=7
        mkdir('metadata/Compensation')
    end
    % check if compcoeffs has already been calculated
    if exist('metadata/Compensation/CompParams.mat','file')==2
        comp_params = load('metadata/Compensation/CompParams.mat');
        autofluor = comp_params.autofluor;
        coefficients = comp_params.coeff;
        disp('... using Compensation in metadata folder.  Delete file to re-calculate...')
    else

        % empty cell array to store subdata
        SC_dataM = cell(1,numCh);

        % read each single-color file into array
        for file = 1:numCh
            dat_raw = getflowdata(SC_files{file},channelIDs,morpho_gate);
            SC_dataM{file} = dat_raw;
        end

        
        coefficients = ones(numel(channelIDs));
        autofluor = zeros(numel(channelIDs),1);

        % intial guesses
        A0 = ones(numCh,1).*10;

        inds = 1:numCh;

        for chF = 1:numCh  

             f = @(x) compFunc(x,channelIDs,chF,SC_dataM);
%              [minresult, fval] = fminsearch(f,[A0(chF),K0(chF,inds(inds~=chF))]);
             [minresult, fval] = fminsearch(f,A0(chF));

             autofluor(chF) = minresult(1)
%              coefficients(chF,inds(inds~=chF)) = minresult(2:end);
            [out,slopes]  = compFunc(minresult(1),channelIDs,chF,SC_dataM)
            coefficients(chF,:) = slopes;
        end

%         for chF = 1:numCh
%             scB_Data = [];
%             scF_Data = [];
%             for chB = setdiff(1:numCh,chF)
%                 scB_Data = [scB_Data SC_dataM{chB}(1:5000,chB)];
%                 scF_Data = [scF_Data SC_dataM{chB}(1:5000,chF)];
%             end
%             lsqcurvefit(@funfit,[0.01, 0.01, 10],scB_Data,scF_Data)
%         end
% 
%         return
        comp_params.autofluor = autofluor;
        comp_params.coeff = coefficients;

        plotsinglecolors(zeros(size(autofluor)), eye(size(coefficients)))
        savefig('metadata/Compensation/precomp')
        plotsinglecolors(autofluor, coefficients)
        savefig('metadata/Compensation/postcomp')
        save('metadata/Compensation/CompParams.mat','-struct','comp_params')
        
    end

%     function out = funfit(x,xdata)
%         for i = size(xdata,2)
%             out(:,i) = log10(x(i).*xdata(:,i)+x(end));
%         end
%     end
    

function [out,slopes]  = compFunc(fit_vals,channels,chF,SC_dataM)
                      
            R_vals = zeros(1,numel(channels));
            slopes = ones(1,numel(channels));
                    
                    for chB = setdiff(1:numel(channels),chF)
                            
                            %avoid fitting to values that are out of range
                            inds_to_include = SC_dataM{chB}(:,chB)<logicle2lin(4.25);
                            
                            scB_Data = SC_dataM{chB}(inds_to_include,chB);
                            scF_Data = SC_dataM{chB}(inds_to_include,chF)-fit_vals(1);
                            
                            [b,stats] = robustfit(scB_Data,scF_Data,'bisquare',4.685,'off');
                            R_vals(chB) = stats.s;
                            slopes(chB) = b;
                            
%                             [b,stats] = robustfit(scB_Data,scF_Data,'bisquare',100,'off');
%                             R_vals(chB) = stats.s;
%                             slopes(chB) = b;
                            
%                             [R_vals(chB), slopes(chB), B] = regression(scB_Data',scF_Data');

                    end
                    
            out = sum(R_vals);
end

function plotsinglecolors(AF, comp_matrix)

    [fcsdat, fcshdr, fcsdatscaled, fcsdatcomp] = fca_readfcs(SC_files{1});

    figure
    j = 1;
    for fileI = 1:length(SC_files)
        
        dat_raw = getflowdata(SC_files{fileI},channelIDs,morpho_gate);

        
        data = compensate(dat_raw, AF, comp_matrix);

        for k = 1:numCh
            subplot(numCh,numCh,sub2ind([numCh,numCh],fileI,k))
            plot(lin2logicle(data(:,fileI)),lin2logicle(data(:,k)),'.')
%             biexaxis(gca)
            if k ==1
                filename = SC_files{fileI};
                title(filename(1:end-4))
            end

            if fileI ==1
%                 ylabel(fcshdr.par(channelIDs(k)).name)
                ylabel(getChannelName(SC_files{1},channelIDs(k)))
            end
            if k==numCh
%                 xlabel(fcshdr.par(channelIDs(fileI)).name)
                xlabel(getChannelName(SC_files{1},channelIDs(fileI)))
            end
            j = j+1;
            axis([0 4.5 0 4.5])
        end
    end
end

end
