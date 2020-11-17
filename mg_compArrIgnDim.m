%=== Matlab Grader Framework ===
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
%Function Name: mg_compArrIgnDim
%
%Description:
%     Comparing arrays/matrices regardless of orientation (transposition).
%
% Inputs:
%     solution (string / array / matrix)
%         Array/Matrix from solution. If a string is put in, the function gets the
%         declared variable
%     reference (array)
%         Reference arrray/matrix.
%         
%Outputs:
%   equals (bool)
%       true if inputs or the transposed values are equal.




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
    
    %Comparison
    equals = isequal(solution, reference) | isequal(solution', reference);
end

