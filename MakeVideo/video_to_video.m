function video_to_video( inputVideoFile, outputVideoQuality )
%----------------------------------------------------------------------
% Exmples of usages
%   1. add_logo_on_a_video( 'myVideo.AVI')
%   The sarnoff logo ('Sarnoff-Transparent-Logo1.GIF') will be added
%   on the Top-Right corners of the video frames, the video file name is
%   'myVideo.avi',  and the heighest quality (100) will be used for the output
%   video.
%
%   2. add_logo_on_a_video( 'myVideo.AVI', 'Top-Right')
%   The sarnoff logo ('Sarnoff-Transparent-Logo1.GIF') will be added on
%   the video frames with the highest output video quality. 
%   The location of the logo can be appeared on
%   'Top-Left', 'Top-Right', 'Bottom-Left', and 'Bottom-Right'.
%
%   3. add_logo_on_a_video( 'myVideo.AVI', 'Top-Right', 'logo.GIF')
%   A logo image named 'logo.GIF' will be added on a video named
%   'myVideo.AVI' in particular location, and out put video is generated by
%   the heighest quality.
%
%   4. add_logo_on_a_video( 'myVideo.AVI', 'Top-Right', 'Sarnoff-Transparent-Logo1.GIF', 85)
%   a logo image named 'Sarnoff-Transparent-Logo1.GIF' will be added on the
%   video 'myVideo.AVI' in particular place, and output video quality is 
%   85 (you can choose any number between 1 and 100 to make a balance between 
%   the video quality and its file size)

%----------------------------------------------------------------------
% Author:      Shunguang Wu 
% Email:       swu@sarnoff.com
% Shop Number: 33948.100
% Date:        05/16/06
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
   outputVideoQuality = 100;
end
    
if outputVideoQuality > 100
   outputVideoQuality = 100;
elseif outputVideoQuality < 1
       outputVideoQuality = 1;
end

outputVideoFile = [inputVideoFile(1:length(inputVideoFile)-4),'_tmp.avi'];

fprintf('The output video file name is: %s\n', outputVideoFile);
fprintf('I am running, please wait ...');

%------------------------------------------------
%get input video information
%------------------------------------------------
inputVideoInfo = aviinfo(inputVideoFile);
inputMov = aviread(inputVideoFile);
W = inputVideoInfo.Width;
H = inputVideoInfo.Height;


outputMov = avifile(outputVideoFile, 'fps', inputVideoInfo.FramesPerSecond, 'quality', outputVideoQuality );

for i=1:inputVideoInfo.NumFrames
     %creat a image with logo inside the original image
     curFrame = inputMov(i);
     outputMov = addframe(outputMov, curFrame);      
     
     %pause
      
     %figure(1) 
     %hold off;
end
outputMov = close( outputMov );
fprintf('\n*----------------*\n');
fprintf('* Job well done! *\n');
fprintf('*----------------*\n');
%eof

