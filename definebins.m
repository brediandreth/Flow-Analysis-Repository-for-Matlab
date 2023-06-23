function bin_edges = definebins(varargin)
    
    % DEFINEBINS(N_bins)
    % DEFINEBINS(N_bins, LB, UB, scale)
    % caluclated bin edges vectors for each bin.
    % default scale is biexp with 
    % LB, UB, scale optional
    
    % DEFINEBINS(bin_order, samples)
    % DEFINEBINS(bin_order, samples, morphogate)
    % DEFINEBINS(bin_order, samples, scale)
    % DEFINEBINS(bin_order, samples, morphogate, scale)
    % DEFINEBINS(bin_order, samples, scale, morphogate)
    % calculated bins for given set of samples so that LB and UB are at the
    % 1st and 99th percentile of the lowest value dataset and calculates
    % N_bins in each channel so that each bin has >=200 cells
    % scale optional
 
    
    switch nargin
        case 1
            % DEFINEBINS(N_bins)
            if isa(varargin{1},'double')
                N_bins = varargin{1};
                LB = lin2logicle(0);
                UB = lin2logicle(1e5);
                scale = 'biexp';
            else
                error('BAD')
            end
            
        case 2
            % DEFINEBINS(N_bins, scale)
            % DEFINEBINS(bin_order, samples)
            if isa(varargin{1},'double') && (isa(varargin{2},'char') || isa(varargin{2},'cell'))
                if isa(varargin{2},'char') && any(strcmp(varargin{2},{'log','linear','biexp'}))
                    N_bins = varargin{1};
                    LB = lin2logicle(0);
                    UB = lin2logicle(1e5);
                    scale = varargin{2};
                else 
                    scale = 'biexp';
                    [N_bins, LB, UB] = calculatebins(bin_order, samples, morphogate, scale);
                    
                end
            else
                error('BAD')
            end
            
        case 3
            % DEFINEBINS(N_bins, LB, UB)
            % DEFINEBINS(bin_order, samples, morphogate)
            % DEFINEBINS(bin_order, samples, scale)
            if isa(varargin{1},'double') && isa(varargin{2},'double') && isa(varargin{3},'double')
                N_bins = varargin{1};
                LB = varargin{2};
                UB = varargin{3};
                scale = 'biexp';
            elseif isa(varargin{1},'double') && (isa(varargin{2},'char') || isa(varargin{2},'cell')) && isa(varargin{3},'struct')
                bin_order = varargin{1};
                samples = varargin{2};
                morphogate = varargin{3};
                scale = 'biexp';
                [N_bins, LB, UB] = calculatebins(bin_order, samples, morphogate, scale);
            elseif isa(varargin{1},'double') && (isa(varargin{2},'char') || isa(varargin{2},'cell')) && isa(varargin{3},'char')
                bin_order = varargin{1};
                samples = varargin{2};
                morphogate = [];
                scale = varargin{3};
                [N_bins, LB, UB] = calculatebins(bin_order, samples, morphogate, scale);
            else
                error('BAD')
            end
            
        case 4
            % DEFINEBINS(N_bins, LB, UB, scale)
            % DEFINEBINS(bin_order, samples, morphogate, scale)
            % DEFINEBINS(bin_order, samples, scale, morphogate)
            if isa(varargin{1},'double') && isa(varargin{2},'double') && isa(varargin{3},'double') && isa(varargin{4},'char')
                N_bins = varargin{1};
                LB = varargin{2};
                UB = varargin{3};
                scale = varargin{4};
            elseif isa(varargin{1},'double') && (isa(varargin{2},'char') || isa(varargin{2},'cell'))...
                    && isa(varargin{3},'char') && isa(varargin{4},'struct')
                bin_order = varargin{1};
                samples = varargin{2};
                morphogate = varargin{4};
                scale = varargin{3};
                [N_bins, LB, UB] = calculatebins(samples, bin_order, morphogate, scale);
            elseif isa(varargin{1},'double') && (isa(varargin{2},'char') || isa(varargin{2},'cell'))...
                    && isa(varargin{3},'struct') && isa(varargin{4},'char')
                bin_order = varargin{1};
                samples = varargin{2};
                morphogate = varargin{3};
                scale = varargin{4};
                [N_bins, LB, UB] = calculatebins(samples, bin_order, morphogate, scale);
            else
                error('BAD')
            end
        otherwise
            error('BAD')
    end
        
        
%     N_bins
%     LB
%     UB
%     scale
    
    bin_edges = cell(1,numel(N_bins));
    for n = 1:length(N_bins)
        switch scale
            case 'log'
                bin_edges{n} = logspace(log10(LB(n)),log10(UB(n)),N_bins(n)+1);
            case 'linear'
                bin_edges{n} = linspace(LB(n),UB(n),N_bins(n)+1);
            case 'biexp'
                bin_edges{n} = logicle2lin(linspace(lin2logicle(LB(n)),lin2logicle(UB(n)),N_bins(n)+1));
        end
    end
    
    
    function [N_bins, LB, UB] = calculatebins(bin_order, samples, gate, scale)
        
        if isa(samples,'char')
            samples = {samples};
        end
        
        for f = 1:numel(samples)
            if isempty(gate)
                data_raw = getflowdata(samples{f}, bin_order);
            else
                data_raw = getflowdata(samples{f}, bin_order, gate);
            end
        end
        
        N_bins = 1000;
        LB = 1000;
        UB = 1000;
        
    end
    
        
    return
    
    
    if ~exist('scale', 'var')
        scale = 'biexp';
    end
    

    bin_edges = cell(1,numel(N_bins));
    for i = 1:length(N_bins)
        
            switch scale
                case 'log'
                case 'linear'
                case 'biexp'
                    if exist('LB') && exist('UB')
                        bin_edges{i} = logicle2lin(linspace(lin2logicle(LB(i)),lin2logicle(UB(i)),N_bins(i)+1));
                    else
                        bin_edges{i} = logicle2lin(linspace(lin2logicle(0),4,N_bins(i)+1));
                    end
                otherwise
                    error()
            end
            
    end
            
    
    
    
%     % make colorscale
%     % NEED tO FIX THIS
%     if numel(bin_order) == 0
%         colord = [];
%     elseif length(bin_order) == 1
%         reds = zeros(1,N_bins(1));
%         greens = linspace(0,0.8,N_bins(1));
%         blues = linspace(0.5,1,N_bins(1));
%         colord = zeros(3,N_bins(1));
%         for b =1:N_bins(1)
%             colord(:,b) = [reds(b), greens(b), blues(b)];
%         end
%     elseif length(bin_order) == 2
%         reds = linspace(0,0.8,N_bins(1));
%         greens = linspace(0,0.8,N_bins(2));
%         blues = linspace(0.5,1,N_bins(2));
%         colord = zeros(3,N_bins(1),N_bins(2));
%         for r =1:N_bins(1)
%             for b =1:N_bins(2)
%                 colord(:,r,b) = [reds(r), greens(b), blues(b)];
%             end
%         end
%     end
    


end