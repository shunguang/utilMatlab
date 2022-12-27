% Test EKF one step

% Sequence 25. Simple case:
% Driving fairly straight, pedestrian in the middle of the image
% Handmarked bounding boxes used, i.e. noise in image position not true
% Pedestrian true height is 1.92 meters

% Sequence 1038. More difficult case:
% A lot of turning at the end of the sequence, pedestrian to the right
% Handmarked bounding boxes used, i.e. noise in image position not true
% Pedestrian true height is 1.86 meters
clearvars;
clear all;

dataFile = './test_data/seq25_data.mat';
%dataFile = './test_data/seq1038_data.mat';

load(dataFile)

whos
states = [];

[X P] = InitializeEKFv3(measurements(1,:));

states = [states X];
for i = 2:length(measurements)
     [X P] = EKFv3_OneStep(X, P, measurements(i,:)', controlSignals(i,:)');
    states = [states X];

end

yLabs{1}='distance X';
yLabs{2}='distance Y';
yLabs{3}='velocity X';
yLabs{4}='velocity Y';
yLabs{5}='height H';
yLabs{6}= 'pitch angle';

figure(1);
for i=1:6
    subplot(3,2,i);
    plot(states(i,:));
    ylabel( yLabs{i} );
    xlabel('frame #');
end
