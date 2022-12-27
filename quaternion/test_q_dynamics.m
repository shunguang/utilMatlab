function test_q_dynamics
%=============================================================
% the objective: test the relative quaternion functions
%-------------------------------------------------------------
% Note:   q is defined by q=[w,x,y,z]', i.e., q=w+xi+jy+zk 
%-------------------------------------------------------------
% Reference:
% [0] http://www.cs.berkeley.edu/~laura/cs184/quat/quaternion.html
% [1] Graphics Gems II, pp. 351-354, pp. 377-380 
% [2] Hearn & Baker, Computer Graphics,  pp. 419-420 & pp. 617-618 
% [3] Ken Shoemake,  "Animating Rotation with Quaternion Curves", Computer Graphics V.19 N.3, 1985 
%-------------------------------------------------------------
% History: 1. the 1st version by   Shunguang Wu,  03/24/04
%=============================================================
clear all

myEps = 1e-9;

%%%%%%%% dynamics of a quaternion %%%%%%%%%%%
while 1
q0 = q_init_from_random(1) 
T = 1 ;  % sampling interval

format long
% compute the transfer matrix from omega 
for i=1:3
    fprintf('i=%d \n', i );
    if i==1
        omega =[pi/2, 0, 0] ; 
    elseif i==2
        omega =[0, pi/2, 0] ; 
    else
        omega =[0, 0, pi/2] ; 
    end
    
    [A] = q_qDynamics( omega, T ) ; % get transfer matrix
    qA = A*q0    % computer the quaternion by transfer matrix

    %%%%%% direct from axis-angle initialization
    ang1 = omega(i) * T ;
    if i==1
        q2 = q_init_from_axis_angle( [1, 0, 0]', ang1 ) ;
    elseif i==2
        q2 = q_init_from_axis_angle( [0, 1, 0]', ang1 ) ;
    else
        q2 = q_init_from_axis_angle( [0, 0, 1]', ang1 ) ;
    end
    
    qC = q_q1_times_q2(q2, q0) ; % from two consectutive operations
    dqAC = qA-qC
    
    pause
end
end
return

