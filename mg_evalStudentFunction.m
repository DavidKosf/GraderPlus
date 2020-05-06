function [pass, varargout] = mg_evalStudentFunction(varargin)
    
    filename = getMGFileName();
    fncname = filename(1:end-2);
    
    fncin = nargin(fncname);
    fncout = nargout(fncname);
    
    thisin = nargin;
    thisout = nargout-1;
    
    if fncin ~= thisin || fncout ~= thisout
        pass = false();
        varargout = cell(1, thisout);
        return
    end
    
    try
        pass = true();
        result = cell(1, fncout);
        [result{:}] = feval(fncname, varargin{:});
        varargout = result;
    catch
        pass = false();
        varargout = cell(1, thisout);
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

