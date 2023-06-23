function out = fit_persist1_2(samps, channelIDs, my_morpho_gate, AF, comp_matrix, bin_order, bin_eval)
    % fit with 1 independent variable, x using second variable (usually in
    % red channel) and binary y/n for PC vs X
    
    F_lin = @(a,D) lin2logicle(a(1)*(D)./(a(3)));
    F_lin_deg = @(a,D) lin2logicle(a(1)*(D)./(a(2) + a(3)));
    F_enz = @(a,D) lin2logicle((sqrt((-a(1).*(D) + a(2) + a(4).*a(3)).^2 + 4.*a(1).*(D).*a(4).*a(3)) + a(1).*(D) - a(2) - a(4).*a(3))./(2.*a(3)));

%     F_lin = @(a,D) lin2logicle(a(1)*logicle2lin(D)./(a(3)));
%     F_lin_deg = @(a,D) lin2logicle(a(1)*logicle2lin(D)./(a(2) + a(3)));
%     F_enz = @(a,D) lin2logicle((sqrt((-a(1).*logicle2lin(D) + a(2) + a(4).*a(3)).^2 + 4.*a(1).*logicle2lin(D).*a(4).*a(3)) + a(1).*logicle2lin(D) - a(2) - a(4).*a(3))./(2.*a(3)));

   
   funcs1 =  {F_lin,F_lin_deg};
   funcs2 =  {F_lin,F_enz};
    

    fig = figure;

    for i = 1:length(samps)
            dat_raw = getflowdata(samps{i}, channelIDs, my_morpho_gate);

            % use calculated params to compensate data
            dat_comp = compensate(dat_raw,AF,comp_matrix);

            xdat = 2.*dat_comp(:,bin_order); % inputs
            ydat = dat_comp(:,bin_eval); % output
            
            inds = all(xdat>100,2);
            
            x_cell{i} = (xdat(inds,:));
            y_cell{i} = lin2logicle(ydat(inds,:)); %logicle transform for fitting
%             x_cell{i} = (xdat(:,:));
%             y_cell{i} = lin2logicle(ydat(:,:)); %logicle transform for fitting

    end
        
    beta10 = [10 100 10 1];
    [beta1,r,J,Sigma,mse,errorparam,robustw] = nlinmultifit(x_cell, y_cell, funcs1, beta10);
    beta20 = [1 1000 1 10000];
    [beta2,r,J,Sigma,mse,errorparam,robustw] = nlinmultifit(x_cell, y_cell, funcs2, beta20);
    
    out = [beta1;beta2]

    ON_lin = beta1(1)/beta1(3);
    OFF_lin = beta1(1)/(beta1(2)+beta1(3));
    R_lin = ON_lin/OFF_lin;

    ON_enz = beta2(1)/beta2(3);
    OFF_enz = (beta2(1)*beta2(4))/beta2(2);
    R_enz = ON_enz/OFF_enz;

 
    figure(fig)
    box on
    set(gca,'ColorOrderIndex',3);
    hold on
    plot(lin2logicle(x_cell{1}),(y_cell{1}),'.')
    plot(lin2logicle(x_cell{2}),(y_cell{2}),'.')

    
    x_vals = lin2logicle(logspace(1,log10(3e5),500));
    plot(x_vals,funcs1{1}(beta1,logicle2lin(x_vals)),'k-','linewidth',2)
    plot(x_vals,funcs1{2}(beta1,logicle2lin(x_vals)),'k-','linewidth',2)
    
    plot(x_vals,funcs2{1}(beta2,logicle2lin(x_vals)),'r:','linewidth',2)
    plot(x_vals,funcs2{2}(beta2,logicle2lin(x_vals)),'r:','linewidth',2)

    text(0.5,4.2,['linear: ' num2str(R_lin)],'fontsize',14)
    text(0.5,4.0,['non-linear: ' num2str(R_enz)],'fontsize',14,'color','r')
    
    biexpaxis(gca)
    
    [~,pname] = fileparts(pwd);
    saveas(gcf,[pname, '_fig_', samps{1}(end-5:end-4), '_', samps{2}(end-5:end-4), '.png'])
    
    
    
    
  
    return
    
    
    
    
    
    
    
    %plotting
    N_eval = 14;
    x_vals_eval = [0 (logspace(1,5.6,N_eval-1))]';%.*ones(N_eval,length(bin_order));
    y_vals_store = zeros(N_eval,length(samps));
    
    
    for si = 1:length(samps)
        for sub = 1:numel(N_eval)
            % need to turn variable amount of indices into a vector to
            % access x_vals_eval
            [q{1:ndims(y_vals_store)-1}] = ind2sub([N_eval,1],sub)
            x_vals_eval(cell2mat(q))
            funcs{si}(beta,x_vals_eval(cell2mat(q))')
            ind2sub([N_eval,1],sub)
            y_vals_store(ind2sub([N_eval,1],sub)) = funcs{si}(beta,x_vals_eval(cell2mat(q)));
        end
    end
    
    out = y_vals_store
    
%         
%         
%         %plotting
%         x_vals = lin2logicle(logspace(1,log10(3e5),500));
%         
%         figure(1)
%         set(gca,'ColorOrderIndex',3);
%         hold on
%         if ~plotted1
%             plot(logicle2lin(x_cell{1}),logicle2lin(y_cell{1}),'.')
%             plot(logicle2lin(x_cell{2}),logicle2lin(y_cell{2}),'.')
% %             plot(log10(logicle2lin(x_cell{1})),log10(logicle2lin(y_cell{1})),'.')
% %             plot(log10(logicle2lin(x_cell{2})),log10(logicle2lin(y_cell{2})),'.')
%             set(gca,'xscale','log','yscale','log')
% %             set(gca,'xscale','lin','yscale','lin')
% %             axis([1,6,1,6])
%             axis([2,2e4,2,2e3])
%             plotted1 = 1;
%             return
%         end
%         
%         plot(logicle2lin(x_vals),logicle2lin(funcs{1}(beta,x_vals)),'k-','linewidth',2)
%         plot(logicle2lin(x_vals),logicle2lin(funcs{2}(beta,x_vals)),'k-','linewidth',2)
% %         plot(logicle2lin(x_vals),logicle2lin(funcs{1}(beta,x_vals)),'k-','linewidth',2)
% %         plot(logicle2lin(x_vals),logicle2lin(funcs{2}(beta,x_vals)),'k-','linewidth',2)
%         
%         figure(2)
%         set(gca,'ColorOrderIndex',3);
%         hold on
%         if ~plotted2
%             plot(x_cell{1},y_cell{1},'.')
%             plot(x_cell{2},y_cell{2},'.')
%             plotted2 = 1;
%         end
%         plot(x_vals,funcs{1}(beta,x_vals),'k-','linewidth',2)
%         plot(x_vals,funcs{2}(beta,x_vals),'k-','linewidth',2)
%     end
% 
% figure(1)
% hold on
% text(30,2e5,['linear: ' num2str(R_lin)],'fontsize',14)
% text(30,1e5,['non-linear: ' num2str(R_enz)],'fontsize',14)
% % text(1,4,['linear: ' num2str(R_lin)],'fontsize',14)
% % text(1,4,['non-linear: ' num2str(R_enz)],'fontsize',14)
% saveas(gcf,'loglog_plot_d1A.png')