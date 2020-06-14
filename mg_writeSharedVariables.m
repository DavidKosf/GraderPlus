% varargin (strings): Variable names || empty -> all vars

% success (logical): 1/0 if storing/ writing was possible

function [success] = mg_writeSharedVariables(varargin)

    success = true();
    try
       %varargin to formatted string
       vars = "";
       for varName = varargin
           vars = vars + ",'" + varName{:} + "'";
       end
       
       %add append when file exists -> dont delete other vars on overwrite
       append = "";
       if isfile('mg_sharedvarstorage.mat')
           append = ",'-append'";
       end
       
       %evaluate function in caller
       fncCall = "save('mg_sharedvarstorage.mat' " + vars + append +");";
       evalin('caller', fncCall);
    catch ME
       disp(ME);
        success = false();
    end
end

