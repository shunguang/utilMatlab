function [nu, covP, beta0] = PDA_final_step (normDisColVec, disVectorArray, detS, mk)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% normDisColVec -  mk x 1;
% disVectorArray -  nz x mk ;
% detS, - 1 x 1, the det(S)
% mk - # of meas. inside the gate
% gPDA_Parametric_Flag,   1 using parametric PDA, 0 non-para. PDA
% gPDA_cnz,             the value of the hypersphere, can be computed by Wu_hyperSphere.m ;
% gPDA_gamma,           gate size; can be computed by Wu_computeGamma_sym.m & computeGamma_num.m ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global gPDA_Parametric_Flag ;   %1 using parametric PDA, 0 non-para. PDA
global gPDA_cnz ;               %the value of the hypersphere, can be computed by Wu_hyperSphere.m ;
global gPDA_gamma;              %gate size; can be computed by Wu_computeGamma_sym.m & computeGamma_num.m ;
global gPDA_Pg;                 %the gate probability 
global gPDA_Pd;                 %the detetct probability 


[nz, nPts] = size( disVectorArray );  
if mk < nPts
    normDisColVec(mk+1:nPts) = [];
    disVectorArray(:,mk+1:nPts) = [];
end

likelyhoodValueColVec = exp( -0.5* normDisColVec ) ;
eSum = sum(likelyhoodValueColVec);

if mk <= 0  
    nu = zeros(nz,1) ;
    covP = zeros(nz) ;
    beta0 = 1 ; 
else
    %fprintf(' the # of measurement in side the valiodation region is %d\n', mk );
    if gPDA_Parametric_Flag   % parametric PDAF 
        Vk = gPDA_cnz * gPDA_gamma ^(nz/2) * sqrt( detS ) ; 
        lambda = mk/Vk ;
        b = (2*pi/gPDA_gamma)^(nz/2) * lambda * Vk * gPDA_cnz *(1-gPDA_Pd*gPDA_Pg)/gPDA_Pd ;
    else % nonParametric PDAF
        b = (2*pi/gPDA_gamma)^(nz/2) * mk * gPDA_cnz *(1-gPDA_Pd*gPDA_Pg)/gPDA_Pd ;
    end
    
    beta  = likelyhoodValueColVec/(b+eSum) ;  % prob. of culter meas.
    beta0 = b/(b+eSum);   % prob. of false alarms 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % update the estimation & the covariance matrix
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%% by matrix operation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
    beta_v = (ones(nz,1)*beta' ) .* disVectorArray ;
    nu = sum(beta_v,2) ;
    covP = beta_v * disVectorArray';
    
    %%%%%%%%%% by vistit element -- very slow %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
    %        nu = zeros(nz,1) ;
    %        for j=1:mk
    %            nu = nu + beta(j)*disVectorArray(:,j) ;
    %        end
    
    %covariance matrix update
    %        covP = zeros(nz) ;
    %        for j=1:mk
    %            covP = covP +  beta(j)*disVectorArray(:,j)*disVectorArray(:,j)' ;
    %        end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end % for mk>0

return