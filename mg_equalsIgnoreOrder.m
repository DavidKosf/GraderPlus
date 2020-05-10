% varNames (String array): String array of variable names in the student's solution. ["varA","varB"]
% varargin (reference values/variables): Cell array containg the reference variables.

% pass (int) -> 0:fail (wrong values or dupes), 1:success, 2:not all vars used (any variable named in varNames is not used by student)
% wrong (String array): String array containin variable names with wrong values
% dupes (String array): String array containin variable names with duplicate values (only correct values that already have been recognized)

function [pass, wrong, dupes] = mg_equalsIgnoreOrder(varNames, varargin)

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
        if cellContain(varargin, varValue)
            checked{end+1} = varValue;
        else
            wrong = [wrong, varNames(n)];
        end
        
    end
    
    pass = (isempty(wrong) & isempty(dupes));
end


% helper to checkt if object is in cell array
function res = cellContain(cellArray, object)
    if ~isempty(cellArray)
        logicalCell = cellfun(@(x) isequal(x, object), cellArray, 'UniformOutput', false);
        res = any([logicalCell{:}]);
    else
        res = 0;
    end
end

