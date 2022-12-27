function [x3, P3, nu,Pzz] = oneStepUKF( x1, P1, z1 )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File Name:    oneStepUKF1.m
%
% Description:  One step Unscented Kalman Filter 
% input:        x1, gNp x 1,  state vector at  k|k
%               P1, gNp x gNp, state covaraince at k|k
%               z1, gNm x 1,  meas. at k|k
%
% output:       x3,  gNp x 1,   state vector at  k+1|k+1
%               P3,  gNp x gNp, state covaraince at k+1|k+1
%               nu,  gNm x 1,   innovation  at k+1|k+1
%               Pzz, gNm x 1,   covarianc eof innovation  at k+1|k+1
%
% Reference:    
%
% author:       S. Wu    
% First Write : 01/01/2003
% Last  Modify: 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global gNp gNm ;  % dim. of plant, dim. of meas.
global gQ ;
                            
myDebugFlag = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% step0: select sigma points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nSigma = 2 * gNp + 1;

% allocate memo for the local arrays
Sigma1 = zeros(gNp, nSigma ) ;   % intial select nSigma sigma pts
w   = zeros(1, nSigma ) ;       % weight  
Sigma2 = zeros(gNp, nSigma) ;    % porpagated results of the nSigma sigma pts
Zi     = zeros(gNm,nSigma) ;     % propagated measurements from the nSigma pts

% set parameters
kapa = 0 ;

%selected $2n+1$ sigma pts
Sigma1( :, nSigma )= x1 ;       %sigma0
w(nSigma) = kapa/(gNp+kapa) ;    %w(2*gNp +1) store w_0

w(1:nSigma-1) = 1/(2*(gNp+kapa)) ; %w(1) to w(2*gNp)

P =   chol( ( gNp + kapa ) * P1 ) ;  % chol decom. the input covariance matrix
for i=1:gNp
    Sigma1 (:,i)    = x1 + P(i,:)' ;
    Sigma1 (:,i+gNp) = x1 - P(i,:)' ;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% step1: propagation the nSigma simga pts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x2 = zeros(gNp,1);    % x(k+1|k)
z2 = zeros(gNm,1);   %predicted measurement z(k+1|k)
for i=1 : nSigma
     curSigma2 = propagate_state( Sigma1(:,i) ) ;    % Sigma(k+1|k)
     curMeas2  = estimate_measurement0( curSigma2 ) ;  %measurement estimation and R matrix compuation
     x2 = x2 + curSigma2 * w(i) ;
     z2 = z2 + curMeas2 * w(i) ;
     
     Sigma2(:,i) = curSigma2; % save Sigma(k+1|k) for compute covaraince Pxx and Pzx
     Zi(:,i)     = curMeas2;  % save propagated measurement for compute covaraince Pzz and Pzx
end

% compute the covaraince of x2 and z2
Pxx = gQ ;
Pzz  = compute_R0(x2) ;  % get Rk
Pxz = zeros(gNp, gNm) ;
for i=1 : nSigma
    tx = Sigma2(:,i) - x2 ;
    tz = Zi(:,i) - z2 ;
    Pxx  = Pxx + w(i) * tx * tx' ; % computing the a priori covariance matrix
    Pzz  = Pzz + w(i) * tz * tz' ; 
    Pxz =  Pxz + w(i) * tx * tz' ;
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% step3: compute gain, and update estimation
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Gain = Pxz * inv( Pzz ) ;  % Filter gain
nu = z1 - z2 

x3 = x2 + Gain * nu ; 
P3 = Pxx - Gain * Pzz * Gain' ; 

if myDebugFlag 
    fprintf('\n current estimated xc: %6.2f, %6.2f, %6.2f, %6.2f, %6.2f, %6.2f\n', x3(1), x3(2), x3(3), x3(4), x3(5), x3(6) );  
    fprintf('current estimated r: %6.2f, %6.2f, %6.2f;  dr: %6.2f, %6.2f, %6.2f;   ddr: %6.2f, %6.2f, %6.2f\n',  x3(7), x3(8), x3(9), x3(10), x3(11), x3(12),x3(13), x3(14), x3(15));  
    fprintf('current estimated theta:  %6.2f, %6.2f, %6.2f;  dtheta: %6.2f, %6.2f, %6.2f;   ddtheta: %6.2f, %6.2f, %6.2f\n',  x3(16), x3(17), x3(18), x3(19), x3(20), x3(21),x3(22), x3(23), x3(24));  
end

return 