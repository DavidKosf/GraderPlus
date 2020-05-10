% varargin (Strings): Variable names to check existance

%pass (logical): 1 if all vars were used, 0 if not
%missing (string array): names of missing vars

function [pass, missing] = mg_varExist(varargin)

    % varargin to string vector
    vars = [varargin{:}];

    % logic vector: existing/required vars
    usedVars = ismember(vars, evalin('caller','who'));

    % All vars used
    if all(usedVars)
        pass = true();
        missing = [];
    else
        pass = false();
        
        % Find missing vars
        missing = [];
        for n = 1:1:length(vars)
            if ~usedVars(n)
                missing = [missing, vars(n)]; 
            end
        end
    end
end

