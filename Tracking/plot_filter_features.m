function plot_filter_features(ftitle, trP, mk, observedRanks, desiredRank ) ;

[axis_trP] = plot_get_boundary( trP ) ;
[axis_mk] = plot_get_boundary( mk ) 

nSubPlots = 2;
if nargin > 3
    nSubPlots = 3 ;
end

figure  %plot xc,yc,zc, dxc,dyc,dzc, ddxc,ddyc,ddzc
subplot(nSubPlots,1,1) %x
plot( trP, 'b-') ; hold on ;
axis( axis_trP ) ;
ylabel( 'tr(P)' );
title(ftitle);

subplot(nSubPlots,1,2) %x
plot( mk, 'b-') ; hold on ;
axis( axis_mk ) ;
ylabel( 'mk' );
xlabel('k');

if nargin > 3
    observedRanks = observedRanks(:);  %changed as a col. vector
    [n] = size(observedRanks, 1);
    desiredRanks = desiredRank * ones(n,1) ;
    min_y = min( [desiredRank; observedRanks] ) ;
    max_y = max( [desiredRank; observedRanks] ) ;
    
    subplot(nSubPlots,1,3) %x
    plot( desiredRanks, 'b-') ; hold on ;
    plot( observedRanks, 'r:') ; hold on ;
    axis( [0, n, 0, max_y+1] ) ;
    
    legend('desired Rank', 'observed Rank') ;
    ylabel( 'observerbility' );
    xlabel('k');
end
return
