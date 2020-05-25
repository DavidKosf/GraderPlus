%varargin (Char array1, value1, char array2, value2, ... , char arrrayN, valueN)
% possible requirements can be: 'Color','LineStyle','LineWidth','Marker','MarkerSize','MarkerFaceColor','XData','YData','ZData','DisplayName'

%result (logical): 1 if line is in plot, 0 if not

function result = mg_isCurveInPlot(varargin)
    result = false();
    possibleProperties = ["Color","LineStyle","LineWidth","Marker","MarkerSize","MarkerFaceColor","MarkerEdgeColor","XData","YData","ZData","DisplayName"];
    %% Check for empty input argumetns
    if (isempty(varargin))
        error("No arguments given.\nUsage: isCurveInCurrentPlot('Property1', 'Wanted1', 'Property2', 'Wanted2', ...\nProperties can be:\n'Color'\n'LineStyle'\n'LineWidth'\n'Marker'\n'MarkerSize'\n'MarkerFaceColor'\n'XData'\n'YData'\n'ZData'", "");
    end
    
    %% Check if amount of inputs is a multiple of 2
    if mod(length(varargin),2) ~= 0
        error("Amount of input Arguments must be a multiple of 2!\nUsage: isCurveInCurrentPlot('Property1', 'Wanted1', 'Property2', 'Wanted2', ...\nProperties can be:\n'Color'\n'LineStyle'\n'LineWidth'\n'Marker'\n'MarkerSize'\n'MarkerFaceColor'\n'XData'\n'YData'\n'ZData'","");
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
        error("Invalid Property. Properties can be:\n'Color'\n'LineStyle'\n'LineWidth'\n'Marker'\n'MarkerSize'\n'MarkerFaceColor'\n'XData'\n'YData'\n'ZData'","");
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
        
        if all(value == desiredValue) == 0
            isCorrect = 0;
        else
            isCorrect = 1;
        end
    end


end