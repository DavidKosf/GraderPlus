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
%Function Name: mg_getStudentFunction
%
%Description:
%     This function checks if a solution is a function and has a desired number of in- and outputs
%
% Inputs:
%     inputs (int)
%         Amount of desired inputs
%     outputs (int)
%         Amount of desired outputs
%         
%Outputs:
%   result (bool)
%       pass
%             true, if fitting solution is found
%       status (string / function handle)
%           "fail-in"
%               If input amount is not right
%           "fail-out"
%               If output amount is not right
%           "fail-notFcn"
%               If output amount is not right
%           FUNCTION HANDLE
%               Only returned if pass is true

function [pass, status] = mg_getSolutionFunction(inputs, outputs, varargin)
    
    filename = getMGFileName(varargin);
    fncname = filename(1:end-2);
    
    if strcmp(filename, 'solution.m')
        pass = false();
        status = "fail-notFcn";
        return
    end
    
    try
        %compare inputs
        if evalin('caller', ['nargin("', fncname ,'")']) ~= inputs
            pass = false();
            status = "fail-in";
        %compare outputs
        elseif evalin('caller', ['nargout("', fncname ,'")']) ~= outputs
            pass = false();
            status = "fail-out";
        else
            pass = true();
            status = str2func(fncname);
        end
    catch
        pass = false();
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