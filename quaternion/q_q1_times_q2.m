function [q3] = q_q1_times_q2(q1,q2)
%=============================================================
% [q3] = q_q1_times_q2(q1,q2)
% The objective: The times of two quaternions
% Input:
%         q1     - 4 x 1, a quaternion
%         q2     - 4 x 1, a quaternion
% Output:
%         q3, 4 x 1,  q3 = q1 * q2, (!!! note q1*q2 != q2*q1)
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

w1 = q1(1);
v1 = q1(2:4);

w2 = q2(1);
v2 = q2(2:4);

q3 = zeros(4,1);

q3(1) = w1*w2 - v1' * v2 ;
q3(2:4) = w1*v2 + w2*v1 + ...
          [ v1(2)*v2(3)-v1(3)*v2(2);  v1(3)*v2(1)-v1(1)*v2(3); v1(1)*v2(2)-v1(2)*v2(1)] ;
      
      
return