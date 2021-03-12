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
%Function Name: mg_varExist
%
%Description:
%   This function checks if variables were declared in a solution
%
%Inputs:
%     varargin (strings / char arrays)
%         Names of variables that shall be checked
% 
%Outputs:
%   success (bool)
%       true: all variables were defined
%       false: at least one variable wasnt defined
%
%   missing (string array)
%       names of undefined variables. Empty if all were defined. 

function [success, missing] = mg_varExist(varargin)

    % varargin to string vector
    vars = [varargin{:}];

    % logic vector: existing/required vars
    usedVars = ismember(vars, evalin('caller','who'));

    % All vars used
    if all(usedVars)
        success = true();
        missing = [];
    else
        success = false();
        
        % Find missing vars
        missing = strings(1, length(vars) - sum(usedVars));
        i = 1;
        for n = 1:1:length(vars)
            if ~usedVars(n)
                missing(i) = vars(n);
                i = i + 1;
            end
        end
    end
end

