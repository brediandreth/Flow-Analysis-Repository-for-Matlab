function scatterplotbins(data,ch_dims,bin_order,bin_order2plot,bin_edges,ms)
%SCATTERPLOTBINS plots the data defined by x, y and z (z is optional) and
%colors the points according to their bin.
% ch_dims : [x_dim,y_dim] or [x_dim,y_dim,z_dim] eg [chB,chR] for scatter
% plotting
% binorder2plot : logical of dimensions to color bins by
%
%   SCATTERPLOTBINS(X,Y,BIN_EDGES) plots scatterplot of vectors x and y. If
%   bin_edges
% size of bin_edges determines how many dimensions to bin
%   SCATTERPLOTBINS(DAT,[XIND,YIND,ZIND],BIN_EDGES)
%   SCATTERPLOTBINS(_,CMAPS)
% function scatterplotbins(x,y,bin_edges)
%SCATTERPLOTBINS plots the data defined by x, y and z (z is optional) and
%colors the points according to their bin.
%
%   SCATTERPLOTBINS(X,Y,BIN_EDGES) plots scatterplot of vectors x and y. If
%   bin_edges
% size of bin_edges determines how many dimensions to bin
%   SCATTERPLOTBINS(DAT,[XIND,YIND,ZIND],BIN_EDGES)
%   SCATTERPLOTBINS(_,CMAPS)


if size(data,2) ==2

    if exist('ms','var')
        plot(lin2logicle(data(:,ch_dims(1))),lin2logicle(data(:,ch_dims(2))),'k.','markersize',ms)
    else
        plot(lin2logicle(data(:,ch_dims(1))),lin2logicle(data(:,ch_dims(2))),'k.')
    end

    % find number of bins in each diension
    N_bins = ones(1,numel(bin_edges));
    for b= 1:numel(bin_order2plot)
        if bin_order2plot(b)
            N_bins(b) = (numel(bin_edges{b})-1);
        else
            N_bins(b) = 1;
        end
    end
    %calculate total number of bins
    N_bins_tot = prod(N_bins);

    
    cmap1 = cool(6);
    cmap2 = spring(7);
    cmap = [cmap1(2:end,:); cmap2(2:end-1,:)];
    
    set(gca,'ColorOrderIndex',1,'ColorOrder',cmap,'NextPlot', 'replacechildren')

    % loop through bins by linear index
    for bin = 1:N_bins_tot

        out_inds = cell(1, numel(bin_edges));
        [out_inds{:}] = ind2sub(N_bins,bin); %get row and col subscript index of bin linear number

        indices = true(size(data,1),1);

        for chan_ind = 1:length(bin_order2plot)
            if bin_order2plot(chan_ind)
                indices = indices & data(:,bin_order(chan_ind))>bin_edges{chan_ind}(out_inds{chan_ind}) & data(:,bin_order(chan_ind))<=bin_edges{chan_ind}(out_inds{chan_ind}+1);
            end
        end

        hold on
        if exist('ms','var')
            plot(lin2logicle(data(indices,ch_dims(1))),lin2logicle(data(indices,ch_dims(2))),'.','markersize',ms)
        else
            plot(lin2logicle(data(indices,ch_dims(1))),lin2logicle(data(indices,ch_dims(2))),'.')
        end

    end
    
else
    
    if exist('ms','var')
        plot(lin2logicle(data(:,ch_dims(1))),lin2logicle(data(:,ch_dims(2))),'k.','markersize',ms)
    else
        plot(lin2logicle(data(:,ch_dims(1))),lin2logicle(data(:,ch_dims(2))),'k.')
    end

    % find number of bins in each diension
    N_bins = ones(1,numel(bin_edges));
    for b= 1:numel(bin_order2plot)
        if bin_order2plot(b)
            N_bins(b) = (numel(bin_edges{b})-1);
        else
            N_bins(b) = 1;
        end
    end
    %calculate total number of bins
    N_bins_tot = prod(N_bins);

%     set(gca,'ColorOrderIndex',1,'ColorOrder',cmap_ocean(N_bins_tot),'NextPlot', 'replacechildren')
%     set(gca,'ColorOrderIndex',1,'ColorOrder',cool(N_bins_tot),'NextPlot', 'replacechildren')
    set(gca,'ColorOrderIndex',1,'ColorOrder',cmap_4(N_bins_tot),'NextPlot', 'replacechildren')

%     cmap1 = cool(6);
%     cmap2 = spring(8);
%     cmap = [cmap1(2:end,:); cmap2(3:end-1,:)];
%     set(gca,'ColorOrderIndex',1,'ColorOrder',cmap,'NextPlot', 'replacechildren')

    % loop through bins by linear index
    for bin = 1:N_bins_tot

        out_inds = cell(1, numel(bin_edges));
        [out_inds{:}] = ind2sub(N_bins,bin); %get row and col subscript index of bin linear number

        indices = true(size(data,1),1);

        for chan_ind = 1:length(bin_order2plot)
            if bin_order2plot(chan_ind)
                indices = indices & data(:,bin_order(chan_ind))>bin_edges{chan_ind}(out_inds{chan_ind}) & data(:,bin_order(chan_ind))<=bin_edges{chan_ind}(out_inds{chan_ind}+1);
            end
        end

        hold on
        if exist('ms','var')
            plot(lin2logicle(data(indices,ch_dims(1))),lin2logicle(data(indices,ch_dims(2))),'.','markersize',ms)
        else
            plot(lin2logicle(data(indices,ch_dims(1))),lin2logicle(data(indices,ch_dims(2))),'.')
        end

    end
    
end

    


end