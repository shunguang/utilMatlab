function [str] = replace_under_lines ( str )

L = length( str );
for i=1:L
    if str(i) == '_';
        str(i) = '-';
    end
end



