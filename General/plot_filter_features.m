function plot_filter_features(ftitle, trP, mk, observedRank, nx ) ;

[axis_trP] = plot_get_boundary( trP ) ;
[axis_mk] = plot_get_boundary( mk ) ;

nSubPlots = 2;
if nargin > 3
    nSubPlots = 3 ;
end
figure  %plot xc,yc,zc, dxc,dyc,dzc, ddxc,ddyc,ddzc
subplot(nSubPlots,1,1) %x
plot( trP, 'b-', 'linewidth', 2) ; hold on ;
axis( axis_trP ) ;
ylabel( 'tr(P)' );
title(ftitle);

subplot(nSubPlots,1,2) %x
plot( mk, 'b-', 'linewidth', 2) ; hold on ;
axis( axis_mk ) ;
ylabel( 'mk' );
xlabel('k');

if nargin > 3
    observedRank = observedRank(:);  %changed as a col. vector
    [n] = size(observedRank, 1);
    desiredRank = nx * ones(n,1) ;
    min_y = min( [nx; observedRank] ) ;
    max_y = max( [nx; observedRank] ) ;
    
    subplot(nSubPlots,1,3) %x
    plot( desiredRank, 'b-', 'linewidth', 2) ; hold on ;
    plot( observedRank, 'r:', 'linewidth', 2) ; hold on ;
    axis( [0, n, 0, max_y+1] ) ;
    
    legend('desired Rank', 'observed Rank') ;
    ylabel( 'observerbility' );
    xlabel('k');
end
return
