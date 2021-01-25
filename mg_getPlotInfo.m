%=== GraderPlus ===
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
    data.titleString = string(handle.Title.String);
    
    %%Labels
    data.xLabel = string(handle.XLabel.String);
    data.yLabel = string(handle.YLabel.String);
    data.zLabel = string(handle.ZLabel.String);
    
    %%Limits
    data.xLimits = handle.XLim;
    data.yLimits = handle.YLim;
    data.zLimits = handle.ZLim;
    
    %%Scales
    data.xScale = string(handle.XScale);
    data.yScale = string(handle.YScale);
    data.zScale = string(handle.ZScale);
    
    %%Grids
    data.xGrid = isequal(handle.XGrid, 'on');
    data.yGrid = isequal(handle.YGrid, 'on');
    data.zGrid = isequal(handle.ZGrid, 'on');
    
    %%Lines
    data.lines = findobj(gca, 'Type', 'line');
    
    %%Linecount
    data.lineCount = size(data.lines, 1);
    
    %%Legend
    data.legend = handle.Legend;
    
    %%Legend present
    data.legendAvailable = sum(size(data.legend) > 0) ~= 0;
    
    %%Legend Title
    try
        data.legendTitle = string(data.legend.Title.String);
    catch
        data.legendTitle = "";
    end
    
    
    %%Legend Text // Order is order of adding graphs
    try
        data.legendText = string(data.legend.String);
    catch
        data.legendText = "";
    end
    
end

