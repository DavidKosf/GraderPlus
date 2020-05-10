% Returns struct with information about the current plot

function data = mg_getPlotInfo()

    handle = gca;
    data = struct;
    %%Title
    data.title = handle.Title.String;
    
    %%Labels
    data.xLabel = handle.XLabel.String;
    data.yLabel = handle.YLabel.String;
    data.zLabel = handle.ZLabel.String;
    
    %%Limits
    data.xLimits = handle.XLim;
    data.yLimits = handle.YLim;
    data.zLimits = handle.ZLim;
    
    %%Scales
    data.xScale = handle.XScale;
    data.yScale = handle.YScale;
    data.zScale = handle.ZScale;
    
    %%Lines
    data.lines = findobj(gca, 'Type', 'line');
    
    %%Linecount
    data.linecount = size(data.lines, 1);
    
    %%Legend
    data.legend = handle.Legend;
    
    %%Legend present
    data.legendAvailable = sum(size(data.legend) > 0) ~= 0;
    
    %%Legend Title
    data.legendTitle = data.legend.Title.String;
    
    %%Legend Text // Order is order of adding graphs
    data.legendText = data.legend.String;
end

