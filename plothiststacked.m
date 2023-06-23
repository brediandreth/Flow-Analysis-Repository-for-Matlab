function geomeans = plothiststacked(data, colors)

    
%     f = figure;
    geomeans = zeros(1,size(data,2));

    for s = 1:size(data,2)
        dat = data{s};
        [N,edges] = histcounts(lin2logicle(dat));
        centers = (edges(1:end-1)+edges(2:end))./2;
        Y = [0 centers 4.5];
        X = [s s+N./max(N).*0.8 s];
        
%         figure(f)
        hold on
        fill(X,Y,colors(s,:),'EdgeColor',colors(s,:).*0.5,'linewidth',1.5)
        
        
        geomeans(s) = logicle2lin(mean(lin2logicle(dat)));
    end
    
    
    set(gca,'xlim',[1 size(data,2)+1],'xtick',[])
    biexpaxis(gca,'y')
    box on


end