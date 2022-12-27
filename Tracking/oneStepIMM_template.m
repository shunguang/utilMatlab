function [x_c, P_c, X3, P3, p_m, beta0, mk] = oneStepIMM( PDA_ParametricFlag, X1, P1, Pt, p_m1, ...
                                               curTargetDetectableFlag, curNumFlaseAlarms, curPd)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function:          wu_IMM_PDA
% objectivce:        IMM with PDA for one target tracking
%
% notes:             a Capital letter variable stands for matrix 
%                    a small letter variable stands for vector
% input:             
%                    PDA_ParametricFlag - 1 x 1, a flag to indictor the parametric or non-parametric 
%                                       will be used in PDA  
%                    X1 - Nx x Nm,      the state vectors of Nm models at previous time
%                    P1 - (Nx*Nx) x Nm, the covariance  matrixes of Nm models
%                    Z1 - nZ x mk,      the current measurement vector + false alarms
%                    Pt - Nm x Nm,      the model transition matrix
%                    p_m1 - Nm x 1,       the model probability at previous time
% output:
%                    x_c - Nx x 1,       the combined state vector
%                    P_c - Nx x Nx,      the combined covariance matrixes
%                    X3  - Nx x Nm,      the state vectors of Nm models at current time
%                    P3  - (Nx*Nx) x Nm, the covariance  matrixes of Nm models at current time
%                    p_m - Nm x 1,       the model probability at cuurent time
%
% first written:     S. Wu, 11/05/02
% last modified:     S. Wu  11/25/02
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global gFalseAlarmMeasurements ; % gNF*3 x 1, the first 3 rows is the true meas. if has,
                                 % the next 3 rows are the first flase
                                 % alarm, 
                                 
[Nx,Nm] = size(X1);  %Nx, dim of state vectore, correspond to oneStepEKF10_HRR.m 
                     %Nm, the # of models;
                     
% ------------- interaction --------------------
predPm = Pt'*p_m1;
MixPm = Pt.*(p_m1*(predPm.^(-1))');
X0 = X1*MixPm; 
for j = 1:Nm
  dX = X1(:,j)-X0(:,j); 
  PP = dX*dX'; 
  dP(:,j) = PP(:);
end
P0 = (P1+dP)*MixPm;

%------------------ filtering --------------------------
X3 = zeros(Nx, Nm);
P3 = zeros(Nx*Nx, Nm);
saveBeta0 = zeros(1,Nm);
saveMk = zeros(1,Nm);
for j = 1:Nm
  xj1 = X0(:,j);
  Pj1 = reshape( P0(:,j),Nx,Nx );
  
  [xj3, Pj3, S, nu, beta0, mk ] = wu_oneStep1stEKF_PDAF( j, PDA_ParametricFlag, xj1, Pj1, curTargetDetectableFlag, curNumFlaseAlarms, curPd ) ;

  X3(:,j) = xj3;
  P3(:,j) = reshape( Pj3, Nx*Nx, 1 );
  
  temp=0;
  dim_nu = size( nu, 1);
  detS= det(S);
  for i=1:dim_nu
    temp = temp + abs( nu(i))/sqrt(S(i,i) );
  end
  Lk(j) = exp(-0.5*temp)/sqrt(2*pi*detS);
  
  saveBeta0(1,j)= beta0 ;
  saveMk(1,j)= mk ;
end

%----------- model probability update --------------
p_m = predPm .* Lk';
p_m = p_m / sum(p_m) ;

%-------------- filtering combination -----------------
x_c = X3*p_m ;
for j = 1:Nm
  dx = X3(:,j) - x_c ; 
  PP = dx*dx' ;
  dP(:,j) = PP(:) ;
end
P_c = reshape( (P3+dP)*p_m, Nx, Nx );

beta0 = saveBeta0 * p_m ;
mk    = saveMk    * p_m ;
return;
 