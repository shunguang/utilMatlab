function [BW,maskedImage] = grabcur_seg()
b = imread('C:\Projects\personal\YueYiWedding\matlab\IMG_1795.JPG');
[BW,maskedImage] = seg1(b);

imshow(BW);
imshow(maskedImage);

imwrite( BW, 'C:\Projects\personal\YueYiWedding\matlab\fg.png');
imwrite( maskedImage, 'C:\Projects\personal\YueYiWedding\matlab\mask.png');
end

function [BW,maskedImage] = seg1(RGB)
%segmentImage Segment image using auto-generated code from imageSegmenter app
%  [BW,MASKEDIMAGE] = segmentImage(RGB) segments image RGB using
%  auto-generated code from the imageSegmenter app. The final segmentation
%  is returned in BW, and a masked image is returned in MASKEDIMAGE.

% Auto-generated by imageSegmenter app on 29-Aug-2021
%----------------------------------------------------


% Convert RGB image into L*a*b* color space.
X = rgb2lab(RGB);

% Graph cut
foregroundInd = [749708 749711 749714 749720 749723 749725 749728 749737 749749 754624 754629 754632 759557 764449 764475 769368 779114 783992 784001 784021 784109 784258 784340 784442 784506 784544 784556 784565 787297 787303 787420 787803 787806 787826 787844 792736 792780 797690 797725 802734 916254 1067722 1067725 1072597 1072603 1077472 1077475 1077483 1082361 1082379 1087268 1090521 1090524 1095752 1100267 1105136 1105142 1105174 1110055 1110078 1110081 1110087 1114997 1115023 1115061 1120512 1130255 1172220 1233686 1286099 1319915 1337562 1367225 1371854 1475736 1480783 1490515 1509578 1527827 1532549 1571641 1576367 1584480 1589486 1594352 1603952 1608821 1608956 1613687 1618553 1623414 1623416 1623419 1628423 1641399 1645888 1651140 1656006 1680116 1680128 1680140 1684988 1689863 1689880 1689886 1707722 1712588 1732052 1732058 1732061 1732064 1736918 1736930 1751514 ];
backgroundInd = [281675 281678 281681 286526 294616 299479 303801 304085 313974 314027 318066 ];
L = superpixels(X,8859,'IsInputLab',true);

% Convert L*a*b* range to [0 1]
scaledX = prepLab(X);
BW = lazysnapping(scaledX,L,foregroundInd,backgroundInd);

% Local graph cut
xPos = [481.2497 517.4280 517.4280 481.2497 ];
yPos = [369.4995 369.4995 465.5590 465.5590 ];
m = size(BW, 1);
n = size(BW, 2);
ROI = poly2mask(xPos,yPos,m,n);
foregroundInd = [];
backgroundInd = [];
L = superpixels(X,8859,'IsInputLab',true);

% Convert L*a*b* range to [0 1]
scaledX = prepLab(X);
BW = BW | grabcut(scaledX,L,ROI,foregroundInd,backgroundInd);

% Dilate mask with disk
radius = 3;
decomposition = 0;
se = strel('disk', radius, decomposition);
BW = imdilate(BW, se);

% Dilate mask with disk
radius = 4;
decomposition = 0;
se = strel('disk', radius, decomposition);
BW = imdilate(BW, se);

% Create masked image.
maskedImage = RGB;
maskedImage(repmat(~BW,[1 1 3])) = 0;
end

function out = prepLab(in)

% Convert L*a*b* image to range [0,1]
out = in;
out(:,:,1) = in(:,:,1) / 100;  % L range is [0 100].
out(:,:,2) = (in(:,:,2) + 86.1827) / 184.4170;  % a* range is [-86.1827,98.2343].
out(:,:,3) = (in(:,:,3) + 107.8602) / 202.3382;  % b* range is [-107.8602,94.4780].

end
