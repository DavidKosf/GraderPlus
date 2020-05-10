% varargin (strings): Variable names || empty -> all vars

% success (logical): 1/0 if loading was possible

function success = mg_loadSharedVariables(varargin)
    
    success = true();
    
    try
        %varargin to formatted string
        vars = "";
        for varName = varargin
            vars = vars + ",'" + varName{:} + "'";
        end
        
        %evaluate function in caller
        fncCall = "load('mg_sharedvarstorage.mat' " + vars +");";
        evalin('caller', fncCall);
        
    catch
        success = false();
    end
        
end

