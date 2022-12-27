%rgb ->bayer BGGR: approximathod
close all;
% Read in sample image.
rgbImage = imread('C:\Projects\IRAD-proposals\2021\ngv-000007-q097.jpg');
% Create mosaiced image.
[rows, columns, numberOfColorChannels] = size(rgbImage);
bayerBGGR = zeros(rows, columns, 'uint8');
for col = 1 : columns
  for row = 1 : rows
    if mod(col, 2) == 0 && mod(row, 2) == 0
      % Pick red value.
      bayerBGGR(row, col) = rgbImage(row, col, 1);
    elseif mod(col, 2) == 0 && mod(row, 2) == 1
      % Pick green value.
      bayerBGGR(row, col) = rgbImage(row, col, 2);
    elseif mod(col, 2) == 1 && mod(row, 2) == 0
      % Pick green value.
      bayerBGGR(row, col) = rgbImage(row, col, 2);
    elseif mod(col, 2) == 1 && mod(row, 2) == 1
      % Pick blue value.
      bayerBGGR(row, col) = rgbImage(row, col, 3);
    end
  end
end
imwrite(bayerBGGR, 'YPG_bayer_bggr_w7936_x_h6016.png')

J = demosaic(bayerBGGR,'bggr');

% Display the image.
subplot(2,2,1);
imshow(rgbImage);
title('Original RGB image', 'FontSize', 20);

subplot(2,2,2);
imshow(bayerBGGR);
title('Bayer BGGR', 'FontSize', 20);


subplot(2,2,3);
imshow(J);
title('demosaiced image', 'FontSize', 20);

