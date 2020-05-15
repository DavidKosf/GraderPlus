% statements (String-Array): Explicit statement and 'look-a-likes' that shoud be in the solution
% varargin (strings): ignore matlab files used by grader containing any of the given
% strings. Use this, if you upload own scripts/functions

% Present (logical): If an statement is in the solution -> true

function present = mg_solutionContainsExplicit(statements, varargin)
    
    %filename = getMGFileName(varargin);
    filename = "mg_varExist.m";
    content = fileread(filename);
    
    %content as lines, remove empty lines
    as_lines = regexp(content, '\r?\n', 'split');
    as_lines = as_lines(~cellfun('isempty', as_lines));
    
    present = false();
    
    for statement = statements
    
        expressionsFound = regexp(as_lines, statement);
        expressionsCFound = regexp(as_lines, "%.*"+statement);
        
        disp(length([expressionsFound{:}]));
        disp(length([expressionsCFound{:}]));
        if length([expressionsFound{:}]) > length([expressionsCFound{:}])
            present = true();
            return
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

