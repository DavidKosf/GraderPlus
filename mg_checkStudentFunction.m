% pass: 0 -> wrong number of inputs
% pass: 1 -> pass
% pass: 2 -> wrong number of outputs

function pass = mg_checkStudentFunction(inputs, outputs)
    
    filename = getMGFileName();
    fncname = filename(1:end-2);
    
    if nargin(fncname) ~= inputs
        pass = 0;
    elseif nargout(fncname) ~= outputs
        pass = 2;
    else
        pass = 1;
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