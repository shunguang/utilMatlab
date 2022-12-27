%========================================================================
% -pi <= theta1( = ATAN2(Y,X) ) <= pi
% 0 <= theta2 <= 2*pi
%========================================================================
function  theta2 = normalizeATAN2( theta1 )

[m,n] = size(theta1);  % theta1 is a one dimensional array

theta2 = zeros(m,n); % a column vector

for i=1:m
    for j=1:n
        if theta1(i,j) >= 0 
            theta2(i,j) = theta1(i,j) ;
        else
            theta2(i,j) = theta1(i,j) + pi + pi ;
        end
    end
end
return
