function success = mg_loadSharedVariables(varargin)
    
    success = true();
    
    try
        vars = "";
        for varName = varargin
            vars = vars + ",'" + varName{:} + "'";
        end
        
        evalin('caller', "load('mg_sharedvarstorage.mat' " + vars +");");
        
    catch
        success = false();
    end
        
end

