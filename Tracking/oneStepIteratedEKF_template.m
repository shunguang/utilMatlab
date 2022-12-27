function [x3, P3, observedRank] = one_step_ekf_4_structure ( x1, P1, z1, F, Q, R0, T ) 

nMeasDim = size(z1,1);
nScs = size(R0,1);
nScans   = floor( nMeasDim / nScs ) ;

%---------------------------------------------------------------------------
% step1: propagation system state
%---------------------------------------------------------------------------
x2 = F * x1 ;
P2 = F * P1 * F' + Q ;


xi = x2 ;
invP2 =  inv(P2);

nMeasDim = size(z1,1) ;
nIEKF = 1 ;   % EKF:  iMax = 1, IEKF: imax > 1
for i=1:nIEKF
%    [z_hat, Hk] = get_meas_eqs_4_structure( xi, T, nMeasDim, nScs, nScans ) ;
    [z_hat, Hk] = get_meas_eqs_4_structure2( xi, T, nMeasDim, nScs, nScans ) ;
   
    [R] = compute_R (F, Q, R0, Hk) ;
%   [R] = compute_approximate_R (R0,nScs, nScans)  ;  
    S     =  Hk * P2 * Hk' + R ;
    invS  = inv(S) ;
    P3 = P2 - (P2 * Hk' * invS ) * Hk  * P2 ;

    nu = z1 - z_hat ; % in the case of no PDA, the measurement need to saved in the 1st column

    x_ip1 = xi + P3 * Hk' * inv(R) * nu - P3 * invP2 * ( xi - x2 ) ;
    
    xi = x_ip1 ;    
end
x3 = xi;

[observedRank] = compute_observability(F, Hk) ;
%observedRank = 1 ;
return 


