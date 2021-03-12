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
%Function Name: mg_writeSharedVariables
%
%Description:
%   This function allows loading variables stored with the mg_writeSharedVariables
%   function
%
%Inputs:
%   varargin (strings / char arrays)
%       Names of variables that shall be loaded. If no argument is given, all stored
%       variables are loaded
% 
% Outputs:
%     success (bool)
%         Indicates if the loading operation was successful


function success = mg_loadSharedVariables(varargin)
    
    success = true();
    
    try
        %varargin to formatted string
        vars = "";
        for varName = varargin
            vars = vars + ",'" + varName{:} + "'";
        end
        
        %evaluate function in caller
        fncCall = "load('mg_sharedvarstorage.mat' " + vars +");";
        evalin('caller', fncCall);
        
    catch
        success = false();
    end
        
end

