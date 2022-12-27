function [X0 P0] = InitializeEKFv3(z)

% parameters:
h = 0.65;
fpy = 505.0273;
fpx = 498.5847;
imgHeight = 256;
imgWidth = 324;

% Initialize states
xFeet = z(1);
yFeet = z(2);
xHead = z(3);
yHead = z(4);
H = z(5);

pixelHeight = yFeet - yHead;

% Use fake pitch with fixed height to initialize world position
hi = imgHeight/2;
distance = fpy * H / pixelHeight;
horizon = (distance * (yFeet-hi) - h * fpy) / ((yFeet-hi) * h / fpy - distance);
pitchAngle = atan(-horizon / fpy);

Xp = distance;
Yp = Xp * (xFeet - imgWidth/2 ) / fpx;

% Initialize states, X0
X0 = [Xp; ...
    Yp ;
    0;                  % Initial vx = 0
    0;                  % Initial vy = 0
    H ;
    pitchAngle] ;

% Initialize error covariance, P0
P0 = zeros(6,6);

% calculate P0 for position
zIx = xFeet - imgWidth/2;
zIy = yFeet  - imgHeight/2;
nom = h * fpy;
denom = -fpy* sin(pitchAngle) + cos(pitchAngle)* zIy;

dXdx = 0;
dXdy = -nom / denom^2;

dYdx = (nom / denom) / fpx;
dYdy = (zIx * cos(pitchAngle) / fpx) * dXdy;

Gk = [dXdx  dXdy; ...
      dYdx  dYdy];

R = [5 0; 0 5];        % R matrix for states: xFeet yFeet
PixelError  = R(1:2,1:2);
P0(1:2,1:2) = Gk * PixelError * Gk';
P0(3,3)     = 25;      % P0 vx
P0(4,4)     = 25;      % P0 vy
P0(5,5)     = 0.4;     % P0 height
P0(6,6)     = 0.1;     % P0 pitch angle

