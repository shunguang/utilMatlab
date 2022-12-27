function [A] = choose_2_from_N ( N, printFlag )
%-----------------------------------------------------------------------
% the objective: given a pattern [1, 2, 3, ...,N], return all patterns/cobinations  of
%                choosing 2 from N .
% input:
%       N, 1 x 1, integer
% output:
%       A, 2 x M, where M = N*(N-1)/2 
%-----------------------------------------------------------------------

M = N*(N-1)/2;
A = zeros(2,M);
k=0;
for i=1:N-1
    for j=i+1:N
        k=k+1;
        A(:,k) = [i,j]';
    end
end

if printFlag
    myPrintMatrix('all cobination patterns', A);
end
return
