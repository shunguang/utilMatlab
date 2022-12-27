function draw_target_on_xy( Xv, nSkip )

[L,M,N] = size(Xv) ;

figure
subplot(121)
for k=1:N
    if mod(k,nSkip)==0
        X = [ Xv(1,1,k) Xv(1,2,k) Xv(1,3,k) Xv(1,4,k) Xv(1,5,k) Xv(1,1,k) ];
        Y = [ Xv(2,1,k) Xv(2,2,k) Xv(2,3,k) Xv(2,4,k) Xv(2,5,k) Xv(2,1,k) ];
        plot( X, Y, 'r-' ) ; hold on ;
    end
end
xlabel('x');
ylabel('y');

subplot(122)

Z = zeros(M,N);
for i=1:M
    for k=1:N
        Z(M,k) = Xv(3,M,k) ;
    end
end

for i=1:M
    plot( Z(i,:), 'b-');  hold on ;
end
zmax = max(max(Z,[],2));
zmin = min(min(Z,[],2));

axis([0,N,zmin,zmax]);
xlabel('k');
ylabel('z');
    
return
