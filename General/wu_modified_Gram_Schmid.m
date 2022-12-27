% ==============================================================================
% function wu_modified_Gram_Schmid
% input:   F  -- n x n system matrix
%          S1 -- P1= S1 * S1'
%          Wd -- Q = Wd * Wd' 
% ouput:   S2 -- P2 = S2 * S2'
%
% reference:Peter S. Maybeck, Stochastic models, Estimation and control, Vol 1, p381
% 
% implement by: Shunguang Wu
% first written: 08/14/02
% History:
% ==============================================================================
%function main

%F  = [2 2; 1 3];
%S1 = [1 0; 0 1] ;
%Wd = [1 0 ; 1 sqrt(2)];
%S2 = wu_modified_Gram_Schmid(F,S1,Wd)
%return

function S2 = wu_modified_Gram_Schmid(F, S1, Wd)

n = size(F,2);

A1 = [F*S1 Wd]';

for k=1:n
    ak = sqrt ( (A1(:,k))' * A1(:,k)) ;
    
    for j=1:n
        if j<k
            C(k,j) = 0 ;
        elseif j==k 
            C(k,j) = ak ;
        else
            C(k,j) = ( (1/ak) * (A1(:,k))' ) * A1(:,j) ;
        end
    end
    
    for j=k+1:n
        A2(:,j) = A1(:,j) - C(k,j)*( (1/ak)*A1(:,k) )
    end
    A1 = A2 ;
end

S2 = C';
return

