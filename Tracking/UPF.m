%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File Name:    UPF.m
%
% Description:  Particle Filter based on SIR and 
%               Gaussian noise.  
%
% Date : 1/20/2003, 
% Author: Ningzhou Cui
%
% --------------------------------------------------------------
% Modification History
%---------------------------------------------------------------
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% pre: input current state, meas. and noise covariances
% post: return next state
% Note: 
%-----------------
% N:    # of particles 
% Xin:  ns * N
% Pin:  (ns*ns) * N 
%
function [Xout, Pout, Xin, Pin] = UPF(N, Xin, Pin, Z, Q, R, theta0, v0)


% Setting parameters. 
ns = size(Xin(:,1), 1);    %// dim of sates
nm = size(Z,1);    %// dim of meas. 

IPF = zeros(1,N);   %// Important functions
TF  = zeros(1,N);   %// Transition distributions/functions 
Likelihood = zeros(1,N);   
Weights = zeros(1,N); 

%
% Propogate and update( Sampling ) using Unscented Kalman Filter 
%

% Test standard particle filter only 
%  for (i = 1 : N)
%      Xp = Xin(:,i);
%      Pp = reshape(Pin(:,i), ns, ns); 
%      [Xp, Pp, Likelihood(i), IPF(i), TF(i)] = Particle( Xp, Pp, Z, Q, R,theta0,v0); 
%      Xin(:,i) = Xp; 
%      Pin(:,i) = Pp(:);
%      Weights(i) = Likelihood(i); % *TF(i)/IPF(i);
%  end

%% Test UPF 
for (i = 1 : N)
   % Call UPF to update each particle 
   %I_am_in_UPFwi = i
   Xp = Xin(:,i);
   Pp = reshape(Pin(:,i), ns, ns); 
   [Xp, Pp, Likelihood(i), IPF(i), TF(i) ] = UKF4PF(Xp, Pp, Z, Q, R, theta0, v0); 
   Xin(:,i) = Xp; 
   Pin(:,i) = Pp(:);
   Weights(i) = Likelihood(i)*TF(i)/IPF(i);
end

Weights = Weights./sum(Weights); % normalisation 
% plot(Weights); 

%
% Selection step ( Resampling )
%
Ni = zeros(1, N); 
Xi = zeros(ns, N); 
Pi = zeros(ns*ns,N); 
df = zeros(1, N + 1);   % distribution functions
df(1) = 0;  %// range from [0 1 2 ... N+1]
temp = 0; 

% Find the distribution function 
for (i = 1 : N)
    temp = temp + Weights(i);
    df(i + 1) = temp;
end

% Resampling 
for (i = 1 : N) % sample N times 
    ui = rand;
    for (M = 1 : N)
        if (ui > df(M)) & ( ui <= df(M+1) ) 
            Ni(M) = Ni(M) + 1; %// sampling times on particle M 
            Xi(:,M) = Xin(:,M); % // temp use later on 
            break; 
        end
    end
end
E = zeros(1,ns); 
for ( i = 1 : ns) 
    [v2, index2] = max(Xi(i,:)); 
    nz_index = find(Xi(i,:)); 
    if isempty(nz_index)
        v1 = 0;
    else
        [v1, index1] = min(Xi(i, nz_index)); 
    end
    E(i) = v2 - v1; 
end

%
% Roughening 
% 
i = 1;   % index for good samples 
j = 1;   % index for re-arranging samples, 1, ... ,N 
while (i <= N)
    if (Ni(i) > 0)
        for (m = 1 : Ni(i)) 
            Xi(:,j) = Xin(:,i); 
            Pi(:,j) = Pin(:,i); 
            j = j + 1; 
        end
    end
    i = i + 1; 
end

% jitter parameter 
sigma = zeros(ns,1);
K_fac = ones(ns,1) .* [.08  .08  0.5 0.5]'; %%%%%%%%%%%%%%%%
for (i = 1 : ns)
    sigma(i) = K_fac(i) * E(i) * N^(-1/ns); 
end
for ( i = 1 : N) 
    Xi(:,i) = Xi(:,i) + randn(ns,1).*sigma; % randn .* sigma, 1/29/03 
end 

%
% Figure out the combined output 
%
Xout = zeros(ns, 1); 
for (i = 1 : N)
    Xin(:,i) = Xi(:,i); 
    Xout = Xout + Xin(:,i); 
    Pin(:,i) = Pi(:,i);
end
Xout = Xout./N;
Pout = 0; %// no use 

return; 

%% --- eof ---