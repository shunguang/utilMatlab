function add_logo_on_a_video2( inputVideoFile, locationFlag, logoImageFile )
%----------------------------------------------------------------------
% Exmples of usages
%   1. add_logo_on_a_video( 'myVideo.AVI')
%   The sarnoff logo ('Sarnoff-Transparent-Logo1.GIF') will be added
%   on the Top-Right corners of the video frames. Five kind of output video 
%   files will be generated with differnt qualities.
%
%   2. add_logo_on_a_video( 'myVideo.AVI', 'Top-Right')
%   The sarnoff logo ('Sarnoff-Transparent-Logo1.GIF') will be added on
%   the video frames. The location of the logo can be appeared on
%   'Top-Left', 'Top-Right', 'Bottom-Left', and 'Bottom-Right'.
%   Also, five kind of output video files will be generated with differnt qualities.
%
%   3. add_logo_on_a_video( 'myVideo.AVI', 'Top-Right', 'logo.GIF')
%   A logo image named 'logo.GIF' will be added on a video named
%   'myVideo.AVI' in particular location, and five kind of output video files
%    will be generated with differnt qualities.
%----------------------------------------------------------------------
% Author:      Shunguang Wu
% Email:       swu@sarnoff.com
% Shop Number: 33948.100
% Date:        05/16/06, 06/20/06
%
% Copyright  (C)  Sarnoff Corporation, 2006.
% Sarnoff is a registered trademark of Sarnoff Corporation.
%
% This document discloses proprietary and confidential information
% of Sarnoff Corporation and may not be used, released, or disclosed
% in whole or in part for any purpose other then its intended use,
% or to any party other than the authorized recipient.
%----------------------------------------------------------------------
warning off all

if nargin < 2
    locationFlag = 'Top-Left';
    logoImageFile = 'Sarnoff-Transparent-Logo1.GIF';
elseif nargin < 3
    logoImageFile = 'Sarnoff-Transparent-Logo1.GIF';
end


outputVideoFile1 = [inputVideoFile(1:length(inputVideoFile)-4),'_with_logo_q20.avi'];
outputVideoFile2 = [inputVideoFile(1:length(inputVideoFile)-4),'_with_logo_q40.avi'];
outputVideoFile3 = [inputVideoFile(1:length(inputVideoFile)-4),'_with_logo_q60.avi'];
outputVideoFile4 = [inputVideoFile(1:length(inputVideoFile)-4),'_with_logo_q80.avi'];
outputVideoFile5 = [inputVideoFile(1:length(inputVideoFile)-4),'_with_logo_q100.avi'];

fprintf('The output video file name is: %s\n', outputVideoFile1);
fprintf('The output video file name is: %s\n', outputVideoFile2);
fprintf('The output video file name is: %s\n', outputVideoFile3);
fprintf('The output video file name is: %s\n', outputVideoFile4);
fprintf('The output video file name is: %s\n', outputVideoFile5);
fprintf('I am running, please wait ...\n');

%------------------------------------------------
%read logo image
%------------------------------------------------
logoInfo = imfinfo(logoImageFile);
if logoInfo.ColorType == 'indexed'
    [logoImg, map] = imread(logoImageFile );
    logoImgRGB = ind2rgb(logoImg, map);
else
    logoImgRGB = imread( logoImageFile );
end
%normalize to [0,255]
for i=1:3
    logMax = max( max( logoImgRGB(:,:,i) ) );
    logoImgRGB(:,:,i) = floor(255/logMax * logoImgRGB(:,:,i));
end
logoImgRGB = remove_background( logoImgRGB );
%figure
%imshow(logoImgRGB)

%------------------------------------------------
%get input video information
%------------------------------------------------
inputVideoInfo = aviinfo(inputVideoFile);

outputMov1 = avifile(outputVideoFile1, 'fps', inputVideoInfo.FramesPerSecond, 'quality', 20 );
outputMov2 = avifile(outputVideoFile2, 'fps', inputVideoInfo.FramesPerSecond, 'quality', 40 );
outputMov3 = avifile(outputVideoFile3, 'fps', inputVideoInfo.FramesPerSecond, 'quality', 60 );
outputMov4 = avifile(outputVideoFile4, 'fps', inputVideoInfo.FramesPerSecond, 'quality', 80 );
outputMov5 = avifile(outputVideoFile5, 'fps', inputVideoInfo.FramesPerSecond, 'quality', 100 );

