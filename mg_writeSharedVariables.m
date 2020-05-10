function [success] = mg_writeSharedVariables(varargin)

    success = true();
    try
       vars = "";
       for varName = varargin
           vars = vars + ",'" + varName{:} + "'";
       end
       
       append = "";
       if isfile('mg_sharedvarstorage.mat')
           append = ",'-append'";
       end
       
       fncCall = "save('mg_sharedvarstorage.mat' " + vars + append +");";
       evalin('caller', fncCall);
    catch
        success = false();
    end
end

