function [pass, missing] = mg_varExist(vars)

    usedVars = ismember(vars, evalin('caller','who'));

    if all(usedVars)
        pass = 1;
        missing = [];
    else
        pass = 0;
        missing = [];
        for n = 1:1:length(vars)
            if ~usedVars(n)
                missing = [missing, vars(n)]; 
            end
        end
    end
end

