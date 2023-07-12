function [x]=rgb2KmlColorCode(a,rgb )
%a,   1x1, \in [0,1]
%rgb, 1x3, [r,g,b], \in [0,1] 
%return:  [aabbggrr];

y = dec2hex(round(255*[a, rgb(3), rgb(2), rgb(1)]));
x = reshape(y',1,8);
end
   