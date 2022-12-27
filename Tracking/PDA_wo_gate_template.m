function [nu, covP, mk, beta0] = PDA_wo_FA( z_hat, detS, invS)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function:    PDA_wo_FA
%  description: using the PDA idea to process cluter measurements
%  author:      S. Wu
%  First Write : 12/18/2003
%  Last  Modify: 02/26/2004
%
%  input:
%  z_hat,  the predicted measeurement for the base part and moving part
%  invS,   the inverse S matrices for the base and moving part
%  detS,   the det(S)
%
%  output:
%  nu,     gNm x 1, the difference between predict and real measurements
%  covP,   gNp x gNp, the covariance matrices for the state vector
%  mk,     1x1,  the # of measurements inside the gate
%  beta0,  1x1,  the false alarme coefficents
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global gM gNp gNm;  % sampling interval, # of vertexes, dim. of plant, dim. of meas.  dim. of  center state
global gCurMeasuredAngles ; % take the measured angles
global gCurMeasuredRanges ; % the measured ranges

global gn_K_MAX;        % maximum # of meaurements, (gM!), for caseFlag = 2 
                        % maximum # of meaurements, K, for caseFlag = 3
global gMeas_squence_Pattern ; %  M x N matrix stores the IDs of possible measurement sequences for process PDA
                               % for permutation, its the M! permutation patterns
                               % for smoothing, its the N-best sequences 


debugFlag = 0;
N_max = gn_K_MAX ;  % get the max. # of measurements

% 2.1: allocate memory for processing possible all the combinations of  the meas.
curCluterMeasment = zeros( gNm, 1 );
curCluterMeasment(gNm) = gCurMeasuredAngles ;  % the angle part no chnage 

v = zeros( gNm, N_max ) ;
e = zeros( N_max,1 ) ;

%
% 2.2: loop for processing  each possible meas.
%
      
if debugFlag      
   myPrintMatrix( 'gMeas_squence_Pattern:', gMeas_squence_Pattern);
   pause      
end
      
q = 0 ; %index for counting total Measurements Inside base ;
for j=1:N_max  % for each combination, we need to do permutation inside
%for j=109:109 %N_max  % for each combination, we need to do permutation inside
    for i=1:gM
        curCluterMeasment(i) = gCurMeasuredRanges(  gMeas_squence_Pattern(i,j) ) ;
    end
    dis = curCluterMeasment - z_hat ;
    %%%%%%% for debug %%%%%%%%%%%% 
    if debugFlag
       myPrintMatrix('curCluterMeasure', curCluterMeasure );   
       myPrintMatrix('dis', dis );   
       pause              
    end
    %%%%%%% end debug %%%%%%%%%%%% 
    q = q + 1;
    v(:,q)  = dis ;
    e(q)  = dis'*invS*dis ;
end % for j


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% step3:  compute the values of return variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if debugFlag
   myPrintMatrix('v:', v );   
   myPrintMatrix('e:', e );   
   pause              
end

mk = q ;
e = exp( -0.5* e ) ;
[nu, covP, beta0] = PDA_final_step ( e, v, detS, q ) ;
return    