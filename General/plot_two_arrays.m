%------------------------------------------------------
% plot_two_arrays.m
% plot any two arrays
% Author:      Shunguang Wu
% Email:       swu@sarnoff.com
% Shop Number: 33948.100
% Date:        02/24/06
%
% Copyright  (C)  Sarnoff Corporation, 2006.
% Sarnoff is a registered trademark of Sarnoff Corporation.
%
% This document discloses proprietary and confidential information
% of Sarnoff Corporation and may not be used, released, or disclosed
% in whole or in part for any purpose other then its intended use,
% or to any party other than the authorized recipient.
%----------------------------------------------------------------------
function plot_two_arrays(xArray1, xArray2, fTitleStr, yLabCell, xLabStr, myLegendCell)
%------------------------------------------------------
% input: 
% 	xArray1, m1 x n1, the first column is time.
% 	xArray2, m2 x n2, the first column is time. 
% 	fTitleStr, 1 x L,
% 	yLabCell,  n x 1, 
% 	xLabStr,   1 x L,
% 	myLegendCell, 2 x 1,
%------------------------------------------------------

[m1,n1]=size(xArray1);
[m2,n2]=size(xArray2);

if n1==n2
    xMin = min( [xArray1; xArray2], [], 1 );
    xMax = max( [xArray1; xArray2], [], 1 );
    n=n1;
elseif n1 > n2
    xMin = min( xArray1, [], 1 );
    xMax = max( xArray1, [], 1 );
    n=n1;
else
    xMin = min( xArray2, [], 1 );
    xMax = max( xArray2, [], 1 );
    n=n2;
end

xMin(2:n) = xMin(2:n) - 0.1*(xMax(2:n) - xMin(2:n) );
xMax(2:n) = xMax(2:n) + 0.1*(xMax(2:n) - xMin(2:n) );

M = n-1;
[solidLines, dashedLines, dotLines]  = get_line_stys;
nL = size(solidLines,1);
if  nL < M
    for i=nL+1:M
        solidLines{i} = solidLines{1};
        dashedLines{i} = dashedLines{1}; 
        dotLines{i} = dotLines{1}
    end
end

figure
for i=1:M
    subplot(M,1, i);
    if i+1 <= n1
        plot( xArray1(:, 1), xArray1(:, i+1), dashedLines{1}, 'linewidth', 2);  hold on;
    end
    if i+1 <= n2
        plot( xArray2(:, 1), xArray2(:, i+1), solidLines{2}, 'linewidth', 2);  hold on;
    end
    axis( [xMin(1), xMax(1), xMin(i+1), xMax(i+1)] );
    
    if ~isempty( yLabCell )
        ylabel( yLabCell{i});
    end
    
    if i==1
        legend( myLegendCell );
        title( fTitleStr );
    end
    
    if i==M
        xlabel( xLabStr );
    end
end

