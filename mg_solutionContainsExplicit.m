%=== GraderPlus ===
%
%Library for advanced testing in MATLAB® Grader 
%Created by David Kosfelder 
%for the Process Dynamics and Operations Group at TU Dortmund
% 
%Contact: david.kosfelder@tu-dortmund.de
%
%
%
%=== Function Summary ===
%
%Function Name: mg_solutionContainsExplicit
%
%Description:
%   This function searches for keywords used in the solution. It is an
%   extension to the existing keyword search and allows for checking regular expressions.
%   Comments in the solution are filtered and ignored.
%
%Inputs:
%   statements (Sting array)
%       keywords (normal strings and regular expressions) that the function
%       shall look for. You can check for multiple keywords in order to catch
%       "look-a-likes"
%
%   varargin (strings)
%       Filenames or parts of filenames that shall be ignored while determing
%       the name of the solution file. Use this to preent your own uploaded
%       files from beeing scanned.
% 
%Outputs:
%   present (bool)
%       true: at least one statement was used in the solution
%       false: no statement was used in the solution

function present = mg_solutionContainsExplicit(statements, varargin)
    
    % Finding the solution file and reading its content.
    filename = getMGFileName(varargin);
    content = fileread(filename);
    
    %content as lines, remove empty lines
    as_lines = regexp(content, '\r?\n', 'split');
    as_lines = as_lines(~cellfun('isempty', as_lines));
    
    present = false();
    
    for statement = statements
        
        %compare expressions found with the ones found in comments
        expressionsFound = regexp(as_lines, statement);
        expressionsCFound = regexp(as_lines, "%.*"+statement);

        if length([expressionsFound{:}]) > length([expressionsCFound{:}])
            %at least one expression was found
            present = true();
            return
        end
    end
end

% Code to get the MATLAB-Grader generated solution file
function filename = getMGFileName(varargin)
    
    % Ignoring specified file names
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

