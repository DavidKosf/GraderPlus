%=== Matlab Grader Framework ===
%
%Library for advanced testing in MATLAB® Grader 
%Created by David Kosfelder 
%for the Process Dynamics and Operations Group at TU Dortmund
% 
%Contact: david.kosfelder@tu-dortmund.de
%
%
%
%=== Function Summary ===
%
%Function Name: mg_getPlotInfo
%
%Description:
%   This functions summarizes information about the current plot.
%
%Outputs:
%   data (struct)
%         Struct with informations about the current plot.
%         To see all available fields browse the file.

function data = mg_getPlotInfo()

    handle = gca;
    data = struct;
    %%Title
    data.title = handle.Title;
    data.titleString = handle.Title.String;
    
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
    
    %%Grids
    data.xGrid = isequal(handle.XGrid, 'on');
    data.yGrid = isequal(handle.YGrid, 'on');
    data.zGrid = isequal(handle.ZGrid, 'on');
    
    %%Lines
    data.lines = findobj(gca, 'Type', 'line');
    
    %%Linecount
    data.linecount = size(data.lines, 1);
    
    %%Legend
    data.legend = handle.Legend;
    
    %%Legend present
    data.legendAvailable = sum(size(data.legend) > 0) ~= 0;
    
    %%Legend Title
    try
        data.legendTitle = data.legend.Title.String;
    catch
        data.legendTitle = "";
    end
    
    
    %%Legend Text // Order is order of adding graphs
    try
        data.legendText = data.legend.String;
    catch
        data.legendText = "";
    end
    
end

