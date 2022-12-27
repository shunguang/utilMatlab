close all;
clear all;

path = 'D:/projects/MatTools/AddLogoOnVideo/Marnoj/';

Fs{1}='DYN000.AVI';
Fs{2}='IR_3inGSD.AVI'                    ;
Fs{3}='IR_6in_GSD_people.AVI'            ;
Fs{4}='ORIG000.AVI'                      ;
Fs{5}='aerial_1m_GSD.AVI'                ;
Fs{6}='final_movie2fps.avi'              ;
Fs{7}='lwir_mti.avi'                     ;
Fs{8}='pred-0018-0021-filtered-short.avi';
Fs{9}='pred-0018-0021-raw-short.avi'     ;
Fs{10}='slave_mpeg2.avi'                  ;
Fs{11}='tank.avi'    ;
Fs{12}='gstiCar_NEW.avi'                      ;
Fs{13}='helena_ex_NEW.avi'                    ;

logoImageFile = 'Sarnoff-Transparent-Logo1.GIF'; %'Sarnoff-Proprietary.gif'; 
locationFlag = 'Bottom-Left';
for i = 13:13
    inputVideoFile = [path, Fs{i}];
    %outputVideoQuality = 40;
    %add_logo_on_a_video( inputVideoFile, locationFlag, logoImageFile, outputVideoQuality );
    add_logo_on_a_video2( inputVideoFile, locationFlag, logoImageFile );
end
