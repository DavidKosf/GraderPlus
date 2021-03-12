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
%Function Name: mg_plotExists
%
%Description:
%   This is just a wrapper that checks if a graph was created by the solution
%
%Outputs:
%   result (bool)
%       true: graph was created
%       false: graph was not created


function result = mg_isFunction(varargin)

    %Get generated solution file
    filename = getMGFileName(varargin);
    
    %Check if solution file is named solution.m
    if strcmp(filename, 'solution.m')
        result = false();
    else
        result = true();
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