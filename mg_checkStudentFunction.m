% inputs (int): Amount of inputs the student's function should have
% outputs (int): Amount of inputs the student's function should have

% pass (int): 0 -> wrong number of inputs
% pass (int): 1 -> pass
% pass (int): 2 -> wrong number of outputs

function pass = mg_checkStudentFunction(inputs, outputs)
    
    filename = getMGFileName();
    fncname = filename(1:end-2);
    
    %compare inputs
    if nargin(fncname) ~= inputs
        pass = 0;
    %compare outputs
    elseif nargout(fncname) ~= outputs
        pass = 2;
    else
        pass = 1;
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