

function [allPresent, missing] = mg_keywordPresent(keywords, varargin)
    
    allPresent = 1;
    missing = [];
    
    filename = getMGFileName(varargin);

    for keyword = keywords
        
        try
            assessFunctionPresence(keyword, 'FileName', filename);
        catch
            allPresent = 0;
            missing = [missing, keyword];
        end
        
    end
end

function filename = getMGFileName(varargin)
    if isempty(varargin)
        ignoreFiles = [];
    else
        ignoreFiles = varargin{:};
    end
    
    if size(ignoreFiles,1) > 1
        ignoreFiles = ignoreFiles';
    end
    dirInfo = dir('*.m');
    fileList = strings(1,size(dirInfo,1));
    
    for n = 1:size(dirInfo,1)
        fileList(n) = convertCharsToStrings(dirInfo(n).name);
    end
    
    toRemove = ["ScoringEngine","solutionTest", "mg_", ignoreFiles];
    
    location = find(~contains(fileList, toRemove));
    location = location(1);
    
    filename = convertStringsToChars(fileList(location));
end

