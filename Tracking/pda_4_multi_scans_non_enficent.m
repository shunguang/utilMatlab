function [nu, covP, mk, beta0] = PDA_process_4_multi_scans( z_hat, detS, invS, z1, nScans )
global gPDA_Has_Gate_Flag ;         % if has a gate
global gPDA_nKbest ;            % the # of best measurements selected by thire likelihood value 

if gPDA_Has_Gate_Flag
    [nu, covP, mk, beta0] = PDA_w_gate( z_hat, detS, invS, z1, nScans, gPDA_nKbest ) ;
else
    [nu, covP, mk, beta0] = PDA_wo_gate( z_hat, detS, invS, z1, nScans ) ;
end

return

function [nu, covP, mk, beta0] = PDA_w_gate( z_hat, detS, invS, z1, nScans, nKbest )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function:    PDA_w_gate
%  description: using the PDA idea to process cluter measurements
%  author:      S. Wu
%  First Write : 12/18/2003
%  Last  Modify: 02/26/2004
%
%  input:
%  z_hat,  the predicted measeurement for the base part and moving part
%  invS,   the inverse S matrices for the base and moving part
%  detS,   the det(S)
%  z1,     the true meas. 
%  output:
%  nu,     gNm x 1, the difference between predict and real measurements
%  covP,   gNp x gNp, the covariance matrices for the state vector
%  mk,     1x1,  the # of measurements inside the gate
%  beta0,  1x1,  the false alarme coefficents
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global gPermutationPatterns ; %  M x N matrix stores the IDs of possible measurement sequences for process PDA
                               % for permutation, its the M! permutation patterns
                               
isDebugFlag = 0 ;

nMeasDim = size(z1, 1) ;
[nScs, nTotalPerms] = size(gPermutationPatterns) ;

% 2.1: allocate memory for processing possible all the combinations of  the meas.
if nKbest > nTotalPerms
    nKbest = nTotalPerms ;
end
disVectorArray = zeros( nMeasDim, nKbest ) ;
normDisColVec  = zeros( nKbest,1 ) ;
      
if isDebugFlag      
   myPrintMatrix( 'gPermutationPatters:', gPermutationPatterns, 3);
   pause      
end

% get the last scan measurement from z1, if nScans=1, the "last scan" is "the first scan"
nBeg = nScs * ( nScans - 1 ) + 1 ;
nEnd = nMeasDim - 1 ;    %delete the last element, because it saves '1' the constrint
lastScanMeasColVec = z1( nBeg : nEnd );
curCluterMeas = z1 ;    % initialization as z1

%
% 2.2: loop for processing  each possible meas.
%
maxNormDisInGate = 0 ;
maxNormDisInGateId = 0;

for i=1:nTotalPerms  % for each combination, we need to do permutation inside
    syntheticLastScanMeasVec = lastScanMeasColVec ( gPermutationPatterns(:, i) ) ;  
    curCluterMeas(nBeg:nEnd) = syntheticLastScanMeasVec ;  % just flush the the last unit in curCluterMeas
    dis = curCluterMeas - z_hat ;
    %%%%%%% for debug %%%%%%%%%%%% 
    if isDebugFlag
       myPrintMatrix('curCluterMeas', curCluterMeas );   
       myPrintMatrix('dis', dis );   
       pause              
    end
    %%%%%%% end debug %%%%%%%%%%%% 
    
    curNormDis = dis'*invS*dis ;
    if i <= nKbest  % store the first nKbest measurement AS IS.
        disVectorArray(:,i)  = dis ;
        normDisColVec(i)  = curNormDis ;
        
        %find the largest normal distance and its ID for the 1st nKbest measurements
        if normDisColVec(i) > maxNormDisInGate 
           maxNormDisInGate = curNormDis ;
           maxNormDisInGateId = i ; 
        end
    else
        if curNormDis < maxNormDisInGate 
           normDisColVec( maxNormDisInGateId ) = curNormDis ;  
           % update maxNormDisInGate & maxNormDisInGateId
           [maxNormDisInGate, maxNormDisInGateId] = max ( normDisColVec ) ;   
        end
    end
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% step3:  compute the values of return variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isDebugFlag
   myPrintMatrix('disVectorArray:', disVectorArray );   
   myPrintMatrix('normDisColVec:', normDisColVec );   
   pause              
end

[nu, covP, beta0] = PDA_final_step ( normDisColVec, disVectorArray, detS, nKbest) ;
mk = nKbest ;

return    

function [nu, covP, mk, beta0] = PDA_wo_gate( z_hat, detS, invS, z1, nScans )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function:    PDA_wo_gate
%  description: using the PDA idea to process cluter measurements
%  author:      S. Wu
%  First Write : 12/18/2003
%  Last  Modify: 02/26/2004
%
%  input:
%  z_hat,  the predicted measeurement for the base part and moving part
%  invS,   the inverse S matrices for the base and moving part
%  detS,   the det(S)
%  z1,     the true meas. 
%  output:
%  nu,     gNm x 1, the difference between predict and real measurements
%  covP,   gNp x gNp, the covariance matrices for the state vector
%  mk,     1x1,  the # of measurements inside the gate
%  beta0,  1x1,  the false alarme coefficents
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global gPermutationPatterns ; %  M x N matrix stores the IDs of possible measurement sequences for process PDA
                               % for permutation, its the M! permutation patterns
                               
isDebugFlag = 0 ;

nMeasDim = size(z1, 1) ;
[nScs, nTotalPerms] = size(gPermutationPatterns) ;

% 2.1: allocate memory for processing possible all the combinations of  the meas.
disVectorArray = zeros( nMeasDim, nTotalPerms ) ;
normDisColVec = zeros( nTotalPerms,1 ) ;

%
% 2.2: loop for processing  each possible meas.
%
      
if isDebugFlag      
   myPrintMatrix( 'gPermutationPatters:', gPermutationPatterns, 3);
   pause      
end

% get the last scan measurement from z1, if nScans=1, the "last scan" is "the first scan"
nBeg = nScs * ( nScans - 1 ) + 1 ;
nEnd = nMeasDim - 1 ;    %delete the last element, because it saves '1' the constrint
lastScanMeasColVec = z1( nBeg : nEnd );

curCluterMeas = z1 ;    % initialization as z1
for i=1:nTotalPerms  % for each combination, we need to do permutation inside
    syntheticLastScanMeasVec = lastScanMeasColVec ( gPermutationPatterns(:, i) ) ;  
    curCluterMeas(nBeg:nEnd) = syntheticLastScanMeasVec ;  % just flush the the last unit in curCluterMeas
    
    dis = curCluterMeas - z_hat ;
    %%%%%%% for debug %%%%%%%%%%%% 
    if isDebugFlag
       myPrintMatrix('curCluterMeas', curCluterMeas );   
       myPrintMatrix('dis', dis );   
       pause              
    end
    %%%%%%% end debug %%%%%%%%%%%% 
    disVectorArray(:,i)  = dis ;
    normDisColVec(i)  = dis'*invS*dis ;
end % for j

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% step3:  compute the values of return variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isDebugFlag
   myPrintMatrix('disVectorArray:', disVectorArray );   
   myPrintMatrix('normDisColVec:', normDisColVec );   
   pause              
end

[nu, covP, beta0] = PDA_final_step ( normDisColVec, disVectorArray, detS, nTotalPerms) ;
mk = nTotalPerms ;

return    