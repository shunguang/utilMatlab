function genBayerProcess
clear all; close all;
m=30; b=2;bb=40
R = creatImg( m, b, 'R');
G = creatImg( m, b, 'G');
B = creatImg( m, b, 'B');
W = creatImg( m, b, 'W');

%bayer BGGR
I = [B G B G;
    G R G R;
    B G B G;
    G R G R];
I = addBorder(I,b);

%R-channle
Ir1 = [W W W W;
    W R W R;
    W W W W;
    W R W R];
Ir2 = [R R; R R];
Ir = combine_two(Ir1, Ir2,b, bb);

%G-channle
Ig1 = [W G W G;
    G W G W;
    W G W G;
    G W G W];
Ig2 = [G G;  G G;   G G;  G G];
Ig = combine_two(Ig1, Ig2,b, bb);


%B-channle
Ib1 = [B W B W;
    W W W W;
    B W B W;
    W W W W];
Ib2 = [B B; B B];
Ib = combine_two(Ib1, Ib2,b, bb);


Ir2 = flip(Ir,2);
Ig2 = flip(Ig,2);
Ib2 = flip(Ib,2);

figure
subplot(3, 3, 4)
imshow(I);

subplot(3, 3, 2)
imshow(Ir);

subplot(3, 3, 3)
imshow(Ir2);

subplot(3, 3, 5)
imshow(Ig);

subplot(3, 3, 6)
imshow(Ig2);

subplot(3, 3, 8)
imshow(Ib);

subplot(3, 3, 9)
imshow(Ib2);

end


function I = creatImg( m, b, flag)

I = zeros(m,m,3); %initialize
ch=3;
if flag=='R'
    ch=1;
elseif flag=='G'
    ch=2;
end
b1 = b; b2 = m-b;
I( b1:b2,b1:b2,ch)=255;

if flag=='W'
    I( b1:b2,b1:b2,1:3)=255;
end

end

function J = addBorder(I,b)
[m,n,~] =size(I);
J = zeros(m+b, n+b,3);
[m,n,~] =size(J);
J(b+1:m, b+1:n,:) = I;

end


function Ig = combine_two(Ig1, Ig2, b, bb)
Ig1 = addBorder(Ig1,b);
Ig2 = addBorder(Ig2,b);
[m1, n1, ~] =  size(Ig1);
[m2, n2, ~] = size(Ig2);
T =  255*ones(m1,n2,3);
T(1:m2,1:n2, :)= Ig2;

W0 = 255*ones(m1,bb,3);
Ig = [Ig1 W0 T];
end


