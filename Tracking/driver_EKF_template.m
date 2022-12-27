function main
clear all;  close all;

global   gNpts ;   % # of sampling pts
global   gT gM gNp gNm;  % sampling interval, # of vertexes, dim. of plant, dim. of meas.  dim. of  center state
global   gTargets gConfusers;  % target & confuser's geometric parameters

% ==================================================
% data gneration parameters
% ==================================================
global  gSig_gmti_Rc gSig_gmti_Rc_rate gSig_gmti_eta gSig_gmti_xi ;
global  gSig_hrr_R gSig_hrr_ri ;

global  g_radar0  ;     % 3 x 1, initial radar center position in the earth coordinate system
global  g_target0 ;     % 3 x 1, initial target pseudo center position in the earth coordinate system
global  g_R0 g_omega_global;  % the radius and angle velocity of traget's global motion
global  g_omega_local;        % the target local rotation velocity

% ==================================================
% Filter para
% ==================================================
global gF gQ gR ;       % system matrices and measurement covariance

% ==================================================
% False alarm parameters
% ==================================================
global gnMaxThermoFA;              % # of false alarm for thermodynamic way
global gnMaxOBJFA;                 % maximum # of obj false alarms at each instance   
global gnTotalConfusers ;          % # of confusers along the target circle.
global gThermoUncertaintyFactor ;  % used to control the thermo uncertainties

% ==================================================
% store current measurements
% ==================================================
global  gCurMeasWithFA;      % ciurent meas. with false alarms
global  gPermutationPatterns;  % the permuation patterns

% ==================================================
%   the following varaibles are used to index the state vector
% ==================================================
global gn_beg_r   gn_end_r ; % the begining position of radii
global gn_beg_eta gn_end_eta ; % the begining position of radii
global gn_beg_xi  gn_end_xi ; % the begining position of radii

% ==================================================
%   the following varaibles for PDA process
% ==================================================
global gPDA_Parametric_Flag ;   %1 using parametric PDA, 0 non-para. PDA
global gPDA_cnz ;               %the value of the hypersphere, can be computed by Wu_hyperSphere.m ;
global gPDA_gamma;              %gate size; can be computed by Wu_computeGamma_sym.m & computeGamma_num.m ;
global gPDA_Pg;                 %the gate probability 
global gPDA_Pd;                 %the detetct probability 

global gn_MAX_in_Gate ;         % maximum # of measurements in gate
global gMeas_squence_Pattern ;  % all possible sequence by permuation

plotMeasureFlag = 0 ;
FalseAlarmFlag = 0 ;

nMCRs = 1 ;
nTotPts = 600 ;              % # of sampling pts in generate data
has_PDA_flag = 0;

q_c =  0.5 ;    % noise intensity for CV models (reference vertex)
q_r =  0.001;   % noise intensity for radii
q_eta = 0.01;   % noise intensity for horizontal angle
q_xi = 0.1;     % noise intensity for vertical angle

init_globals_pivoting_based ( nTotPts ) ; % initialize the globals
nTrackPts  = gNpts-2;        % # of pts used in tracking

[gTargets, gConfusers] = setTargetParameters_3D ;
[gF, gQ, gR] = setTrackingPara_pivot( q_c, q_r, q_eta, q_xi ) ;

if has_PDA_flag
   init_PDA_paras( gNm ) ;
   gMeas_squence_Pattern =  perms([1:gM])' ;
   gn_MAX_in_Gate = size(gMeas_squence_Pattern,2);
end

% allocation memo. for staore the tracking results 
average_x_hat = zeros(gNp,nTrackPts) ;
average_trP   = zeros(1,  nTrackPts) ;
average_x_RMS = zeros(gNp,1) ;
average_mk    = zeros(1, nTrackPts ) ;  % average # of validation meas. inside the gate

beg_time = cputime ;
for iM =1:nMCRs
    fprintf('\n %d * ', iM);
    
    
    if nMCRs >1
        rand_seed  = cputime * 1000 ;
        randn_seed = cputime * 50000 ; 
    else
        rand_seed  = 1024 ;
        randn_seed = 4096 ; 
    end

    [x_true, HRR_true, HRR_meas, GMTI_true, GMTI_meas] = data_gen_pivot_based( rand_seed,  randn_seed, plotMeasureFlag, FalseAlarmFlag );
    
    [xh3, Ph3] = init_tracker_pivot ( q_c, q_r, q_eta, q_xi, x_true(:,1) ) ;
    
    for k=1:nTrackPts
        
        if mod(k,500) == 0
            fprintf('%d ', k)
        end

        gCurMeasWithFA = [GMTI_meas(:,k); HRR_meas(:,k) ] ;
          
        [xh3, Ph3, cur_nu, invS, cur_mk] = oneStepEKF_pivot( xh3, Ph3, has_PDA_flag) ;

        average_x_hat(:,k) = average_x_hat(:,k) + xh3 ;
        average_trP(k)     = average_trP(k) + trace(Ph3) ;
        average_mk(k)      = average_mk(k) + cur_mk ;  % average # of validation meas. inside the gate
    end  
end

%===============================================================
average_x_hat  = average_x_hat  / nMCRs ;
average_trP    = average_trP    / nMCRs ;
average_mk     = average_mk     / nMCRs ;

size(x_true)
size(average_x_hat)

average_x_RMS  = computeRMS( x_true, average_x_hat,'nodisp' ) ;

sys_str = get_sys_pivot_str( nMCRs, q_c,q_r, q_eta, q_xi ) ;
[FA_str, noise_str, sensor_target_str] = get_meas_para_strings ;

plot_X_true_n_estimate(sys_str, noise_str, sensor_target_str, x_true, average_x_hat ) ;
plot_filter_features([sys_str, noise_str, sensor_target_str], average_trP, average_mk ) ;

fprintf('\n %s %s\n', sys_str ) ;
fprintf('%s \n', FA_str ) ;
fprintf('%s \n', noise_str) ;
fprintf('%s \n', sensor_target_str ) ;
print_x_RMS( 'RMS', average_x_RMS ) ;

used_CPU_Time = cputime - beg_time 

return

