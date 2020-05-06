function result = mg_isFunction(varargin)

    filename = getMGFileName(varargin);
    if size(filename) == size('solution.m')
        if all(filename == 'solution.m')
            result = false();
            return
        end
    
    end
    result = true();
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
