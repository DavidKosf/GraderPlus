% pass -> 0: fail, 1: at least one used, 2:all used



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

