function [q, I] = q_init_from_rotation_matrix( A )
%=============================================================
% [q, I] = q_init_from_rotation_matrix( A )
% The objective: Initialize a quaternion from the rotation matrix
% Input:
%        A     - 3 x 3, the rotation matrix, when works on a vector,
%                it is defined by with a column vector,e.g., v2 = A*v1 
% Output:
%        q     - 4 x 1, the coresponding quaternion
%-------------------------------------------------------------
% Note:   q is defined by q=[w,x,y,z]', i.e., q=w+xi+jy+zk
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
q = zeros(4,1) ;

q(1) = sqrt( A(1,1) + A(2,2) + A(3,3) + 1 ) / 2;
q(2) = sqrt( A(1,1) - A(2,2) - A(3,3) + 1 ) / 2;
q(3) = sqrt( A(2,2) - A(1,1) - A(3,3) + 1 ) / 2;
q(4) = sqrt( A(3,3) - A(1,1) - A(2,2) + 1 ) / 2;

[maxq,I] = max(q) ;

u = 4*q(I) ;
switch I
    case 1     % if q0 is the bigest
        %q(1) = q(1) ;        
        q(2) = ( A(3,2) - A(2,3) ) / u ;
        q(3) = ( A(1,3) - A(3,1) ) / u ;
        q(4) = ( A(2,1) - A(1,2) ) / u ;
    case 2     % if q1 is the bigest
        q(1) = ( A(3,2) - A(2,3) ) / u ;
        % q(2) = q(2);
        q(3) = ( A(1,2) + A(2,1) ) / u ;
        q(4) = ( A(1,3) + A(3,1) ) / u ;
    case 3     % if q2 is the bigest
        q(1) = ( A(1,3) - A(3,1) ) / u ;
        q(2) = ( A(1,2) + A(2,1) ) / u ;
        % q(3) = q(3);
        q(4) = ( A(2,3) + A(3,2) ) / u ;
    case 4     % if q3 is the bigest  
        q(1) = ( A(2,1) - A(1,2) ) / u ;
        q(2) = ( A(1,3) + A(3,1) ) / u ;
        q(3) = ( A(2,3) + A(3,2) ) / u ;
        %q(4) = q(4);
end
    
if q(1) < 0   % keep the rotation angle positive
    q = - q ;
end

return
