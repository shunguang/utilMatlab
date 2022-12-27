function img2video

%pp{1} = 'C:/swu/sony-camera/2018-may-selected-Just/';
%pp{2} = 'C:/swu/sony-camera/2018-Jun-selected-Just/';

pp{1} = 'C:/tmp/';

resizeTo1080x1920 =  false;
p.q = 95;
p.fr = 20; %10

outFile = ['C:/temp/t_fr', num2str(p.fr), '_quality', num2str(p.q), '.mp4'];
newVid = VideoWriter(outFile, 'MPEG-4'); % New
newVid.FrameRate = p.fr;
newVid.Quality = p.q;
open( newVid )
for jj=1:numel(pp)
    p0 = pp{jj};
    v = dir( [p0, '*.png'] );
    ff = {v.name};
    ff = sort(ff);
    n =  numel(ff);

    %[vFn, vDn] = get_fnum( ff );
    for i=1:n
        f0 = ff{i};
        f1 = [p0, f0];
        I = imread( f1 );
        if resizeTo1080x1920 
            I = imresize(I, [1080,1920]);
        end

        %if vDn(i)== 1
        %    nRepeat=1;
        %else
        %    nRepeat=3;
        %end
        
        %for j=1:nRepeat
            writeVideo(newVid, I );
        %end
        %fprintf('jj=%d, n=%d,i=%d, %s, %d\n', jj, n,i, f0, nRepeat);
        fprintf('jj=%d, n=%d,i=%d, %s\n', jj, n,i, f0);
    end
end
close( newVid)
end

function [fn, d] = get_fnum( vFileName )
n =  numel(vFileName);
fn = zeros(n,1);
for i=1:n
    fn(i) = str2num( vFileName{i}(4:8) );
end
d1 = diff(fn);
d = [d1(:);d1(end)];
end
