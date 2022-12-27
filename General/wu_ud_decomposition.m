% =========================================================================
% function:   wu_ud_decomposition
% input:      positive, symetric m by m matrix M. 
%
% note:       1. to keep speed, we do not check the positivty and symetry of M.
%             2. computation complexity: m(m-1)(m+4)/6 flops 
%
% ouput:      U, D, where M =  UDU'
%
% Reference:   Kalman Filtering: Theory and Practice using Matlab, 2001, Page: 222
%
% first written by:   S. WU,   08/10/02
% History: 
% =========================================================================
function [U, D, flag] = wu_ud_decomposition(M)

[n,m] = size(M) ;
D = zeros(m);
U = zeros(m);
flag = 0 ;
if n~=m
    disp('M is not a sqare matrix'); return ;
end


for j=m:-1:1
    for i=j:-1:1
        sigma = M(i,j);
        for k=j+1:m
            sigma = sigma - U(i,k)*D(k,k)*U(j,k);
        end
        
        if(i==j)
            D(j,j) = sigma;
            U(j,j) = 1 ;
        else
            U(i,j) = sigma/D(j,j);
        end
    end
end
flag = 1 ;
return;

