function [Lines] = myLineStyles

C=['r','b','g','k','c','m','y'];
L=['-',':'];
S=['s','o','d'];

Lines = cell( length(C)*length(L)*length(S), 1);

n=0;
for i=1:length(C)
    for j=1:length(L)
        for k=1:length(S)
            n=n+1;
            Lines{n}=[C(i), L(j), S(k)] ;
        end
    end
end
return
