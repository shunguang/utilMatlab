function [x, headLines] = my_text_reader(fileName, nHeadLines)
%----------------------------------------------------------------------
% my_text_reader.m, read text file into array $x$, the first few head lines
%                   will be skipped.
%
% [x, headLines] = my_text_reader(fileName, nHeadLines)
% input:
%        fileName,   1 x m, file name string
%        nHeadLines, 1 x 1, number of head lines need to be skiped
% output:
%        x, m x n, array  
%        headLines, nHeadLines x 1, cell, each element is one line of file heads  
%----------------------------------------------------------------------
% Date:        02/24/06, created by swu
% Author:      Shunguang Wu (swu@sarnoff.com)
% Shop Number: 33948.100
%
% Copyright  (C)  Sarnoff Corporation, 2006.
% Sarnoff is a registered trademark of Sarnoff Corporation.
%
% This document discloses proprietary and confidential information
% of Sarnoff Corporation and may not be used, released, or disclosed
% in whole or in part for any purpose other then its intended use,
% or to any party other than the authorized recipient.
%----------------------------------------------------------------------
if nHeadLines==0
    headLines = 'none';
    x = textread(fileName);
    return;
end

fid1 = fopen( 'tmp.txt', 'w');
fid = fopen( fileName, 'r');
headLines = cell(nHeadLines,1);
for i=1:nHeadLines
    headLines{i} = fgetl(fid);
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

delete tmp.txt;
%eof
