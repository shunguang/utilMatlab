function GenBkg
close all

%makeBkg();

inFile1 = 'C:\Projects\personal\YueYiWedding\matlab\pptbkg-16to9_raw.png';
inFile2 = 'C:\Projects\personal\YueYiWedding\matlab\pptbkg-4to3_raw.png';

outFile1 = 'C:\Projects\personal\YueYiWedding\matlab\pptbkg-final-16to9.png';
outFile2 = 'C:\Projects\personal\YueYiWedding\matlab\pptbkg-final-4to3.png';

overlay(inFile1, outFile1, 0.6);
%overlay(inFile2, outFile2, 0.4);

end


function makeBkg
I1=imread('C:\Projects\personal\YueYiWedding\matlab\pptbkg0.png');
I2 = [I1, fliplr(I1)];
[h,w,c]=size(I2);

w1 = w; h1= int32(w*(9/16));
J1 = I2(1:(h1-1), 1:(w1-1),:);

h2=h;  w2 = int32(h2*(4/3));
i1 = (w-w2)/2; i2=i1+w2-1;
J2 = I2(1:(h2-1), i1:i2,:);

Iout1=imresize(J1, [1080,1920]);  %w:h=16:9
Iout2=imresize(J2, [864,1152]);   %w:h=4:3

inFile1 = 'C:\Projects\personal\YueYiWedding\matlab\pptbkg-16to9_raw.png';
inFile2 = 'C:\Projects\personal\YueYiWedding\matlab\pptbkg-4to3_raw.png';
imwrite(Iout1, inFile1);
imwrite(Iout2, inFile2);



end


function overlay(bkgRawPngFile, outFile, rate)
I1=imread('C:\Projects\personal\YueYiWedding\matlab\final2.png');
I1=imresize(I1, rate);
[m1,n1,~]=size(I1);

Iout = imread(bkgRawPngFile);
[m0,n0,~]=size(Iout);

x0=n0-n1-10; y0=m0-m1-5;
j=1;
for y=y0:m0
    if j>m1
        break;
    end
    i=1;
    for x=x0:n0
        %fprintf('%d,%d\n',j, i);
        if i>n1
            break;
        end
        if I1(j,i,1)>0
            Iout(y,x,:)=I1(j,i,:);
        end
        i=i+1;
    end
    j=j+1;
end
figure
imshow(Iout)
imwrite(Iout, outFile );
disp('done');
end
