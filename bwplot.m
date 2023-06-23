function bwplot(y)

    pos = get(gcf,'position');
    set(gcf,'position',[pos(1)         pos(2)         166         pos(4)])
    
    x = 1;
    
    c = [0.5 0.5 0.5];
    
    plot(normrnd(x,0.05,[length(y),1]),y,'.','color',c)

    q5 = prctile(y,5);
    q25 = prctile(y,25);
    q75 = prctile(y,75);
    q95 = prctile(y,95);
    
    med = median(y);
    
    rectangle('Position',[x-0.25 q25 0.5 q75-q25],'EdgeColor','k','LineWidth',1.5)
    
    line([x-0.25 x+0.25],[med med],'Color','k','LineWidth',1.5)
    
    line([x x],[q5 q25],'Color','k','LineWidth',1.5)
    line([x x],[q75 q95],'Color','k','LineWidth',1.5)
    line([x-0.2 x+0.2],[q5 q5],'Color','k','LineWidth',1.5)
    line([x-0.2 x+0.2],[q95 q95],'Color','k','LineWidth',1.5)

   set(gca,'xlim',[x-1 x+1],'xtick',[])%,'ylim',[-2.5 2.5])
end

