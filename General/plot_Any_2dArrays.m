%function main

%x= ones(2, 100) ;
%myLegendStrsCell = cell(2,1) ;

%myLegendStrsCell{1} ='abc'; 
%myLegendStrsCell{2} = 'efg';

%plot_Any_2dArrays( x,myLegendStrsCell );
%return

function plot_Any_2dArrays( x, myLegendStrsCell )

m = 10 ;

lineColorCell{1} ='b-'; 
lineColorCell{2}='g--' ;
lineColorCell{3}='r-.' ;
lineColorCell{4}='k:' ;
lineColorCell{6}='g-' ;
lineColorCell{7}='r-' ;
lineColorCell{8}='k-' ;
lineColorCell{9}='y-' ;
lineColorCell{10}='c-' ;

n = size(x, 1) ;
if n > m
    disp( 'plot_Any_2dArrays(): the row # is biger than 10, only the first 10 rows are ploted');
    n=m ;
end

figure 
for i=1:n
    plot( x(i,:), lineColorCell{i}); hold on;
end
legend( myLegendStrsCell )
return
