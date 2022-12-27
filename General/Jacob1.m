syms x y z w real; %unknows q=ix+yj+zk+w

%knows
sym k real;
syms p2y p2x real; %p2=[p2x, p2y,1]'
syms p3x p3y p3z real; %%p3=[p3x, p3y,p3z]'
syms tx ty tz real; %T=[tx, ty,tz]'


R = 2 * [ w*w + x*x - 0.5,   x*y - w*z,         x*z + w*y ;    
          x*y + w*z,        w*w + y*y  - 0.5,   y*z - w*x ;    
          x*z - w*y,        y*z + w*x,         w*w + z*z  - 0.5 ] ;  
      
P2Left = [p2x, p2y, 1]'
P3=[p3x, p3y, p3z]'
T=[tx, ty, tz]'

P2Right = k*R*P3+T

%the 4 non-linear eqs
f1 = P2Left(1) - P2Right(1);
f2 = P2Left(2) - P2Right(2);
f3 = P2Left(3) - P2Right(3);
f4 = x*x+y*y+z*z+w*w - 1;

Jaco = jacobian([f1;f2;f3;f4], [x y z w] ));
      