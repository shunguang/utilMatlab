function [P1, s2 ] = UKF_test_sigma_points(P0, w, Sigma, xhat )

n = size(Sigma,2); % the # of columns

m = (n-1)/2 ;      % the dim of the state vector
P1 = zeros(m) ;

for i=1:n
    P1 = P1 + w(i) * ( Sigma(:,i) - xhat) * ( Sigma(:,i) - xhat)' ;
end

P2 = abs(P1 - P0) ;

s1 = sum(P2,2);

s2 = sum(s1);

return

    