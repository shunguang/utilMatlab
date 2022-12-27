function  A = euler_angle_2_matrix( phi, theta, psi ) 
%-----------------------------------------------------------------
% A = euler_angle_2_matrix( phi, theta, psi ) 
% A = Rz(psi) Ry(theta) Rx(phi), the direction cosine matrix
% [u v w] = R [x' y' z'],  [u v w] - BFCS, [x', y',z'] - TLCS  
%
% Ref. J.R. Wertz, Space attitude determination and control, 1978, P.764
%
% 08/10/04, implemented by swu
%-----------------------------------------------------------------

Cphi   = cos(phi);    Sphi   = sin(phi); 
Ctheta = cos(theta);  Stheta = sin(theta); 
Cpsi   = cos(psi);    Spsi   = sin(psi); 


A = [ Cpsi * Ctheta,   Cpsi * Stheta * Sphi + Spsi * Cphi,   -Cpsi * Stheta * Cphi + Spsi * Sphi;
      -Spsi * Ctheta,  -Spsi * Stheta * Sphi + Cpsi * Cphi,   Spsi * Stheta * Cphi + Cpsi * Sphi;
      Stheta,          -Ctheta * Sphi,                        Ctheta * Cphi] ;
    
return
