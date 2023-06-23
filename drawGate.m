function gateout = drawGate(data, axisScales, channels, fh)

    xdat = data(:,1);
    ydat = data(:,2);

    if exist('fh','var')
        figure(fh)
        hold on
    else
        figure
    end
    
    switch axisScales
        case 'loglog'
            loglog(xdat,ydat,'.','MarkerSize',2)
            set(gca, 'XScale', 'log','YScale', 'log')
        case 'semilogy'
            semilogy(xdat,ydat,'.','MarkerSize',2)
            set(gca, 'YScale', 'log')%,'xlim', [0 250000])
        case 'semilogx'
            semilogx(xdat,ydat,'.','MarkerSize',2)
            set(gca, 'XScale', 'log')
        case 'linear'
            plot(xdat,ydat,'.','MarkerSize',2)
        case 'biexp'
            plot(lin2logicle(xdat),lin2logicle(ydat),'.','MarkerSize',2)
            biexpaxis(gca)
    end
    hold on
    h = impoly;
    position = wait(h);
    

    if strcmp(axisScales,'biexp')
        gateout.pos = logicle2lin(position);
    else
        gateout.pos = position;
    end
    
    gateout.chs = channels;

end