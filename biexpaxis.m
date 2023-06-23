function biexpaxis(ax,axis_flags)
%BIEXPAXIS(AX,AXIS_FLAGS) converts the linear scaled axis ax to a
%logicle-scaled one
%optional: axis_flags are axes to convert, e.g. 'x','yz' (default is all
%axes)
%Note: data plotted should be logicle transformed
%Note: for now axes labels are hard-coded for default logicle transform
%values

    
    [T,M,r] = getLogicleParams;

    hha(1) = ax;
    
    % check if 2D or 3D plot
    viewprops = get(ax,'view');
    az = viewprops(1);
    if az == 0
        view3D = 0;
    else
        view3D = 1;
    end
    
    if ~exist('axis_flags','var')
        if ~view3D
            axis_flags = 'xy';
        else
            axis_flags = 'xyz';
        end
    else
        if ~view3D && contains(axis_flags,'z')
            axis_flags(regexp(axis_flags,'[z]'))=[];
        end
    end

    
    exponents = floor(log10(abs(r))):floor(log10(T));
    LargeTickVals=lin2logicle([-10^floor(log10(abs(r))), 0, 10.^exponents]);
    
    for axis_i = 1:numel(axis_flags)
        set(hha(1),...
            [axis_flags(axis_i) 'tick'], LargeTickVals,...
            [axis_flags(axis_i) 'ticklabel'],{'-10^{2}','','10^{2}','10^{3}','10^{4}','10^{5}'},... %for now hard-coded
            [axis_flags(axis_i) 'lim'],[lin2logicle(-10.^floor(log10(abs(r)))) M],...
            [axis_flags(axis_i) 'grid'],'on')
    end
    set(hha(1),'xgrid','on','ygrid','on','zgrid','on',...
        'xminorgrid','off','yminorgrid','off','zminorgrid','off')
    
        hha(2)=axes('Position',get(hha(1),'Position'),'Color','None');
%         A1_struct = get(hha(1));
%         A1_fields = fieldnames(A1_struct);
%         for prop = 1:numel(A1_fields)
%             if ~strcmp(A1_fields{prop},'CurrentPoint') && ~strcmp(A1_fields{prop},'BeingDeleted') && ~strcmp(A1_fields{prop},'Type')...
%                     && ~strcmp(A1_fields{prop},'XAxis') && ~strcmp(A1_fields{prop},'YAxis') && ~strcmp(A1_fields{prop},'ZAxis')...
%                     && ~strcmp(A1_fields{prop},'Legend') && ~strcmp(A1_fields{prop},'TightInset') && ~strcmp(A1_fields{prop},'Children')...
%                     && ~strcmp(A1_fields{prop},'HandleVisibility')...
%                     && ~strcmp(A1_fields{prop},'ZLabel')
%                 before = get(hha(2),A1_fields{prop});
%                 set(hha(2),A1_fields{prop},get(hha(1),A1_fields{prop}))
%                 changeTo = get(hha(1),A1_fields{prop});
%                 after = get(hha(2),A1_fields{prop});
%             end
%         end
        TL = 0.6*get(hha(1),'TickLength');
        TickVals=lin2logicle([[-100:10:100] [2:9].*10^2 [1:9].*10^3 [1:9].*10^4]);

        for axis_i = 'xyz'
            if contains(axis_flags,axis_i)
                set(hha(2),...
                    'color','none',...
                    [axis_i 'tick'], TickVals,...
                    [axis_i 'ticklabel'],{},...
                    [axis_i 'grid'],'off',...
                    'TickLength',TL)
            else
                set(hha(2),...
                    'color','none',...
                    [axis_i 'tick'], [],...
                    [axis_i 'ticklabel'],{},...
                    [axis_i 'grid'],'off',...
                    'TickLength',TL)
            end
        end


        link = linkprop(hha, {'CameraUpVector', 'CameraPosition', 'CameraTarget', 'XLim', 'YLim', 'ZLim'});   
        setappdata(gcf, 'StoreTheLink', link);
        
end