function [q] = q_init_from_axis_angle( u, theta )
%=============================================================
% [q] = q_init_from_axis_angle( u, theta )
% The objective: Initialize a quaternion by an axis and roation angle (RIGHT HAND SYSTEM)
% Input:
%        u     - 3 x 1, the unit vector of the roation axis
%        theta - 1 x 1, the roation angle in radius (RIGHT HAND SYSTEM)
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

u_mag  = sqrt( sum( u .^ 2 ) ) ;  % magnitude of u
if u_mag > 0
    u = u / u_mag ;       % normalize u to makesure it is a unit vector
    q(1)   = cos(theta/2) ;
    q(2:4) = sin(theta/2) * u ;
else
    disp('q_init_from_axis_angle(): u is not a vector');    
end
return
