function [actualRank, desiredRank, observableFlag] = compute_observability(F, H)
%---------------------------------
% [actualRank, desiredRank, observableFlag] = compute_observability(F, H)
% F, n x n, matrix
% H, p x n, the measurement matrix
%---------------------------------
% History
% 1. Shunguang Wu,  07/12/05, sarnoff Corporation
%
%---------------------------------
[m, n] = size(F) ;
[p, q] = size(H) ;

if  m ~= n
    error('\n compute_observability(): F is not a square matrix !') ; 
end

if  q ~= n
    error('\n compute_observability(): the dimensions of F and H are not match !') ;
end

V = zeros(n*p,n) ;
for i=1:n
    V( (i-1)*p+1 : i*p, :) = H * F^(i-1) ;
end

actualRank = rank(V) ;

if nargout > 1
    desiredRank = n ;
end

if nargout > 2
    observableFlag = 0 ;
    if desiredRank == actualRank
        observableflag  = 1
    end
end
%eof
