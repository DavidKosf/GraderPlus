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
%Function Name: mg_keywordsEither
%
%Description:
%   This function uses the given keyword check in ML Grader and extends it 
%   to multiple keywords. If one or more are present the result is true.
%
%Inputs:
%     keywords (string array)
%         Collection of strings that shall be in the the solution. At least one
%         String must be used
%     varargin (strings / char arrays)
%         Function and script names (excluding .m) that shall be ignored. Use this
%         to prevent your uploaded files from beeing scanned.
% 
% Outputs:
%     pass (bool)
%         true: At least on keyword was used
%         false: Not a single keyword was used
%         
%     used (string array)
%         Returns all used keywords
%     unused (string array)
%         Returns all unused keywords. Empty, if all were used.



function [pass, used, unused] = mg_keywordsEither(keywords, varargin)

    pass = false();
    used = [];
    unused = [];
    
    %Get generated solution file
    filename = getMGFileName(varargin);
    
    %Cycle using ML Grader function
    for keyword = keywords
        
        isKWused = 0;
        
        try
            assessFunctionAbsence(keyword, 'FileName', filename);
        catch
            pass = true();
            isKWused = 1;
        end
        
        if isKWused
            used = [used, keyword];
        else
            unused = [unused, keyword];
        end
        
    end
    
    if isempty(unused)
        pass = false();
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
