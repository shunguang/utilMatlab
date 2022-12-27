function plot_X_true_n_estimate(ftitle1,ftitle2, ftitle3, x_true, x_est )
% x_true,  Np x N, true state vector
% x_est,   Np x N, est. state vector
global gM gNp ;
global gn_beg_r   gn_end_r ; % the begining position of radii
global gn_beg_eta gn_end_eta ; % the begining position of radii
global gn_beg_xi  gn_end_xi ; % the begining position of radii

estFlag = 1 ;
if nargin < 5 
    estFlag = 0;
else
    if size(x_est,1)==0
        estFlag = 0;
    end
end

[M,N]=size(x_true);

if estFlag
    [my_axis] = plot_get_boundary( [x_est, x_true], [1*ones(M,1), N*ones(M,1)] ) ;
else
    [my_axis] = plot_get_boundary( x_true ) ;
end

ylabs = getYlabes ;


figure  %plot xc,yc,zc, dxc,dyc,dzc, ddxc,ddyc,ddzc
for i=1:9
    subplot(3,3,i) %x
    plot( x_true(i,:), 'r-') ; hold on ;
    if estFlag
        plot( x_est(i,:), 'b:') ; hold on ;
    end
    ylabel( ylabs{i} );
    axis( my_axis(i,:) ) ;
end

figure % radii
k=0;
for i=gn_beg_r:gn_end_r
    k=k+1;
    subplot(gM,1,k) %x
    plot( x_true(i,:), 'r-') ; hold on ;
    if estFlag
        plot( x_est(i,:), 'b:') ; hold on ;
    end
    axis( my_axis(i,:) ) ;
    ylabel( ylabs{i} );
end

figure % angles - eta
k=0;
for i=gn_beg_eta:gn_end_eta
    k=k+1;
    subplot(gM+2,1,k) %x
    plot( x_true(i,:), 'r-') ; hold on ;
    if estFlag
        plot( x_est(i,:), 'b:') ; hold on ;
    end
    axis( my_axis(i,:) ) ;
    ylabel( ylabs{i} );
end

figure % angles - xi
k=0;
for i=gn_beg_xi:gn_end_xi
    k=k+1;
    subplot(gM+2,1,k) %x
    plot( x_true(i,:), 'r-') ; hold on ;
    if estFlag
        plot( x_est(i,:), 'b:') ; hold on ;
    end
    axis( my_axis(i,:) ) ;
    ylabel( ylabs{i} );
end

return

function ylabs = getYlabes
global gNp ;
global gn_beg_r   gn_end_r ; % the begining position of radii
global gn_beg_eta gn_end_eta ; % the begining position of radii
global gn_beg_xi  gn_end_xi ; % the begining position of radii

ylabs = cell(gNp,1);
ylabs{1}='x_c';      ylabs{2}='y_c';     ylabs{3}='z_c';
ylabs{4}='dx_c/dt';     ylabs{5}='dy_c/dt';    ylabs{6}='dz_c/dt';
ylabs{7}='d^2x_c/dt^2';   ylabs{8}='d^2y_c/dt^2';  ylabs{9}='d^2z_c/d^2t';

k=1;
for i=gn_beg_r:gn_end_r
    ylabs{i}=['r_', num2str(k)] ;
    k=k+1;
end
k=1;
for i=gn_beg_eta:gn_end_eta-2
    ylabs{i}=['\eta_', num2str(k)] ;
    k=k+1;
end
ylabs{gn_end_eta-1} = 'd\eta/dt';
ylabs{gn_end_eta} = 'd^2\eta/dt^2';

k=1;
for i=gn_beg_xi:gn_end_xi-2
    ylabs{i}=['\xi_', num2str(k)] ;
    k=k+1;
end
ylabs{gn_end_xi-1} = 'd\xi/dt';
ylabs{gn_end_xi} = 'd^2\xi/dt^2';
return
