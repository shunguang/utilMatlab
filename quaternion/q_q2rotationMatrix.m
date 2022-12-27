function [R3, R4] = q_q2rotationMatrix( q )
%=============================================================
% [R3, R4] = q_q2rotationMatrix( q )
% Get the corresponding rotation matrix of quaternion
% Input:
%         q  - 4 x 1, a unit quaternion
% Output:
%         R3,  3 x 3,  the rotation matrix
%         R4,  4 x 4,  the rotation matrix from quaternion computation
%-------------------------------------------------------------
% Note:   q is defined by q=[w,x,y,z]', i.e., q=w+xi+jy+zk 
%         also when using the returned matrix,  it should be works with the
%         column vector, e.g., R3*v, if work with the row vector, R3 and R4 need
%         to be transposed.
%-------------------------------------------------------------
% Reference:
% [0] http://www.cs.berkeley.edu/~laura/cs184/quat/quaternion.html
% [1] E.A. Coutsias and L. Romero, the quaternions with an application to rigid
%     Body dynamics, http://www.math.unm.edu/~vageli/papers/rrr.pdf
% [2] Graphics Gems II, pp. 351-354, pp. 377-380 
% [3] Hearn & Baker, Computer Graphics,  pp. 419-420 & pp. 617-618 
% [4] Ken Shoemake,  "Animating Rotation with Quaternion Curves", Computer Graphics V.19 N.3, 1985 
%-------------------------------------------------------------
% History: 1. the 1st version by   Shunguang Wu,  03/24/04
%          2. correct the errors of 1st version by S. Wu, 04/18/04 
%=============================================================
w = q(1);
x = q(2);  y = q(3);  z = q(4);  
w2 = w*w ;

R3 = zeros(3) ;

R3 = 2 * [ w2 + x*x - 0.5,   x*y - w*z,         x*z + w*y ;    
           x*y + w*z,        w2 + y*y  - 0.5,   y*z - w*x ;    
           x*z - w*y,        y*z + w*x,         w2 + z*z  - 0.5 ] ;    
if nargout > 1  
    R4  =  zeros(4) ;
    R4(1:3,1:3) = R3 ;
    R4(4,4) = 1;
end

return