blockSize = 100;
nBlocks = ceil ( inputVideoInfo.NumFrames/blockSize );
fprintf( 'total # of frames: %d, image width=%d, image height=%d\n', inputVideoInfo.NumFrames, inputVideoInfo.Width, inputVideoInfo.Height );
fprintf( 'Current procesed frame numbers are: ' );

for iBlock = 1:nBlocks
    n1 = (iBlock-1)*blockSize + 1;
    n2 = n1 + blockSize - 1;
    if n2 > inputVideoInfo.NumFrames
        n2 = inputVideoInfo.NumFrames;
    end
    endId = n2-n1+1;

    frameIds = [n1:n2];
    curBlock = aviread(inputVideoFile, frameIds);
    
    fprintf( '[%d, %d], ', n1, n2 );
    for i=1:endId
        curFrame = curBlock(i);
        %creat a image with logo inside the original image
        if inputVideoInfo.ImageType == 'truecolor'
            curImgRGB = frame2im ( curFrame );
        else  %indexed
            curFrame
            curFrame.cdata = uint8(curFrame.cdata);
            if isempty( curFrame.colormap )
               fprintf('\n Error: the color map of the input video is empty!!! \n');
               return; 
            end
                
            [curImgIndex, map] = frame2im ( curFrame );
            curImgRGB = ind2rgb(curImgIndex, map);
        end

        curImgWithLogo = add_logo(logoImgRGB, curImgRGB, locationFlag);
        curFrameWithLogo = im2frame( curImgWithLogo );

        %     figure(1);
        %     imshow( curImgWithLogo ); hold on;
        %     imshow( logoImgRGB ); hold on;
        outputMov1 = addframe(outputMov1, curFrameWithLogo);
        outputMov2 = addframe(outputMov2, curFrameWithLogo);
        outputMov3 = addframe(outputMov3, curFrameWithLogo);
        outputMov4 = addframe(outputMov4, curFrameWithLogo);
        outputMov5 = addframe(outputMov5, curFrameWithLogo);
    end
end
outputMov1 = close( outputMov1 );
outputMov2 = close( outputMov2 );
outputMov3 = close( outputMov3 );
outputMov4 = close( outputMov4 );
outputMov5 = close( outputMov5 );
fprintf('* Job well done! *\n');
%eof

%--------------------------------------------------------
%--------------------------------------------------------
function xRGB = add_logo(logoRGB, xRGB, flag)
[hLogo, wLogo, n] = size(logoRGB);
[hImg, wImg, n] = size(xRGB);
switch flag
    case 'Top-Left'
        r1 = 1;
        c1 = 1;
    case 'Top-Right'
        r1 = 1;
        c1 = wImg - wLogo;
    case 'Bottom-Left'
        r1 = hImg - hLogo;
        c1 = 1;
    case 'Bottom-Right'
        r1 = hImg - hLogo;
        c1 = wImg - wLogo;
    otherwise
        r1 = 1;
        c1 = 1;
end
r2 = r1 + hLogo - 1;
c2 = c1 + wLogo - 1;

for i = 1:hLogo
    for j = 1:wLogo
        if logoRGB(i, j, 1) > -1  %only the foreground is used to overlay
            xRGB( r1+i-1, c1+j-1, : ) = logoRGB(i, j, :);
        end
    end
end
%xRGB( r1:r2, c1:c2, 2 ) = logoRGB(:, :, 2);
%xRGB( r1:r2, c1:c2, 3 ) = logoRGB(:, :, 3);

%--------------------------------------------------------
%--------------------------------------------------------
function logoImgRGB = remove_background( logoImgRGB )
%assume the white is the backround
[h,w,n] = size( logoImgRGB );
for i=1:h
    for j=1:w
        if ( logoImgRGB(i,j,1) == logoImgRGB(i,j,2) &  ...
                logoImgRGB(i,j,1) == logoImgRGB(i,j,3) )

            logoImgRGB(i,j,1) = -1;  %marked as background
        end
    end
end


