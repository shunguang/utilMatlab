function y = getUniqTimeEntry( x, timeColumnId )
%x, m x n,

[m,n] = size(x);

y = zeros(m,n);

k=1
y(k,:) = x(1,:);
t0 = x(1, timeColumnId );
for i=2:m
    ti = x(i, timeColumnId );
    if ( ti - t0 > 0 )
        k = k+1;
        y(k, :) = x(i, :);
    end
    t0=ti;
end
y(k+1:m, :)=[];
