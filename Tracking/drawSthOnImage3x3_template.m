function drawSthOnImage
clear all, close all;
%I = imread('tank.jpg');
I1 = imread('TankFinal.bmp');
I = imresize(I1,0.70,'bilinear') ;
size(I)
Npts = 4 ;
%whos

fileNames{1} = 'simulationResults\IMT500_S1_w_cons.mat' ;
fileNames{2} = 'simulationResults\IMT500_S1_wo_cons.mat' ;
fileNames{3} = 'simulationResults\PDA_S1_wo_cons.mat' ;
fileNames{4} = 'simulationResults\IMT500_S4_w_cons.mat' ;
fileNames{5} = 'simulationResults\IMT500_S4_wo_cons.mat' ;
fileNames{6} = 'simulationResults\PDA_S4_wo_cons.mat' ;


original = [426,273] ;
%original = [312,262] ;
kx = 848/44;   % the scale from the simulation data to the image cordinate system
ky = 400/20 ;

myaxis = [-50,1000,-80,620];
figure(1);
for j=1:9
    %
    %=============  prepare data =============
    %
    if j==1 % draw the true vetexes
        x0 = [ 25 -19 -19 25 20]';
        y0 = [ 10 10 -10 -10 5 ]';
        x = original(1) + kx * x0;
        y = original(2) + ky * y0;
    elseif j==2 % draw the legend
        dy = 6 ;
        Lx0 = [ -20 -8 4]';  
        Ly0(:,1) = [ -10, -10, -10]' ;
        for i=2:Npts
            Ly0(:,i) = Ly0(:,1)+ (i-1)*dy ;
        end
        Lx = original(1) + kx * Lx0
        Ly = original(2) + ky * Ly0
    elseif j>2
        
        [x0,y0, Theta ] = snapshot(fileNames{j-2}, Npts ) 
        x = original(1) + kx * x0;
        y = original(2) + ky * y0;
        
        % normalized data, make sure inside the window
        for k1=1:5
            for k2=1:Npts 
                if x(k1,k2) < myaxis(1)
                    x(k1,k2) = myaxis(1);
                elseif x(k1,k2) > myaxis(2)
                    x(k1,k2) = myaxis(2);
                end
                
                if y(k1,k2) < myaxis(3)
                    y(k1,k2) = myaxis(3);
                elseif y(k1,k2) > myaxis(4)
                    y(k1,k2) = myaxis(4);
                end
            end
        end
    end
    
    %
    %=============  plot =============
    %
    switch j
        case 1
            subplot(331);
            xlabel('(a)');
             text( (myaxis(1)+myaxis(2))/2, myaxis(3)-50, '(a)');
        case 2
            subplot(332);
            axis off ;
        case 3
            subplot(334);
             text( (myaxis(1)+myaxis(2))/2, myaxis(3)-50, '(b)');
%            xlabel('(b)');
        case 4
            subplot(335);
             text( (myaxis(1)+myaxis(2))/2, myaxis(3)-50, '(c)');
%            xlabel('(c)');
        case 5
            subplot(336);
             text( (myaxis(1)+myaxis(2))/2, myaxis(3)-50, '(d)');
 %           xlabel('(d)');
        case 6
            subplot(337);
             text( (myaxis(1)+myaxis(2))/2, myaxis(3)-50, '(e)');
%            xlabel('(e)');
        case 7
            subplot(338);
            text( (myaxis(1)+myaxis(2))/2, myaxis(3)-50, '(f)');
%            xlabel('(f)');
        case 8
            subplot(339);
             text( (myaxis(1)+myaxis(2))/2, myaxis(3)-50, '(g)');
%            xlabel('(g)');
     end
       
    hold on ; 
    if j==1
            imshow(I);
            for i=1:5  % loop for the five vertexes
                h(1) = original(1) ;    h(2) =   x(i, 1);
                v(1) = original(2) ;    v(2) =   y(i, 1);
                plot(h,v, 'ro-')
            end
    elseif j==2
            plot(Lx, Ly(:,1), 'ro-');   
            text(Lx(3,1)+50, Ly(3,1), 'k=1000') ;    
            plot(Lx, Ly(:,2), 'rd-');        
            text(Lx(3,1)+50, Ly(3,2), 'k=3000') ;    
            plot(Lx, Ly(:,3), 'rx-');        
            text(Lx(3,1)+50, Ly(3,3), 'k=5000') ;    
            plot(Lx, Ly(:,4), 'rs-');        
            text(Lx(3,1)+50, Ly(3,4), 'k=7000') ;    
    elseif j>2
        imshow(I);
        for nSnapshot=1:Npts  % loop for different instances
            for i=1:5  % loop for the five vertexes
                h(1) = original(1) ;    h(2) =   x(i, nSnapshot);
                v(1) = original(2) ;    v(2) =   y(i, nSnapshot);
                switch nSnapshot
                    case 1
                        plot(h,v, 'ro-')
                    case 2
                        plot(h,v, 'rd-')
                    case 3
                        plot(h,v, 'rx-')
                    case 4
                        plot(h,v, 'rs-')
                end                
            end
        end
    end
    axis( myaxis );
    hold off
end
return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function get the x and y positions of each vertex at diffrent time
% Npts:  the # of instances wanted
% x:      5 x Npts, x position for each vertex
% y:      5 x Npts, y position for each vertex
% Theta:  1 x Npts, the target global angle  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x,y, Theta ] = snapshot( Datafile, Npts )

load(Datafile, 'x_estimate') ;


T = 0.025; % sampling intervals
Theta0 = 0*pi/180;  %Target center initial angle, relative the (xt0,yt0) 
Omega  = 0.03;      %target center moving-rotation angle velocity
k = [1000, 3000, 5000, 7000] ;

r     = zeros(5, Npts) ;
theta = zeros(5, Npts) ;

for i=1:Npts
   curTime = (k(i)-1) * T ; 
   Theta(i) = Theta0 + Omega*curTime ;   % current center moving angle
   
   r(1:5,i) = x_estimate(7:11, k(i)) ;   %read the radus
   theta(1:5,i) = x_estimate(12:16, k(i)) - Theta(i) - pi/2 ; %read the angle
end

%r ;
%theta

x = r .* cos(theta) ;
y = r .* sin(theta) ;

return
