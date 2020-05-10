% keywords (string array): keywords to check for using ML-Grader functions
% varargin (strings): ignore matlab files used by grader containing any of the given
% strings. Use this, if you upload own scripts/functions

% pass  (int)-> 0: fail, 1: at least one used, 2:all used
% missing (string array): missing keywords
% used (string arrray): used keywords


function [pass, used, unused] = mg_keywordEither(keywords, varargin)

    pass = 0;
    used = [];
    unused = [];
    
    filename = getMGFileName(varargin);
    
    for keyword = keywords
        
        isKWused = 0;
        
        try
            assessFunctionAbsence(keyword, 'FileName', filename);
        catch
            pass = 1;
            isKWused = 1;
        end
        
        if isKWused
            used = [used, keyword];
        else
            unused = [unused, keyword];
        end
        
    end
    
    if isempty(unused)
        pass = 2;
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
