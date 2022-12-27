function [my_axis, y_min, y_max] = plot_get_boundary( y, x )
% y, M x N, 2d array

[M,N] = size(y) ;
y_min =  min(y,[],2)   ;
y_max =  max(y,[],2) ;

if nargin == 2
    x_min =  min(x,[],2)   ;
    x_max =  max(x,[],2) ;
else
    x_min = ones(M,1) ;
    x_max = N*ones(M,1) ;
end

dy = abs(y_max-y_min) ;
for i=1:M
   if dy(i) < 1e-4;
       dy(i)=1e-4; 
   end
end
y_min =  y_min - dy*0.1 ;
y_max =  y_max + dy*0.1 ;

my_axis = zeros(M,4);
for i=1:M
    my_axis(i,1) = x_min(i) ;
    my_axis(i,2) = x_max(i) ;
    my_axis(i,3) = y_min(i) ;
    my_axis(i,4) = y_max(i) ;
end
return
