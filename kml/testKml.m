
function testKml

%-- create a circle in ENU and get its LLA
r = 1000; %meters
ang =(0:0.1:2*pi);  %1 x n
n = length(ang);
xEast = r * cos(ang);
yNorth = r * sin(ang);
enu = [xEast(:), yNorth(:), zeros(n,1)]; %n x 3
lla0 = [37.0,-77.0, 0];
lla = enu2lla( enu, lla0, "flat");%n x 3

%-- open a file to write
fid = fopen( 'c:/temp/test.kml', 'w' );
if fid == -1
    warning( 'GtTrajPool.writeToKml() - cannot open file: %s', tmpFile );
    return;
end
Kml.writeKmlHead( fid, 'a track' );

%set up parameter
headStyId = 'GtHeadSty';
headIconUrl = './objA.png';
LineColorCode = rgb2KmlColorCode(1, [1, 0, 0] );
lineStyId = 'MyLineSty';
lineName = 'myLineAbc';
lineWidth = 3;
lineVisibility = 1;

myPtStyId = 'PtSty';

Kml.writeIconStyle( fid, headStyId, headIconUrl, 0.4 );
Kml.writeLineStyle( fid, lineStyId, LineColorCode, lineWidth, lineVisibility );

%write trajectories
bExtrude = 1;
bTessellate = 1;
Kml.writeLine1( fid, lla, lineStyId, lineName, bExtrude, bTessellate );
for i=1:4:n
    Kml.writeIconPoint( fid, lla(i, :), myPtStyId, ['Point', num2str(i)], 'no-desp');
end
Kml.writeKmlTail( fid );
fclose( fid);

end


