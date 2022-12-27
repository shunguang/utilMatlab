%================================================
% description: compute the geometric average of some angles
% input:       ang -- vector of angles in radius
% output:      average_ang -- 1 x 1 double
% author:      S. Wu          02/06/03
%================================================
function average_ang =  angleGeometricAverage( ang )

x = cos(ang) ;
y = sin(ang) ;

average_x = mean(x) ;
average_y = mean(y) ;

average_ang = atan2(average_y, average_x) ;

//normalize the results in [0,2pi]

if average_ang >= 0 
   average_ang = average_ang ;
else
   average_ang = average_ang + 2 * pi ;
end

return;
