function [nu, covP, mk, beta0] = PDA_process_4_multi_scans2( zPredictMeasColVec, detS, invS, zMeasColVec, nScans )
global gPDA_Has_Gate_Flag ;         % if has a gate
global gPDA_nKbest ;            % the # of best measurements selected by thire likelihood value 

if gPDA_Has_Gate_Flag
    [nu, covP, mk, beta0] = PDA_w_gate( zPredictMeasColVec, detS, invS, zMeasColVec, nScans, gPDA_nKbest ) ;
else
    [nu, covP, mk, beta0] = PDA_wo_gate( zPredictMeasColVec, detS, invS, zMeasColVec, nScans ) ;
end

return

function [nu, covP, mk, beta0] = PDA_w_gate( zPredictMeasColVec, detS, invS, zMeasColVec, nScans, nKbest )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function:    PDA_w_gate
%  description: using the PDA idea to process cluter measurements
%  author:      S. Wu
%  First Write : 12/18/2003
%  Last  Modify: 02/26/2004
%
%  input:
%  zPredictMeasColVec,  the predicted measeurement for the base part and moving part
%  invS,   the inverse S matrices for the base and moving part
%  detS,   the det(S)
%  zMeasColVec,     the true meas. 
%  output:
%  nu,     gNm x 1, the difference between predict and real measurements
%  covP,   gNp x gNp, the covariance matrices for the state vector
%  mk,     1x1,  the # of measurements inside the gate
%  beta0,  1x1,  the false alarme coefficents
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global gPermutationPatterns ; %  M x N matrix stores the IDs of possible measurement sequences for process PDA
                               % for permutation, its the M! permutation patterns
                               
isDebugFlag = 0 ;

[nScs, nTotalPerms] = size(gPermutationPatterns) ;
if nKbest > nTotalPerms
    nKbest = nTotalPerms ;
end

if isDebugFlag      
   myPrintMatrix( 'gPermutationPatters:', gPermutationPatterns, 3);
   pause      
end

% get the last scan measurement from zMeasColVec, if nScans=1, the "last scan" is "the first scan"
nMeasDim = size(zMeasColVec, 1) ;
nBeg = nScs * ( nScans - 1 ) + 1 ;
nEnd = nMeasDim - 1 ;               % because the last row saves '1' the constrint
lastScanMeasColVec = zMeasColVec( nBeg : nEnd );

cluterMeasArray = zMeasColVec * ones(1, nTotalPerms) ;    % initialization as zMeasColVec
syntheticLastScanMeasArray = lastScanMeasColVec ( gPermutationPatterns ) ;  
cluterMeasArray(nBeg:nEnd, :) =  syntheticLastScanMeasArray ;  % just replace the last scan meas. with all possible permutations

if isDebugFlag
   myPrintMatrix('cluterMeasArray:', cluterMeasArray );   
   pause              
end

% NOTE!!!: from now on,  "cluterMeasArray" means a  Distance Vector Array
cluterMeasArray = cluterMeasArray - zPredictMeasColVec * ones(1, nTotalPerms) ;
normDisColVec   = sum( (cluterMeasArray' * invS) .*  cluterMeasArray', 2 ) ;

% sort the normDisColVec by ascending order 
[normDisColVec, Id] = sort( normDisColVec ) ;  

% take the k-best cultter measurements
Id = Id(1:nKbest) ;
normDisColVec = normDisColVec(1:nKbest) ;
cluterMeasArray = cluterMeasArray(:,Id) ;

%------ test if the correct sequence is inside the selected cluterMeasArray.---
% findFlag=0;
% permID = gPermutationPatterns(:, Id) ;
% for i=1:nKbest
%     nTmp = sum( abs (permID(:,i) - [1:nScs]') ) ;
%     if nTmp < 1 ; 
%         findFlag=1;
%         break ;        
%     end
% end
% findFlag
%------------- end test ---------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% step3:  compute the values of return variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isDebugFlag
   myPrintMatrix('the Distant Vector Array:', cluterMeasArray );   
   myPrintMatrix('normDisColVec:', normDisColVec );   
   pause              
end

[nu, covP, beta0] = PDA_final_step ( normDisColVec, cluterMeasArray, detS, nKbest) ;
mk = nKbest ;

return    


function [nu, covP, mk, beta0] = PDA_wo_gate( zPredictMeasColVec, detS, invS, zMeasColVec, nScans )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function:    PDA_wo_gate
%  description: using the PDA idea to process cluter measurements
%  author:      S. Wu
%  First Write : 12/18/2003
%  Last  Modify: 02/26/2004
%
%  input:
%  zPredictMeasColVec,  the predicted measeurement for the base part and moving part
%  invS,   the inverse S matrices for the base and moving part
%  detS,   the det(S)
%  zMeasColVec,     the true meas. 
%  output:
%  nu,     gNm x 1, the difference between predict and real measurements
%  covP,   gNp x gNp, the covariance matrices for the state vector
%  mk,     1x1,  the # of measurements inside the gate
%  beta0,  1x1,  the false alarme coefficents
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global gPermutationPatterns ; %  M x N matrix stores the IDs of possible measurement sequences for process PDA
                              % for permutation, its the M! permutation patterns
isDebugFlag = 0 ;

nMeasDim = size(zMeasColVec, 1) ;
[nScs, nTotalPerms] = size(gPermutationPatterns) ;
if isDebugFlag      
   myPrintMatrix( 'gPermutationPatters:', gPermutationPatterns, 3);
   pause      
end

% get the last scan measurement from zMeasColVec, if nScans=1, the "last scan" is "the first scan"
nBeg = nScs * ( nScans - 1 ) + 1 ;
nEnd = nMeasDim - 1 ;               % because the last row saves '1' the constrint
lastScanMeasColVec = zMeasColVec( nBeg : nEnd );

cluterMeasArray = zMeasColVec * ones(1, nTotalPerms) ;    % initialization as zMeasColVec
syntheticLastScanMeasArray = lastScanMeasColVec ( gPermutationPatterns ) ;  
cluterMeasArray(nBeg:nEnd, :) =  syntheticLastScanMeasArray ;  % just replace the last scan meas. with all possible permutations

if isDebugFlag
   myPrintMatrix('cluterMeasArray:', cluterMeasArray );   
   pause              
end

% NOTE: from now on,  "cluterMeasArray" means a  Distance Vector Array
cluterMeasArray = cluterMeasArray - zPredictMeasColVec * ones(1, nTotalPerms) ;
normDisColVec   = sum( (cluterMeasArray' * invS) .*  cluterMeasArray', 2 ) ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% step3:  compute the values of return variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isDebugFlag
   myPrintMatrix('gPda Dis Vector Array:', cluterMeasArray );   
   myPrintMatrix('normDisColVec:', normDisColVec );   
   pause              
end

[nu, covP, beta0] = PDA_final_step ( normDisColVec, cluterMeasArray, detS, nTotalPerms) ;
mk = nTotalPerms ;

return    