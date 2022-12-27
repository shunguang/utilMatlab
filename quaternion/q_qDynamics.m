function [A] = q_qDynamics( w, T )
%=============================================================
% [A] = q_qDynamics( w, T )
% Given the rotation velocity vector, finding the corresponding quaternion
% input:
%      w, 3 x 1, [w_x, w_y, w_z]' the rotation velocities around the three axis
%         in the inertial coordimate  system     
%      T, 1 x 1, the smapling intervals
% output:
%      A, 4 x 4, the transfer matrix of the quaternion
%-------------------------------------------------------------
% Note:   q is defined by q=[w,x,y,z]', i.e., q=w+xi+jy+zk
%-------------------------------------------------------------
% Reference:
% [1] E.A. Coutsias and L. Romero, the quaternions with an application to rigid
%     Body dynamics, http://www.math.unm.edu/~vageli/papers/rrr.pdf
%-------------------------------------------------------------
% History: 1. the 1st version by   Shunguang Wu,  03/24/04
%          2. correct the errors of 1st version by S. Wu, 04/18/04 
%=============================================================

w0 = sqrt(w(1)^2 + w(2)^2 + w(3)^2) ;
if w0 < 1e-12
    A = eye(4) ;
    return ;
end

cosT = cos(w0*T/2) ;
sinT = sin(w0*T/2) ;
w = ( sinT / w0 ) * w ;

A = [ cosT   -w(1)   -w(2)   -w(3) 
      w(1)    cosT   -w(3)    w(2);
      w(2)    w(3)    cosT   -w(1);
      w(3)   -w(2)    w(1)    cosT ];
return
