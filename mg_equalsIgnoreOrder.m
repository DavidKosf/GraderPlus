%% pass -> 0:fail, 1:success, 2:not all vars used

function [pass, wrong, dupes] = mg_equalsIgnoreOrder(varNames, reference);

    if ~isequal(class(reference),'cell')
        error("Reference must be a Cell Array!");
    end


    checked = {};
    wrong =[];
    dupes = [];
    
    % Check if all Variables are used
    usedVars = ismember(varNames, evalin('caller','who'));
    if ~all(usedVars)
        pass = 2;
        return
    end
    for n = 1:length(varNames);
        %get Value
        varValue = evalin('caller', varNames(n));
        
        
        %check for dupe
        if cellContain(checked, varValue)
            dupes = [dupes, varNames(n)];
           	continue
        end
            
        %check if correct
        if cellContain(reference, varValue)
            checked{end+1} = varValue;
        else
            wrong = [wrong, varNames(n)];
        end
        
    end
    
    pass = (isempty(wrong) & isempty(dupes));
end

function res = cellContain(cellArray, object)
    if ~isempty(cellArray)
        logicalCell = cellfun(@(x) isequal(x, object), cellArray, 'UniformOutput', false);
        res = any([logicalCell{:}]);
    else
        res = 0;
    end
end

