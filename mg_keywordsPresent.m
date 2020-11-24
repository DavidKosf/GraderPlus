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
%Function Name: mg_keywordsPresent
%
%Description:
%   This function uses the given keyword check in ML Grader and extends it 
%   to multiple keywords. If all are present the result is true.
%
%Inputs:
%     keywords (string array)
%         Collection of strings that shall be in the the solution. Every string
%         has to be used at least once.
%     varargin (strings / char arrays)
%         Function and script names (excluding .m) that shall be ignored. Use this
%         to prevent your uploaded files from beeing scanned.
% 
% Outputs:
%     allPresent (bool)
%         Indicates if all keywords were present.
%     missing (string array)
%         Returns missing keywords. Empty if all were used.



function [allPresent, missing] = mg_keywordsPresent(keywords, varargin)
    
    allPresent = 1;
    missing = [];
    
    % Get the generated solution file
    filename = getMGFileName(varargin);

    %Loop using the ML Grader given function
    for keyword = keywords
        
        try
            assessFunctionPresence(keyword, 'FileName', filename);
        catch
            allPresent = 0;
            missing = [missing, keyword];
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

