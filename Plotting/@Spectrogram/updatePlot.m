function updatePlot( obj, figTitle, savedFilePath, figId )
if nargin<1
    figTitle='';
    savedFilePath='';
    figId = 1;
elseif nargin<2
    savedFilePath='';
    figId = 1;
elseif nargin<3
    figId = 1;
end


[hImg, hFrmTime, hFreqBin] = obj.hTimeFreqImg.getDispImg();
[vImg, vFrmTime, vFreqBin] = obj.vTimeFreqImg.getDispImg();
[m,n] = size(vImg );

hMin=min(hImg(:));hMax=max(hImg(:));
vMin=min(vImg(:));vMax=max(vImg(:));
minColorLimit = min( hMin, vMin );
maxColorLimit = max( hMax, vMax ) + 0.1;
fprintf( 'hMin=%.2f, hMax=%.2f, vMin=%.2f, vMax=%.2f, minColorLimit=%.2f, maxColorLimit=%.2f\n', hMin, hMax, vMin,vMax,minColorLimit, maxColorLimit);
if minColorLimit==-Inf  && maxColorLimit==-Inf 
    return;
end
if minColorLimit==-Inf
    minColorLimit=0;
end

fig1 = figure(figId);
fig1.Position =[1 1 1920 1080];
%fig1.DefaultAxesFontSize = 18;

%left: Horizontal
sph{1} = subplot(1,2,1);
imagesc( hFrmTime , hFreqBin, flipud(hImg) );
caxis(sph{1},[minColorLimit,maxColorLimit]);

% on initialization: obj.localPlotInfo.imgH = imagesc(args);
% on replot: set(obj.localPlotInfo.imgH, 'CData', flipud(img), 'XData',
% vFrmTime)
% at the end: drawnow
xlabel( ['Time (', obj.cfg.timeUnit, '), nPoints=', num2str(n), ', resolution \deltaT =', num2str(obj.cfg.getTimeResolution()),')'] );
ylabel( ['Freq (', obj.cfg.freqUnit, '), nPoints=', num2str(m), ', resolution \deltaf=', num2str(obj.cfg.getFreqResolution()) ')'] );
axis( [vFrmTime(1), vFrmTime(end), vFreqBin(1), vFreqBin(end)] );
set(gca,'TickDir','out');
set(gca,'YDir','normal');

%right: vertical
sph{2} = subplot(1,2,2);
imagesc( vFrmTime, vFreqBin, flipud(vImg) );
caxis(sph{2},[minColorLimit,maxColorLimit]);
xlabel( ['Time (', obj.cfg.timeUnit, '), nPoints=', num2str(n), ', resolution \deltaT =', num2str(obj.cfg.getTimeResolution()),')'] );
ylabel( ['Freq (', obj.cfg.freqUnit, '), nPoints=', num2str(m), ', resolution \deltaf=', num2str(obj.cfg.getFreqResolution()) ')'] );
axis( [vFrmTime(1), vFrmTime(end), vFreqBin(1), vFreqBin(end)] );
set(gca,'TickDir','out');
set(gca,'YDir','normal');

h = axes(fig1,'visible','off'); 
h.Title.Visible = 'on';
h.XLabel.Visible = 'off';
h.YLabel.Visible = 'off';
%ylabel(h,'yaxis','FontWeight','bold');
%xlabel(h,'xaxis','FontWeight','bold');
th = title(h,figTitle);
set(th,'position',get(th,'position')+[0 0.02 0]);

if obj.cfg.isShowColorbar
    %colorbar('location','northoutside')
    c = colorbar(h,'Position',[0.93 0.168 0.022 0.7]);  % attach colorbar to h
    colormap(c,'jet')
end
caxis(h,[minColorLimit,maxColorLimit]);             % set colorbar limits


if ~isempty(savedFilePath)
    saveas(gcf, savedFilePath );
end
end
