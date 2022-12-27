function [Xnew Pnew] = EKFv3_OneStep(X, P, z, u)
% z = [xFeet, yFeet, xHead, yHead, H]'
% u = [speed, yawRate, pitchRate]'
% X = [X(dist long) Y(dist vert) vX vY H pitch]

% EKF paramters
R = diag([5, 5, 5, 5, 0.1225]);
Q = diag([3.0864e-007, 3.0864e-007, 0.00083333, 0.00083333, 0.0001, 0.01]);
% cross terms for velocity
Q(3,1) = 1.3889e-005;
Q(1,3) = 1.3889e-005;
Q(4,2) = 1.3889e-005;
Q(2,4) = 1.3889e-005;

% parameters:
cameraHeight = 0.65;
fpy = 505.0273;
fpx = 498.5847;
imgHeight = 256;
imgWidth = 324;
Ts = 1/30;

% Initialize states 
xFeet = z(1);
yFeet = z(2);
xHead = z(3);
yHead = z(4);
H = z(5);

% ******************** Calculate A and B matrix ***********************
alpha = u(2) * Ts;

B = [-Ts*cos(alpha)    0   0; ...
    Ts*sin(alpha)       0   0; ...
    0                   0   0; ...
    0                   0   0; ...
    0                   0   0; ...
    0                   0   1];

A = [cos(alpha)     sin(alpha)      cos(alpha)*Ts   sin(alpha)*Ts      0       0; ...
    -sin(alpha)     cos(alpha)      -sin(alpha)*Ts  cos(alpha)*Ts      0       0; ...
    0               0               cos(alpha)      sin(alpha)         0       0; ...
    0               0               -sin(alpha)     cos(alpha)         0       0; ...
    0               0               0               0                  1       0; ...
    0               0               0               0                  0       1];


% ******************** Predict ******************************************
Xhat = A * X + B * u;
Phat = A * P * A' + Q;

% Object state X
Xp          = Xhat(1) ;
Yp          = Xhat(2) ;
H           = Xhat(5) ;
pitchAngle  = Xhat(6) ;

% ********************* Calculate Jacobian ******************************* 
% Intermediate values
Zfeet = cameraHeight;
Zhead = (cameraHeight - H);
denFeet = Xp * cos(pitchAngle) - Zfeet * sin(pitchAngle);
nomFeet  = -fpy * Zfeet;
denHead = Xp*cos(pitchAngle) - Zhead * sin(pitchAngle);
nomHead = -fpy * Zhead;

% Matrix element values
dH1dX     = -fpx * Yp * cos(pitchAngle) / denFeet^2;
dH1dY     = fpx / denFeet;
dH1dTheta = fpx * Yp * (Xp * sin(pitchAngle) + Zfeet * cos(pitchAngle)) / denFeet^2;

dH2dX     = nomFeet / denFeet^2;
dH2dTheta = fpy * (1 + (Xp * sin(pitchAngle) + Zfeet * cos(pitchAngle)) / denFeet^2);

dH3dX     = -fpx * Yp * cos(pitchAngle) / denHead^2;
dH3dY     = fpx / denHead;
dH3dH     = -fpx * Yp * sin(pitchAngle) / denHead^2;
dH3dTheta = fpx * Yp * (Xp * sin(pitchAngle) + Zhead * cos(pitchAngle)) / denHead^2;

dH4dX     = nomHead / denHead^2;
dH4dH     = -fpy * Xp / denHead^2;
dH4dTheta = fpy * (1 + (Xp * sin(pitchAngle) + Zhead * cos(pitchAngle)) / denHead^2);

% Fill matrix
Hk = [dH1dX, dH1dY,  0,  0,      0,  dH1dTheta; ...
    dH2dX,     0,  0,  0,      0,  dH2dTheta; ...
    dH3dX, dH3dY,  0,  0,  dH3dH,  dH3dTheta; ...
    dH4dX,     0,  0,  0,  dH4dH,  dH4dTheta; ...
    0,     0,  0,  0,      1,          0];

% ********************* Predict measurement *******************************
denominator = Xp*cos(pitchAngle) - cameraHeight*sin(pitchAngle);

hk(1,1) = imgWidth/2 + fpx * Yp/denominator ;

hk(2,1) = imgHeight/2 + (fpy * (Xp * sin(pitchAngle) + cameraHeight * cos(pitchAngle))) / denominator ;

hk(3,1) = imgWidth/2 + fpx * Yp / (Xp * cos(pitchAngle) - (-H + cameraHeight) * sin(pitchAngle)) ;

hk(4,1) = imgHeight/2 + (fpy * (Xp * sin(pitchAngle) + (-H + cameraHeight) * cos(pitchAngle))) / ...
    (Xp * cos(pitchAngle) - (-H + cameraHeight) * sin(pitchAngle));

hk(5,1) = H ;

% ********************* Update EKF *******************************
I = eye(size(Hk,2));

%Kalman gain:
K = Phat * Hk' * inv(Hk * Phat * Hk' + R);

%Measurement (estimate) update:
Xnew = Xhat + K * (z-hk);

%Update error covariance matrix P
Pnew = (I - K * Hk) * Phat;
Pnew = 0.5 * ( Pnew + Pnew' );
