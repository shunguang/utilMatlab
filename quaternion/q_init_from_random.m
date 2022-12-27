function [Q] = q_random( M )
%=============================================================
% [Q] = q_init_from_random( M ). 
% Create M random normalized quaternions
% Input:
%         M - 1 x 1, the number of quaternion will created
% Output:
%         Q - 4 x M, the created M random normalized quaternions
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
Q = zeros(4,M);
for i=1:M
    q = unifrnd(-1,1,4,1) ;
    q = q_normalization(q) ;
    if q(1) < 0   % makesure the angle is positive
        q = - q ;
    end
    
    Q(:,i) = q ;
end

return