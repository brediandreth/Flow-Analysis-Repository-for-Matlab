function varargout = evalbins(data, bin_edges, bin_order, N_bins, bin_eval,func)

    nOutputs = nargout;
    %check how assigning should be done
    if nOutputs ~= numel(func)
        % only put results into output is length 1 otherwise has to be the
        % same size as the number of functions evaluated
        if nOutputs ==1

            eval_out = cell(1,numel(func));
            for f = 1:numel(func)
                eval_out{f} = zeros(N_bins);
            end

            for bin = 1:numel(eval_out{1})

                out_inds = cell(1, numel(bin_order));
                [out_inds{:}] = ind2sub(size(eval_out{1}),bin);

                indices = true(size(data,1),1);

                for bin_ch = 1:length(bin_order)
                    indices = indices & data(:,bin_order(bin_ch))>bin_edges{bin_ch}(out_inds{bin_ch}) & data(:,bin_order(bin_ch))<=bin_edges{bin_ch}(out_inds{bin_ch}+1);
                end

                for f = 1:numel(func)
                    eval_out{f}(bin) = func{f}(data(indices,bin_eval));
                end
            end
            varargout{1} = eval_out;
        else
            error('mismatch')
        end
          
    else
        % number of function evaluation inputs and number of outputs match
        varargout = cell(1,nOutputs);

        %fill cell array with zeros matrix using N_bins dimensions
        for f = 1:numel(func)
            if length(N_bins) == 1
                varargout{f} = zeros(N_bins,1);
            else
                varargout{f} = zeros(N_bins);
            end
        end

        %loop through all bins one-by-one
        for bin = 1:numel(varargout{1})

            dim_inds = cell(1, numel(bin_order));
            [dim_inds{:}] = ind2sub(size(varargout{1}),bin);

            indices = true(size(data,1),1);

            % bin in all dimensions
            for bin_ch = 1:length(bin_order)
                indices = indices & data(:,bin_order(bin_ch))>bin_edges{bin_ch}(dim_inds{bin_ch}) & data(:,bin_order(bin_ch))<=bin_edges{bin_ch}(dim_inds{bin_ch}+1);
            end

            if numel(func)==1
                varargout{f}(bin) = func(data(indices,bin_eval));
            else
                for f = 1:numel(func)
                    varargout{f}(bin) = func{f}(data(indices,bin_eval));
                end
            end
        end

    
    end

end