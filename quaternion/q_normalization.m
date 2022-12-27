function [p] = q_normalization( q )
%=============================================================
% [p] = q_normalization( q )
% The objective: normalize q as a unit quaternion
% Input:
%        q  - 4 x 1, the coresponding quaternion
% Output:
%        p  - 4 x 1, a unit quaternion if q is not a zero quaternion;
%                    a zero quaternion if q is zeros 
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

[q_mag] = sqrt ( sum( q .^2 ) ) ;
if q_mag > 0
    p = q / q_mag ;
else
    disp('Warnning -- q_normalization(): q is a zero quaternion') ;
    p = q ;
end
return