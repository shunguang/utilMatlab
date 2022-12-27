function obj = addColumns( obj, obj2 )
%  add several columns into obj.img
%  obj2 another TimeFreqImg, with fewwer image column
%  obj2.img, obj.nFreqBins x n;
%
%

imgW = obj.nTimeBins;   %image width
[m, n]=size(obj2.img);

assert( n>0, 'TimeFreq.addColumns(): inconsistant # of time samples');
assert( m == obj.nFreqBins, 'TimeFreq.addColumns(): inconsistant # of freq samples');
assert( obj.nextWrtColIdx <= imgW, 'TimeFreq.addColumns(): sth wrong!');

begIdx = obj.nextWrtColIdx;
endIdx = begIdx + n - 1;
if endIdx <= imgW
    %add by whole block just once
    obj.vFrmTime(begIdx:endIdx) = obj2.vFrmTime;
    obj.img(:, begIdx:endIdx) = obj2.img;
    
    %update <obj.nextWrtColIdx>
    obj.nextWrtColIdx = endIdx+1;
    if obj.nextWrtColIdx > imgW
        obj.nextWrtColIdx = 1;
        %<obj.isFullImg>: only updated once, is was constructured as flase
        if ~obj.isFullImg
            obj.isFullImg = true;
        end
    end
else
   %add col-by-col
   for i=1:n
       obj.vFrmTime(begIdx) = obj2.vFrmTime(i);
       obj.img(:, begIdx) = obj2.img(:,i);
       begIdx = begIdx + 1;
       if( begIdx > imgW)
           begIdx=1;
            %<obj.isFullImg>: only updated once, is was constructured as flase
           if ~obj.isFullImg
               obj.isFullImg = true;
           end
       end
   end

    %update <obj.nextWrtColIdx>
   obj.nextWrtColIdx = begIdx;
end

%debug
assert( obj.nextWrtColIdx>=1 && obj.nextWrtColIdx<= imgW, "TimeFreq.addColumns(): obj.nextWrtColIdx is out of order!");

end
