function write_to_txt_file(x, headLines, fileName)
%-----------------------------------------
% x,         m x n, matrix
% headLines, m x 1, cell 
%-----------------------------------------
headLines
[m,n] = size(x);
nL = size( headLines, 1)

fid=fopen(fileName, 'w+');
for i=1:nL
    fprintf(fid, '%s\n', headLines{i});
end

for i=1:m
    for j=1:n-1
        fprintf(fid, '%f ', x(i,j));
    end
    if i<m
        fprintf(fid, '%f\n', x(i,j));
    else
        fprintf(fid, '%f', x(i,j));
    end
end
fclose(fid);
