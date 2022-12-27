close all;
clear all;

path = 'D:/projects/MatTools/AddLogoOnVideo/Jyan0619/';

files{1} = '060131.avi';
files{2} = 'Bldg2VisOdo.avi';
files{3} = 'PSqVisOdo.avi';    
files{4} = '060214.avi';
files{5} = 'TRCPK.AVI';        
files{6} = 'A_LORES_NEW.AVI';
files{7} = 'C_LORES_NEW.AVI';
files{8} = 'F_LORES_NEW.AVI';      

logoImageFile = 'Sarnoff-Transparent-Logo1.GIF'; 
locationFlag = 'Top-Right';
for i = 2:3
    inputVideoFile = [path, files{i}];
    %outputVideoQuality = 40;
    %add_logo_on_a_video( inputVideoFile, locationFlag, logoImageFile, outputVideoQuality );
    add_logo_on_a_video2( inputVideoFile, locationFlag, logoImageFile );
end
