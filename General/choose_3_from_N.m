function [A] = choose_2_from_N ( N, printFlag )
%-----------------------------------------------------------------------
% the objective: given a pattern [1, 2, 3, ...,N], return all patterns/cobinations  of
%                choosing 3 from N .
% input:
%       N, 1 x 1, integer
% output:
%       A, 3 x M, where M = N*(N-1)*(N-2)/(3*2) 
%-----------------------------------------------------------------------

M = N*(N-1)*(N-2) / ( 2*3 );
A = zeros(3,M);
count=0;
for i=1:N-2
    for j=i+1:N-1
        for k=j+1:N
            count = count + 1;
            A(:,count) = [i,j,k]';
        end
    end
end

if printFlag
    myPrintMatrix('all cobination patterns', A);
end
return
