% Generate one String containg message for each input while replacing %s
% message -> string
% input -> string array

% multiline-error: error(multiText(msg, imput), '')

function message_final = mg_multiText(message, input)
    message_final = "";
    for keyword = input
        if strcmp(keyword,"")
            continue
        end
        string = strcat(strrep(message, '%s', keyword)," \n");
        message_final = strcat(message_final, string);
    end     
end

