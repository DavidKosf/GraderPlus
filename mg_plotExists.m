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
%Function Name: mg_plotExists
%
%Description:
%   This is just a wrapper that checks if a graph was created by the solution
%
%Outputs:
%   result (bool)
%       true: graph was created
%       false: graph was not created




function [result] = mg_plotExists()
    result = ishandle(1);
end

