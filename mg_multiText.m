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
%Function Name: mg_multiText
%
%Description:
%   Generation of a repetitive multiline text.
%
%Inputs:
%   msg (string)
%       The base message that shall be repeated. '%s' can be used as a placeholder
%
%   varargin (strings)
%       Replacements for the '%s' placeholder. The amount of lines is equal to the amount of
%       given strings. String arrays can be used.
% 
%Outputs:
%   message_final (string)
%       The generated message.
%
%Additional
%   Tests can be failed by creating an error:
%  error(multiText(msg, imput), '')


function message_final = mg_multiText(message, varargin)

    %varargin to string array
    input = [varargin{:}];
    
    %message construction
    message_final = "";
    for keyword = input
        if strcmp(keyword,"")
            continue
        end
        string = strcat(strrep(message, '%s', keyword)," \n");
        message_final = strcat(message_final, string);
    end     
end

