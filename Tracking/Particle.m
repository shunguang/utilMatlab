%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File Name:    Particle.m
%
% Description:  propagate and update of Particle filter  
% 
% Date: 1/10/2003, By Ningzhou Cui
%----------------------------------------------------------------
% Modification History
%----------------------------------------------------------------
% 01/20/03:  modify propogation for Particle filer since wi should 
%            be sampled, which is one point different from regular 
%            UKF. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% pre: input current state, meas. and noise covariances
% post: return next state

function [Xout, Pout, Likelihood, IPF, TF] = Particle(Xin, Pin, Z, Q, R, theta0, v0)


% Set parameters. 
n = size(Xin,1);  
m = size(Z,1);  

devi_Q = zeros(n,1); 
for (i = 1 : n)
    devi_Q(i) = sqrt(Q(i,i)); 
end

Xin = fh(Xin, theta0, v0, 'f') + randn(n,1) .* devi_Q;  %???? // add + w(i) sample drawn from process noise ?????
Zhat = fh(Xin, 0, 0, 'h'); %// add + v(i) sample from meas. noise 

Pvv  = R;

nu = Z - Zhat ;
Xout = Xin; 
Pout = 0*Pin; 

% Figure out important and transitin functions 
Likelihood = exp(-.5*nu'*inv(Pvv)*nu)/sqrt(2*pi*det(Pvv));
IPF = 1; 
TF = 1; 

return 

% --- eof ---
