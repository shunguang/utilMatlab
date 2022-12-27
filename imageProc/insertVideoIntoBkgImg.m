function insertVideoIntoABkgImg
close all

rawVideoRate=1920/1080;
w0=1280; h0=720;
pvInput  = 'C:\Projects\personal\YueYiWedding\SlideVideo';
pSlide   = 'C:\Projects\personal\YueYiWedding\SlidePPT-w16-h9';
%pvOutput = 'C:\Projects\personal\YueYiWedding\SlideVideoOutput';
pvOutput = 'F:\swu\homeVideos\YueYiWedding';


w = [370, 465,390,390,390,w0,w0];
h = int32(w/rawVideoRate);

for localbrightenAmount=0.1:0.1:0.2
    %pvOutput = ['F:\swu\homeVideos\YueYiWedding\localbrighten',num2str(localbrightenAmount)];
    pvOutput = ['C:\Projects\personal\YueYiWedding\SlideVideoOutput\localbrighten',num2str(localbrightenAmount)];
    suc = mkdir(pvOutput);
    if ~suc
        break;
    end
    
    for idx=2:2
        vfIn = fullfile(pvInput, ['slide',num2str(idx), '.mp4']);
        isAvi = 1;
        if isAvi
            bkgFile = fullfile(pSlide, ['slide',num2str(idx), '.png']);
            outVideoFile = fullfile(pvOutput, ['slide',num2str(idx), '_out.avi']);
        else
            outVideoFile = fullfile(pvOutput, ['slide',num2str(idx), '_out.mp4']);
        end
        
        [audioY,audioFs] = audioread(vfIn);
        [nTotAudioSmps, nCh] = size(audioY);
        
        I0 = imread(bkgFile);
        vRead = VideoReader( vfIn);
        
        if idx<6
            if idx~=2
                roi.x0 = w0-w(idx);
                roi.y0 = 1;
            else
                roi.x0 = 1;
                roi.y0 = h0-h(idx)-1;
            end
        else
            roi.x0 = 1;
            roi.y0 = 1;
        end
        
        roi.w = w(idx);
        roi.h = h(idx);
        roi.x1= roi.x0 + roi.w-1;
        roi.y1= roi.y0 + roi.h-1;
        
        audioSmpsPerVideoFrm = floor(audioFs/vRead.FrameRate);
        nTotVideoFrms = int32(vRead.Duration * vRead.FrameRate);
        nTotAudioFrms = int32(nTotAudioSmps/audioSmpsPerVideoFrm);
        
        outVideoFPS= vRead.FrameRate; %35;
        if isAvi
            vWrt = vision.VideoFileWriter('Filename',outVideoFile, 'FileFormat', 'AVI', 'AudioInputPort',true, 'FrameRate', outVideoFPS );
        else
            vWrt = vision.VideoFileWriter('Filename',outVideoFile, 'FileFormat', 'MPEG4', 'AudioInputPort',true, 'FrameRate', outVideoFPS, 'Quality', 90 );
        end
        
        vFrm = I0;
        fn=0;
        
        aBeg = 1;
        borderW=150;
        while hasFrame(vRead)
            frm0 = readFrame(vRead);
            [vh0,vw0,~]=size(frm0);
            frm01 = frm0(1:vh0, borderW:(vw0-borderW),:);
            frm1 = imresize(frm01, [roi.h, roi.w]);
            if localbrightenAmount>0.01
                frm1 = imlocalbrighten(frm1, localbrightenAmount);
            end
            
            vFrm(roi.y0 : roi.y1, roi.x0 : roi.x1, :) =  frm1;
            aEnd = aBeg + audioSmpsPerVideoFrm -1;
            if aEnd<=nTotAudioSmps
                aFrm =  audioY(aBeg:aEnd,:);
            else
                n = audioSmpsPerVideoFrm - (nTotAudioSmps-aBeg+1);
                aFrm =  [audioY(aBeg:end,:); zeros(n,2)];
            end
            vWrt(vFrm, aFrm);
            %step(vWrt, vFrm, aFrm);
            
            %--------------
            aBeg =  aEnd + 1;
            fn = fn+1;
            if mod(fn, 200)==0
                fprintf( 'fn=%d/%d\n', fn, nTotVideoFrms );
            end
        end
        release(vWrt);
    end
end
end

