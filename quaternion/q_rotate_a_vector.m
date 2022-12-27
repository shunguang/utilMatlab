function [v_rotated] = q_rotate_a_vector( q, v )
%=============================================================
% [v_rotated] = q_rotate_a_vector( q, v )
% Compute the rotated vector who is the result
% of the a vector rotated about the axis with 
% particular angles in the right-hand system(expressed by a quaternion)
% Input:
%        q - 4 x 1, the unit quaternion, which is stand for the rotation axis and
%        anlge (rigth hand system)
%        v - 3 x 1, the vector will be rotated.
% Output:
%        v_rotated - 3 x 1, the rotated vector if q is invertible
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

%%%%% because of ambiguity, here we follow the row vector calulations
[inv_q, flag]  = q_inverse( q ) ;
if flag 
   q_v = [0; v] ;
   [q_qv] = q_q1_times_q2(q, q_v) ; % p*q
   q_v_rotated = q_q1_times_q2(q_qv, inv_q) ;
        
   v_rotated = q_v_rotated(2:4) ;  % delete the 1st element to return the vector
else
   disp('Error -- q_rotate_a_vector( q, v ): q does not stand for a roation operation!');
   v_rotated = zeros(3,1);
end
return
