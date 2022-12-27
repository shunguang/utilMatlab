function img_resize

pp{1} = 'C:/temp/ttt';
%pp{1} = 'C:/swu/sony-camera/0RawInCamera/100MSDCF';
%pp{2} = 'C:/swu/sony-camera/0RawInCamera/101MSDCF';
%pp{2} = 'C:/swu/sony-camera/2018-Jun-selected-Just';
%pp{3}= 'C:/swu/sony-camera/2018-Justin-Jun-Best-pics';
for jj=1:numel(pp)
    p0 = pp{jj};
    pout = [p0, '_halfSize'];
    if ~exist(pout,'dir')
       mkdir(pout) 
    end
    
    v = dir( [p0, '/*.jpg'] );
    ff = {v.name};
    n =  numel(ff);
    for i=1:n
        f0 = ff{i};
        f1 = [p0, '/', f0];
        fout = [pout, '/h', f0];
        
        I = imread( f1 );
        [h,w,ch] = size(I);
        I = imresize(I, [0.5*h,0.5*w]);
        imwrite(I, fout)
        fprintf('jj=%d, n=%d,i=%d, %s --> %s\n', jj, n,i, f0, fout);
    end
end
end

