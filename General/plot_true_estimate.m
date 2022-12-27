function plot_true_estimate(xTrueArray, xMeasArray, fTitle, yLabs)

measFlag = 0 ;
if nargin > 1
    measFlag = 1 ;
end

if nargin > 2
    titleFlag = 1 ;
else
    titleFlag = 0 ;
end


if nargin > 3
    labFlag = 1 ;
else
    labFlag = 0 ;
end

[M,N]=size(xTrueArray);

if measFlag
    [my_axis] = plot_get_boundary( [xMeasArray, xTrueArray], [ones(M,1), N*ones(M,1)]  ) ;
else
    [my_axis] = plot_get_boundary( xTrueArray, [ones(M,1), N*ones(M,1)] ) ;
end

figure
for i=1:M
    subplot(M,1, i);
    if measFlag
        plot( xMeasArray(i,:), 'b:', 'linewidth', 2);  hold on;
    end
    plot( xTrueArray(i,:), 'r-', 'linewidth', 2);  hold on;
    axis( my_axis(i,:) ) ;
    
    if labFlag
        ylabel( yLabs{i});
    end
    
    if i==1
        legend('estimated','true');
    end
    if i==1 & titleFlag
        title( fTitle);
    end
    if i==M
        xlabel( 'k');
    end
end
return
