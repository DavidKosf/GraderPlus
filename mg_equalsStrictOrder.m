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
%Function Name: mg_equalsStrictOrder
%
%Description:
%     This function compares multiple variables to the refernce values.
%
%Inputs:
%     varNames (string array)
%         Names of variables that shall be checked
% 
%Outputs:
%   pass (bool)
%       true: all variable values are correct
%       false: at least one variable value wasnt correct
%
%   missing (string array)
%       names of variables that do not match the reference.


function [pass, missing] = mg_equalsStrictOrder(varNames)
    pass = true();
    missing = [];
    
    for var = varNames
        
        try
            fncCall = "assessVariableEqual('" + var + "', referenceVariables."+var+");";
            evalin('caller', fncCall)
        catch
            pass = false();
            missing = [missing, var];
        end
    end
    
end

