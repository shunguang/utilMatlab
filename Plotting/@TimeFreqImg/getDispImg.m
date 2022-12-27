function [img, vTime, vFreq] = getDispImg( obj )
%-----------------------------------------------------------------
% img,   (r2-r1+1) x obj.nTimeBins, matrix
% vTime, 1 x obj.nTimeBins, 1d vector for time bins
% vFreq,  (r2-r1+1) x 1, 1d vector for freq bins
%-----------------------------------------------------------------
r1 = obj.foiIdx(1);
r2 = obj.foiIdx(2);
if obj.isFullImg
    n1 = obj.nextWrtColIdx;    %the oldest column
    n0 = n1-1;                 %the newest column
    %
    %note: it is ok for n0==0, since obj.vTimeBins(1:0) is empty
    %same for obj.vTimeBins(1:0)
    %
    img = [ obj.img(r1:r2, n1:end), obj.img(r1:r2, 1:n0)];

    %since imagesc(x,y,C) only need two-element vectors for x and y, we dot
    %not need return the whole elements, only begin and end points.
    %vTime = [obj.vFrmTime(n1:end), obj.vFrmTime(1:n0)];
    if n0 ~= 0
        vTime = [obj.vFrmTime(n1), obj.vFrmTime(n0)];
    else
        vTime = [obj.vFrmTime(1), obj.vFrmTime(end)];
    end
else
    img = obj.img(r1:r2, :);

    %vTime = obj.vFrmTime;
    vTime = [obj.vFrmTime(1), obj.vFrmTime(end)];
end
%same reason  for <vFreq> as explained in line 18.
%vFreq = obj.vFreqBin(r1:r2);
vFreq = [obj.vFreqBin(r1), obj.vFreqBin(r2)];
end
