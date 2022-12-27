function [p, flag] = q_inverse( q )
%=============================================================
% [p, flag] = q_inverse( q )
% The objective: Find the inverse of q such that q*p = p*q = 1
% Input:
%        q - 4 x 1, the input quaternion
% Output:
%        p - 4 x 1, the inverse of q
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

% compute the conjugate of q 
q_c      = zeros(4,1);
q_c(1)   = q(1) ;
q_c(2:4) = -q(2:4) ;

a = sum ( q .^ 2 ) ;
if a > 0
    p = q_c / a ;       % may not correct, need to check
    flag = 1 ;
else
    disp('Warnning -- q_inverse(): q is z zeros quaternion, whose inverse is not exist!');
    p = zeros(4,1);    
    flag = 0 ;
end
return