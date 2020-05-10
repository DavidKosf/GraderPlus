% varargin (any var type): input values for student function 

% pass (logical): logical 0/1 if test is passed
% varargout (any var type): return values of student function in the order the student defined them

function [pass, varargout] = mg_evalStudentFunction(varargin)
    
    filename = getMGFileName();
    fncname = filename(1:end-2);
    
    fncin = nargin(fncname);
    fncout = nargout(fncname);
    
    thisin = nargin;
    thisout = nargout-1;
    
    % check required and given output and input dimension
    if fncin ~= thisin || fncout ~= thisout
        pass = false();
        varargout = cell(1, thisout);
        return
    end
    
    %evalute function by name
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
