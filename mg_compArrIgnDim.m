% solution (String or Variable): Students solution. If a single string is
% provided, the function will search for the variable by the given name.
% reference (Variable): reference Solution

% equals (logical): result of comparison



function equals = mg_compArrIgnDim(solution, reference)

    % Var name given.
    if all(size(solution) == [1,1])
        % Try to fetch variable. equals = false if it oes not exist.
        try
            solution = evalin('caller', solution)
        catch
            equals = false();
            return
        end
    end
    
    equals = isequal(solution, reference) | isequal(solution', reference);
end

