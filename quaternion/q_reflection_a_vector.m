function [v_ref] = q_reflection_a_vector( n, v )
%=============================================================
% [v_ref] = q_reflection_a_vector( n, v )
% reflect a vector by the given plane normal vector
% input:
%        n, 3 x 1, the normal vector of a plane
%        v, 3 x 1, the original vector
% output:
%        v_ref, 3 x 1, the reflection vector 
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

q_v = [0; v] ;
q_n = [0; n] ;
q_n_mag = sqrt ( sum ( q_n .^2 ) ) ;
if  q_n_mag > 0 
    q_n = q_n / q_n_mag ; % normalize q_n to makesure it is a unit vector

    q_nv = q_q1_times_q2(q_n, q_v) ; 

    q_v_ref = q_q1_times_q2(q_nv, q_n) ; 
    v_ref = q_v_ref(2:4) ; 
else
    disp ('Error -- q_reflection_a_vector(): the magnitude of the plane normal vecter is zero!') ;
    v_ref = zeros(3,1);
end
return
