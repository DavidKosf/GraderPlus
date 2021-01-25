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
%Function Name: mg_setTestStatus
%
%Description:
%     Wrapper function that creates an error to fail a task or do nothing.
%
% Inputs:
%     complete (bool)
%         True if the test is correct, false if you want it to fail
%     msg (string)
%         Message to be shown in the created error, that will fail a test.
%         Argument must nor be given if the test is not failed.


function  mg_setTestStatus(complete, msg)
    if ~complete
        error(msg, '');
    end
        
end

