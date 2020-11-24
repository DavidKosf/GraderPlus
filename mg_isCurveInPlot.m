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
%Function Name: mg_isCurveInPlot
%
%Description:
%     This function alloes you to search the current graphic for lines (graphs)
%     that fit certain requirements. Every line property can be checked.
%
%Inputs:
%     varargin (char array - value pairs)
%         Property and values pairs.
%         There must be an even number of inputs. At least 2 must be given (one roperty and one value).
%         Properties are:
%         'AlignVertexCenters','Annotation','BeingDeleted','BusyAction',
%         'ButtonDownFcn','Children','Clipping','Color','CreateFcn','DataTipTemplate',
%         'DeleteFcn','DisplayName','HandleVisibility','HitTest','Interruptible','LineJoin',
%         'LineStyle','LineWidth','Marker','MarkerEdgeColor','MarkerFaceColor','Parent','PickableParts',
%         'Selected','SelectionHighlight','Tag','Type','UIContextMenu','UserData','Visible','XData','XDataMode',
%         'XDataSource','YData','YDataMode','YDataSource','ZData','ZDataMode','ZDataSource'
%Outputs:
%     result (bool)
%         True if specified line is in the current plot (drawn by student solution)
%
%Usage:
%     mg_isCurveInPlot(Prop1, Value1, Prop2, value2, ... , PropN, ValueN);
%Example:
%     mg_isCurveInPlot('XData', [1,2,3,4,5], 'YData', [1,4,9,16,25], 'Color', [0, 0.5, 0.5]);



function result = mg_isCurveInPlot(varargin)
    result = false();
    possibleProperties = ["AlignVertexCenters","Annotation","BeingDeleted","BusyAction","ButtonDownFcn","Children","Clipping","Color","CreateFcn","DataTipTemplate","DeleteFcn","DisplayName","HandleVisibility","HitTest","Interruptible","LineJoin","LineStyle","LineWidth","Marker","MarkerEdgeColor","MarkerFaceColor","Parent","PickableParts","Selected","SelectionHighlight","Tag","Type","UIContextMenu","UserData","Visible","XData","XDataMode","XDataSource","YData","YDataMode","YDataSource","ZData","ZDataMode","ZDataSource"];
    %% Check for empty input argumetns
    if (isempty(varargin))
        error("No arguments given.\nUsage: isCurveInCurrentPlot('Property1', 'Wanted1', 'Property2', 'Wanted2', ...\nProperties can be:\n'AlignVertexCenters'\n'Annotation'\n'BeingDeleted'\n'BusyAction'\n'ButtonDownFcn'\n'Children'\n'Clipping'\n'Color'\n'CreateFcn'\n'DataTipTemplate'\n'DeleteFcn'\n'DisplayName'\n'HandleVisibility'\n'HitTest'\n'Interruptible'\n'LineJoin'\n'LineStyle'\n'LineWidth'\n'Marker'\n'MarkerEdgeColor'\n'MarkerFaceColor'\n'Parent'\n'PickableParts'\n'Selected'\n'SelectionHighlight'\n'Tag'\n'Type'\n'UIContextMenu'\n'UserData'\n'Visible'\n'XData'\n'XDataMode'\n'XDataSource'\n'YData'\n'YDataMode'\n'YDataSource'\n'ZData'\n'ZDataMode'\n'ZDataSource'\n", "");
    end
    
    %% Check if amount of inputs is a multiple of 2
    if mod(length(varargin),2) ~= 0
        error("Amount of input Arguments must be a multiple of 2!\n\nUsage: isCurveInCurrentPlot('Property1', 'Wanted1', 'Property2', 'Wanted2', ...\nProperties can be:\n'AlignVertexCenters'\n'Annotation'\n'BeingDeleted'\n'BusyAction'\n'ButtonDownFcn'\n'Children'\n'Clipping'\n'Color'\n'CreateFcn'\n'DataTipTemplate'\n'DeleteFcn'\n'DisplayName'\n'HandleVisibility'\n'HitTest'\n'Interruptible'\n'LineJoin'\n'LineStyle'\n'LineWidth'\n'Marker'\n'MarkerEdgeColor'\n'MarkerFaceColor'\n'Parent'\n'PickableParts'\n'Selected'\n'SelectionHighlight'\n'Tag'\n'Type'\n'UIContextMenu'\n'UserData'\n'Visible'\n'XData'\n'XDataMode'\n'XDataSource'\n'YData'\n'YDataMode'\n'YDataSource'\n'ZData'\n'ZDataMode'\n'ZDataSource'\n", "");
    end
    
    %% Generate cell of searched for properties from varargin
    if length(varargin) == 2
        properties = varargin;
    else
       properties = reshape(varargin, [2, length(varargin)/2])'; 
    end
    
    %% Check if wanted properties can be checked
    stringProperties = [];
    for i = 1:size(properties,1)
        stringProperties = [stringProperties; string(properties(i,1))];
    end
    
    if ~all(contains(stringProperties, possibleProperties))
        error("Invalid Property. \nProperties can be:\n'AlignVertexCenters'\n'Annotation'\n'BeingDeleted'\n'BusyAction'\n'ButtonDownFcn'\n'Children'\n'Clipping'\n'Color'\n'CreateFcn'\n'DataTipTemplate'\n'DeleteFcn'\n'DisplayName'\n'HandleVisibility'\n'HitTest'\n'Interruptible'\n'LineJoin'\n'LineStyle'\n'LineWidth'\n'Marker'\n'MarkerEdgeColor'\n'MarkerFaceColor'\n'Parent'\n'PickableParts'\n'Selected'\n'SelectionHighlight'\n'Tag'\n'Type'\n'UIContextMenu'\n'UserData'\n'Visible'\n'XData'\n'XDataMode'\n'XDataSource'\n'YData'\n'YDataMode'\n'YDataSource'\n'ZData'\n'ZDataMode'\n'ZDataSource'\n", "");
    end
    %% Get line Array of current plot
    handle = findobj(gca, 'Type', 'line');
    %% Check if plot is existant
    if sum(size(handle) > [0, 0]) == 0
        error("No plot is existant.");
    end
    
    %% Cycle through each curve in the plot, break when one that pleases requirements is found
    for i = 1:length(handle)
        correctProperty = [];
        currentLine = handle(i);
        for n = 1:size(properties,1) %% Create satisfaction array
            correctProperty = [correctProperty; isPropertyCorrect(currentLine,properties{n,1},properties{n,2})];
        end
        if all(correctProperty) %% Does line satisfy all requirents
            result = true();
            break;
        end
    end
    
    
    %% subfunction to determine if line has a correct property value
    function isCorrect = isPropertyCorrect(line, property, desiredValue)
        value = get(line, property);
        
        if(any(size(value) ~= size(desiredValue)))
            isCorrect = 0;
            return
        end
        
        % Double array? -> tolerance
        if isequal(class(desiredValue),'double') && isequal(class(value),'double')
            isCorrect = all(abs(desiredValue-value) < 0.01);
        else
            if all(value == desiredValue) == 0
                isCorrect = 0;
            else
                isCorrect = 1;
            end 
        end
        
    end


end