close all;
clear all;
rgbImage = imread('beach2.jpg');
bwImage = skin2bin(rgbImage);
figure
imshow(bwImage);

[w,h] = size(bwImage);
minNrPixels = round(0.001 * w * h);

image = bwareaopen(bwImage,minNrPixels);

SE = strel('disk',10,8);
% image = imerode(image,SE);
image = imdilate(image,SE);

CC = bwconncomp(image);

s  = regionprops(CC,'Area','BoundingBox');

areas = [s.Area];
areas = areas';
boxes = [s.BoundingBox];
boxes = vec2mat(boxes,4);

I = insertObjectAnnotation(rgbImage,'rectangle',boxes,areas,'LineWidth',3, 'Color','red' ,'TextColor','black');

figure
imshow(I);

% TODO: facut intersectia dreptunghiurilor ca sa obtinem compnenete cat mai
% mari

