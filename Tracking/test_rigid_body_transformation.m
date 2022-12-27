function [r] = test_rigid_body_transformation ( Xv )
%Xv = zeros(3, gM, gNpts);  % M vertexes position in earth coordinate

[L,M,N] = size(Xv) ;
nCombs = ceil(M*(M-1)/2) ;

r = zeros(nCombs,N);
for k=1:N
    id = 0 ;
    for i=1:M
        for j=i+1:M
            id = id + 1 ;
            r(id,k)  = dist( Xv(:,i,k)', Xv(:,j,k) ) ;  % distance between vertex 1 and 2
        end
    end
end

figure 
subplot(121)
n1 = ceil(nCombs/2) ;
for i=1:n1
    plot( r(i,:), 'b-' ); hold on ;
end
subplot(122)
for i=n1+1:nCombs
    plot( r(i,:), 'b-' ); hold on ;
end
return

