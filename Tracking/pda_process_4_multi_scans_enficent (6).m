function pda_init_paras( Nz )
global gPDA_nKbest ;            % the # of best measurements selected by thire likelihood value 
global gPDA_Has_Gate_Flag ;     % if has a gate
global gPDA_Parametric_Flag ;   %1 using parametric PDA, 0 non-para. PDA
global gPDA_cnz ;               %the value of the hypersphere, can be computed by Wu_hyperSphere.m ;
global gPDA_gamma;              %gate size; can be computed by Wu_computeGamma_sym.m & computeGamma_num.m ;
global gPDA_Pg;                 %the gate probability 
global gPDA_Pd;                 %the detetct probability 

gPDA_Has_Gate_Flag = 0 ;         % if has a gate
gPDA_nKbest = 30 ;               
gPDA_Parametric_Flag = 0 ;
gPDA_Pg = 0.99;                 %the gate probability 
gPDA_Pd = 0.95;                 %the detetct probability 
[S, gPDA_cnz] = Wu_hyperSphere(Nz,1) ;       %the value of the hypersphere, can be computed by Wu_hyperSphere.m ;
gPDA_gamma = Wu_computeGamma_num( Nz, gPDA_Pg );             %gate size; can be computed by Wu_computeGamma_sym.m & computeGamma_num.m ;
return
