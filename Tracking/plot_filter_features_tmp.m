function plot_filter_features(ftitle, trP, observedRanks, desiredRank)
%---------------------------------
% plot_filter_features(ftitle, trP, observedRanks, desiredRank)
% trP,           vector, trace of the cov. matrix
% observedRanks, vector, the rank of observable matrix
% desiredRank,   scale, the actual system dimension
%---------------------------------
% History
% 1. Shunguang Wu,  07/13/05, at sarnoff Corporation
%
%---------------------------------

[axis_trP] = plot_get_boundary( trP ) ;
[axis_mk] = plot_get_boundary( mk ) 

nSubPlots = 1;
if nargin > 2
    nSubPlots = 2;
end

figure  %plot xc,yc,zc, dxc,dyc,dzc, ddxc,ddyc,ddzc
subplot(nSubPlots,1,1) %x
plot( trP, 'b-') ; hold on ;
axis( axis_trP ) ;
ylabel( 'tr(P)' );
title(ftitle);

if nargin > 2
    observedRanks = observedRanks(:);  %changed as a col. vector
    [n] = size(observedRanks, 1);
    desiredRanks = desiredRank * ones(n,1) ;
    min_y = min( [desiredRank; observedRanks] ) ;
    max_y = max( [desiredRank; observedRanks] ) ;
    
    subplot(nSubPlots,1,2) %x
    plot( desiredRanks, 'b-') ; hold on ;
    plot( observedRanks, 'r:') ; hold on ;
    axis( [0, n, 0, max_y+1] ) ;
    
    legend('desired Rank', 'observed Rank') ;
    ylabel( 'observerbility' );
    xlabel('k');
end
