function [x3, P3, observedRank] = one_step_ekf_4_local_motion ( x1, P1, z_measured, F, Q, R0, T, secondOrderFlag, pdaFlag ) 

nMeasDim = size(z_measured,1);
nScs = size(R0,1);
nScans   = floor( nMeasDim / nScs ) ;

if nargin<8
    secondOrderFlag = 0 ;
    pdaFlag = 0;
end
%---------------------------------------------------------------------------
% step1: propagation system state 
%---------------------------------------------------------------------------
x2 = F * x1 ;
P2 = F * P1 * F' + Q ;

% evaluate meas. equation and Jacobian matrix
%[z_hat, Hk] =  get_meas_eqs_4_local_motion( xi, T, nMeasDim, nScs, nScans ) ;
[z_hat, Hk] =  get_meas_eqs_4_local_motion2( x2, T, nMeasDim, nScs, nScans ) ;
[R] = compute_R (F, Q, R0, Hk) ;
%  [R] = compute_approximate_R (R0,nScs, nScans)  ;  
S     =  Hk * P2 * Hk' + R ;

if secondOrderFlag
    [Hxx] = compute_meas_hessian_matrix_4_local(x2, T, nMeasDim, nScs, nScans) ;    
    % estimate the predict measurment
    z2nd = zeros(nMeasDim, 1) ;
    S2nd = zeros (nMeasDim) ;
    
    for i=1:nMeasDim
        ei = zeros(nMeasDim, 1) ;
        ei(i) = 1 ;
        z2nd = z2nd + ei * trace( Hxx{i} * P2 ) ;
   
        for j=1:nMeasDim
            ej = zeros(nMeasDim, 1) ;  ej(j) = 1 ;
            
            S2nd = S2nd + ( ei * ej' ) * trace ( Hxx{i} * P2 * Hxx{j} * P2 ) ;
        end
    end
    z2nd = z2nd / 2 ;
    S2nd = S2nd/2 ;
    
    z_hat = z_hat + z2nd ;    
    S = S + S2nd ;    
end

invS  = inv(S) ;
W = P2 * Hk' * invS ;

if pdaFlag   % with permutation
   Pc = P2 - W * Hk  * P2  ; 
   detS = det(S) ;
   [nu, covP, mk, beta0] = PDA_wo_FA( z_hat, detS, invS) ;

    % the update
    x3 = x2 + W * nu ; 
    P3 = beta0 * P2 + (1-beta0)*Pc + W * (covP - nu*nu') * W' ;
else              % without permutation
    nu = z_measured - z_hat ; % in the case of no PDA, the measurement need to saved in the 1st column
    x3 = x2 + W * nu ;
    P3 = P2 - W * Hk  * P2 ;
    mk= 1 ;
end
% normalizing the axis
x3(1:3) = normlize_axis( x3(1:3) ) ;

[observedRank] = compute_observability(F, Hk) ;
%observedRank = 1 ;
return 



