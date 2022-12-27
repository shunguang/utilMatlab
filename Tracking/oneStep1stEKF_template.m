function [x3, P3, nu, invS, mk] = oneStep1stEKF( x1, P1, has_PDA_Flag )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File Name:    oneStep1stEKF.m
% Description: a general 1 step function of the 1st order extend Kalman Filter
% function call:
%             est_measurement0()
%             est_meas_jacobian0()
%             est_meas_R0()
% Author:      Shunguang Wu
%
% First Write : 03/05/2001
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global  gNp gNm  ;          % measurement and system dimensions 
global  gF gQ gR ;          % system matrices and measurement covariance
global  gCurMeasWithFA;     % gNm x m_k, ciurent meas. with false alarms or
                            % gNm x 1,   ciurent meas. without false alarms

%---------------------------------------------------------------------------
% step1: propagation system state
%---------------------------------------------------------------------------
x2 = gF * x1 ;
P2 = gF * P1 * gF' + gQ ;

%---------------------------------------------------------------------------
% step2: using the propagation results predict measurement
%---------------------------------------------------------------------------
[z_hat] = est_measurements( x2 )  ;  % measurement estimation and R matrix compuation
[Hk]    = est_meas_jacobian( x2 ) ;  % cal. H_{k}^{[1]}
[R_k]   = est_meas_R0 ( x2 ) ; 

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% step3: compute gain, the update
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
S =  Hk * P2 * Hk' + Rk ;  
invS  = inv(S) ;
W = P2 * Hk' * invS ;

if has_PDA_Flag   % with permutation
   Pc = P2 - W * Hk  * P2  ; 
   detS = det(S) ;
   [nu, covP, mk, beta0] = PDA_wo_FA( z_hat, detS, invS) ;

    % the update
    x3 = x2 + W * nu ; 
    P3 = beta0 * P2 + (1-beta0)*Pc + W * (covP - nu*nu') * W' ;
else              % without permutation
    nu = gCurMeasWithFA - z_hat ; % in the case of no PDA, the measurement need to saved in the 1st column
    x3 = x2 + W * nu ;
    P3 = P2 - W * Hk  * P2 ;
    mk= 1 ;
end

return 