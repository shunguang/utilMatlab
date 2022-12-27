%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File Name:    UKF4PF.m
%
% Description:  UKF used for UPF  
% 
% Date: 1/10/2003, By Ningzhou Cui
%----------------------------------------------------------------
% Modification History
%----------------------------------------------------------------
% 01/20/03:  modify propogation for Particle filer since wi should 
%            be sampled, which is one point different from regular 
%            UKF. (try this case to see the results ???? ) 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% pre: input current state, meas. and noise covariances
% post: return next state

function [Xout, Pout, Likelihood, IPF, TF] = UKF4PF( Xin, Pin, Z, Q, R)


% Set parameters. 
n = size(Xin,1);  
m = size(Z,1);  
NSP = 2 * n + 1;    % # of sigma points

X = zeros(n, NSP);  
w = zeros(1, NSP); 

% test kappa: 
% X: 3-n, 4 - n, 2-n, 1-n, 0
%

kappa = 3 - n ; %1 - n; %  - n;    %  note its sign, ???????????????????????????????????????????????????? 

% Calculate Weights and sigma points 
w(NSP) = kappa/(n + kappa) ;   
w(1:NSP-1) = 1/(2*(n + kappa)) ;    %w(1) to w(2*n)

sigma = chol( (n + kappa)*Pin ) ;  % sqrt(n + k) * , chol decom. the input covariance matrix
X(:, NSP) = Xin;       %sigma0 - stored in last column
for i = 1:n
    X(:, i) = Xin + sigma(i,:)'; 
    X(:, i + n) = Xin - sigma(i,:)'; 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% step1: propagation 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Zhat = zeros(m, NSP) ;    % porpagated results of the nSigma sigma pts
Xm = zeros(n,1); 
Zm = zeros(m,1); 
for i = 1 : NSP 
    
     X(:,i) = fh( X(:,i), theta0, v0, 'f') ; % ??????????????? 
     Zhat(:,i) = fh(X(:,i),0,0, 'h'); 
     
     Xm = Xm + X(:,i) * w(i);
     Zm = Zm + Zhat(:,i) * w(i); 
end

% compute the covaraince 
Pxx = Q;
Pvv  = R;
Pxz = zeros(n,m) ;
for i = 1 : NSP 
    dx = X(:,i) - Xm; 
    dz = Zhat(:,i) - Zm ;
    Pxx  = Pxx + w(i) * dx * dx' ; % computing the a priori covariance matrix
    Pvv  = Pvv + w(i) * dz * dz' ; 
    Pxz =  Pxz + w(i) * dx * dz' ;
end

% 
% Use modified version for kapa < 0 case without checking 
%
% if ( k < 0 ) % use P*
%     i = NSP; 
%     dx = X(:,i) - Xm; 
%     dz = Zhat(:,i) - Zm;
%     Pxx  = Pxx - w(i) * dx * dx' ; % computing the a priori covariance matrix
%     Pvv  = Pvv - w(i) * dz * dz' ; 
%     Pxz =  Pxz + w(i) * dx * dz' ;
% end
   
%
% Use modified version iff covariance are not positive defenitive
%

[temp, p1] = chol(Pxx);
if (p1 > 0)
    i = NSP;
    dx = X(:,i) - Xm;
    Pxx = Pxx - w(i) * dx * dx';
end

[temp, p2] = chol(Pvv);
if(p2 > 0) 
    i = NSP;
    dz = Zhat(:,i) - Zm;
    Pvv = Pvv - w(i)*dz*dz';
end
    
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% step2: Update estimation
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Gain = Pxz * inv( Pvv ) ; 
nu = Z - Zm ;
Xout = Xm + Gain * nu; 
Pout = Pxx - Gain * Pvv * Gain'; 

[temp, p3] = chol(Pout);
if (p3 > 0) 
    I_am_in_PF_Bad_Pout = 1
end
 
% Figure out important and transitin functions 
 
% Likelihood = exp(-.5*nu'*inv(Pvv)*nu)*MM/sqrt(2*pi*det(Pvv));
% IPF = exp(-.5 * Xout' * inv(Pout) * Xout)*MM/sqrt(2*pi*det(Pout)); 
% TF = exp(-.5 * Xm' * inv(Pxx) * Xm)*MM/sqrt(2*pi*det(Pxx)); 

%nu = Z - fh(Xin, 0, 0, 'h'); 
Likelihood = exp(-.5*nu'*inv(Pvv)*nu )/sqrt(2*pi*det(Pvv));
IPF = exp(-.5 * Xout' * inv(Pout) * Xout )/sqrt(2*pi*det(Pout));  
TF = exp(-.5 * Xin' * inv(Pin) * Xin )/sqrt(2*pi*det(Pin)); 

%weight = exp( -.5 * ( nu'*inv(R)*nu +  Xm'*inv(Pxx)*Xm - Xout'*inv(Pout)*Xout ) ); % * ...
%        sqrt( det(Pout)/( 2*pi*det(Pxx) ) ); 

if (Likelihood < eps)  
    Likelihoo = eps;  
end; 
if (IPF < eps)  
    IPF = eps;  
    % warning('IPF is too small');
end; 
if ( TF < eps)  
    TF = eps;  
end; 

return 

% --- eof ---
