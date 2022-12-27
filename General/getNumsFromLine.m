function x = getNumsFromLine(str, n)
x = zeros(1, n);

R=str;
for i=1:n
    %[T, R] = strtok(R, '\t')
    [T, R] = strtok(R);
    x(i) = str2num(T);
end
 
