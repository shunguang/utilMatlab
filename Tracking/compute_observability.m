function [actualRank, desiredRank, observableFlag] = compute_observability(F, H)
% F, n x n, matrix
% H, p x n, the measurement matrix
[m, n] = size(F) ;
[p, q] = size(H) ;

if  m ~= n
    fprintf(  '\n compute_observability(): F is not a square matrix !')  
    pause ;
end

if  q ~= n
    fprintf(  '\n compute_observability(): the dimensions of F and H are not match !')  
    pause ;
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

return