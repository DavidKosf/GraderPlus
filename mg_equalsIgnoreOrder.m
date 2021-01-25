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
%ONLY FOR SCRIPT-BASED SOLUTIONS!
%
%Function Name: mg_equalsIgnoreOrder
%
%Description:
%     This function compares multiple variables to the refernce values.
%     varargin is a pool of possible solutions. As long as all given variables fit
%     into this pool, pass returns 1 (success)
%
%     You can also have one variable and check for multiple values.
%
%Inputs:
%     varNames (string array)
%         Names of variables that shall be checked
%     varargin
%         values that the variables should contain
%Outputs:
%   pass (int)
%       0
%           wrong values or dupes
%       1
%           all variables fit to the given references
%       2
%         not all variables were declared
%   wrong (string array)
%       names of variables that do not match the reference.
%   dupes (string array)
%       names of variables that are duplicates.


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

