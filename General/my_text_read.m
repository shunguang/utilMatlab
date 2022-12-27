function x = my_text_read(fileName, nHeadLines)
%------------------------------------------------------------------------
% read textfile into array $x$, the first few head lines will be skipped.
% input:
%        fileName, 1 x m, file name string
%        nHeadLines, 1 x 1, number of head lines need to be skiped
% output:
%        m x n  
%
% by SWU  02/24/06
%------------------------------------------------------------------------
if nHeadLines==0
    x = textread(fileName);
    return;
end

fid1 = fopen( 'tmp.txt', 'w');
fid = fopen( fileName, 'r');
for i=1:nHeadLines
    tline = fgets(fid);
end
while 1
    tline = fgets(fid);
    if ~ischar(tline)
        break
    end
    fprintf(fid1,'%s', tline);
end
fclose(fid);
fclose(fid1);

x = textread('tmp.txt');


