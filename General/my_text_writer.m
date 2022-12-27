function my_text_writer(x, headLines, fileName)
%------------------------------------------------------------------------
% MY_TEXT_WRITER, write 2D array data into a text file with head lines
% my_text_writer(x, headLines, fileName)
% input:
%        x, m x n, array  
%        headLines, nLines x 1, cell, each element is one line of the heads  
%        fileName,   1 x m, file name string
% output: 
%        an text file on disk
%------------------------------------------------------------------------
% History:
% 1. 02/24/06, created by swu@sarnoff.com
%------------------------------------------------------------------------
[m,n] = size(x);
nL = size( headLines, 1);

fid=fopen(fileName, 'w+');
for i=1:nL
    fprintf(fid, '%s\n', headLines{i});
end

for i=1:m
    for j=1:n-1
        fprintf(fid, '%f ', x(i,j));
    end
    if i<m
        fprintf(fid, '%f\n', x(i,n));
    else
        fprintf(fid, '%f', x(i,n));
    end
end
fclose(fid);
%eof