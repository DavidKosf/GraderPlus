


function [pass, missing] = mg_equalsStrictOrder(varNames)
    pass = true();
    missing = [];
    
    for var = varNames
        
        try
            fncCall = "assessVariableEqual('" + var + "', referenceVariables."+var+");"
            disp(var)
            disp(evalin('caller', fncCall));
        catch
            pass = false();
            missing = [missing, var];
        end
    end
    
end

