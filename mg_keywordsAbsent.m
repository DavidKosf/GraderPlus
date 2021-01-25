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
%Function Name: mg_keywordsAbsent
%
%Description:
%   This function uses the given keyword check in ML Grader and extends it 
%   to multiple keywords. If one or more are present the result is false.
%
%Inputs:
%     keywords (string array)
%         Collection of strings that shall not be in the the solution.
%     varargin (strings / char arrays)
%         Function and script names (excluding .m) that shall be ignored. Use this
%         to prevent your uploaded files from beeing scanned.
% 
% Outputs:
%     allAbsent (bool)
%         True if all keywords are absent
%     used (string array)
%         Returns all used keywords that are forbidden


function [allAbsent, used] = mg_keywordsAbsent(keywords, varargin)
    allAbsent = true();
    used = [];
    
    %Get generated solution file
    filename = getMGFileName(varargin);

    for keyword = keywords
        
        try
            assessFunctionAbsence(keyword, 'FileName', filename);
        catch
            allAbsent = false();
            used = [used, keyword];
        end
        
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
