% keywords (string array): keywords to check for using ML-Grader functions
% varargin (strings): ignore matlab files used by grader containing any of the given
% strings. Use this, if you upload own scripts/functions

% all absent (logical): logical 1/0 if no given keyword is used
% used (string array): forbidden but still used keywords

function [allAbsent, used] = mg_keywordAbsent(keywords, varargin)
    allAbsent = true();
    used = [];
    
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
