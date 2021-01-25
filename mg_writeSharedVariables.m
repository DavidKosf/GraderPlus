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
%   This function allows storing variables created in a test for later use 
%   in following tests.
%
%Inputs:
%     varargin (strings / char arrays)
%         Names of variables that shall be stored
% 
% Outputs:
%     success (bool)
%         Indicates if the storing operation was successful


function [success] = mg_writeSharedVariables(varargin)

    success = true();
    try
       %varargin to formatted string
       vars = "";
       for varName = varargin
           vars = vars + ",'" + varName{:} + "'";
       end
       
       %add append when file exists to prevent override
       append = "";
       if isfile('mg_sharedvarstorage.mat')
           append = ",'-append'";
       end
       
       % Exclude grader vars
       exclude = ",'-regexp','^(?!(currentFigureHandles|previousFigureHandles|referenceVariables|seed|show)$).'";
       
       %evaluate function in caller
       fncCall = "save('mg_sharedvarstorage.mat' " + vars + append + exclude + ");";
       evalin('caller', fncCall);
    catch ME
        %error handling
        disp(ME);
        success = false();
    end
end

