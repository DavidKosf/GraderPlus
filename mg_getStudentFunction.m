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
%Function Name: mg_getStudentFunction
%
%Description:
%     This function checks if a solution is a function and has a desired number of in- and outputs
%     Similar to mg_checkStudentFunction
%
% Inputs:
%     inputs (int)
%         Amount of desired inputs
%     outputs (int)
%         Amount of desired outputs
%         
%Outputs:
%   result (bool / string)
%       0
%             No solution function fitting the number of in- and outputs was found.
%       <function name>
%             Fitting solution was found. Name of the function is the result

function pass = mg_getStudentFunction(inputs, outputs)
    
    filename = getMGFileName();
    fncname = filename(1:end-2);
    
    try
        %compare inputs
        if evalin('caller', ['nargin("', fncname ,'")']) ~= inputs
            pass = 0;
        %compare outputs
        elseif evalin('caller', ['nargout("', fncname ,'")']) ~= outputs
            pass = 2;
        else
            pass = fncname;
        end
    catch
        pass = 0;
    end
end


% Code to get the MATLAB-Grader generated solution file
function filename = getMGFileName(varargin)

    if isempty(varargin)
        ignoreFiles = [];
    else
        ignoreFiles = varargin{:};
    end
    
    if size(ignoreFiles,1) > 1
        ignoreFiles = ignoreFiles';
    end
    % get all *.m files
    dirInfo = dir('*.m');
    
    %convert to string-array
    fileList = strings(1,size(dirInfo,1));
    for n = 1:size(dirInfo,1)
        fileList(n) = convertCharsToStrings(dirInfo(n).name);
    end
    
    %remove unwanted
    toRemove = ["ScoringEngine","solutionTest", "mg_", ignoreFiles];
    
    %remaining = Matlab grader solution file
    location = find(~contains(fileList, toRemove));
    location = location(1);
    
    filename = convertStringsToChars(fileList(location));
end