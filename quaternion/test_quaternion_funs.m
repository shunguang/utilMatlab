function test_quaternion_funs
%=============================================================
% the objective: test the relative quaternion functions
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

clear all

myEps = 1e-9;

%%%%%%%%% test the times and inverse %%%%%%%%%%%%%%%
for i=1:2
    %q = q_init_from_axis_angle( [0, 0, 1]', pi/2 ) 
    q = q_init_from_random(1);
    nFlag = q_isUnit( q, myEps ) 

    [p]  = q_inverse(q)
    [pq] = q_q1_times_q2(p,q)
    [qp] = q_q1_times_q2(q,p)
end

%%%%%%%%%%% test reflections %%%%%%%%%%%%%
for i=1:2
    n = [0; 0; 1] ;
    v = rand(3,1)                     % the test vector, along y-axis
    [v_ref] = q_reflection_a_vector( n, v )
%    pause
end

%%%%%%%%% test the rotation a vector  %%%%%%%%%%%%%%%
q = q_init_from_axis_angle( [1, 0, 0]', pi/2 ) ; % the rotation axis (x) and the roation angle (clockwised)
nFlag = q_isUnit( q, myEps ) 
v = [0;1;0];                     % the test vector, along y-axis
v_rotated_1 = q_rotate_a_vector( q, v ) 

[R] = q_q2rotationMatrix( q ) ;
v_rotated_2 = R*v

%%%%%%%%% test q2R and R2q  %%%%%%%%%%%%%%%
for i=1:10
    q = q_init_from_random(1)
    
    [R] = q_q2rotationMatrix( q ) ;
    
    [q_Matrix,I] = q_init_from_rotation_matrix( R )
    q - q_Matrix
%    pause
end

%%%%%%%%% P_rotation = q2*[q1*P*q1^(-1)]*q2^(-1) =  (q1*q2)*P*(q1*q2)^(-1)   %%%%%%%%%%%%%%%

q1 = q_init_from_axis_angle( [1, 0, 0]', pi/2 )  % the rotation axis (x) and the roation angle
q2 = q_init_from_axis_angle( [0, -1, 0]', pi/4 )  % the rotation axis (y) and the roation angle


v = [0;1;0];                      % the test vector, along y-axis  

% method1: rotate the vector two times
[v_tmp] = q_rotate_a_vector( q1, v ) ;
[v_tmp1] = q_rotate_a_vector( q2, v_tmp ) 

% method2: by quaternions multiplication
q21 = q_q1_times_q2( q2, q1 ) ;
[v_tmp2] = q_rotate_a_vector( q21, v ) 

% method3: by rottaion matrix
[R1] = q_q2rotationMatrix( q1 ) ;
[R2] = q_q2rotationMatrix( q2 ) ;
v_tmp3 = (R2*R1)*v

return

