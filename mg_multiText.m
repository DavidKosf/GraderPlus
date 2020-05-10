% Generate one String containg message for each input while replacing %s
% message (String): Base message. %s will be replaced by varargin args \n
% is added automatically
% varargin(Strings/String arrays): replacements for %s

% multiline-error: error(multiText(msg, imput), '')

function message_final = mg_multiText(message, varargin)

    %varargin to string array
    input = [varargin{:}];
    
    %message construction
    message_final = "";
    for keyword = input
        if strcmp(keyword,"")
            continue
        end
        string = strcat(strrep(message, '%s', keyword)," \n");
        message_final = strcat(message_final, string);
    end     
end

