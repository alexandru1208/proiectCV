clc
close all;
clear all;
rgbImage = imread('positive2.jpg');
bwImage = skin2bin(rgbImage);

figure
imshow(bwImage)

[w,h] = size(bwImage);
nrPixels = w*h;

% remove connected componnets smaller than 0.1% of image size which might
% be noise
minNrPixels = round(0.001 * nrPixels);
bwImage = bwareaopen(bwImage,minNrPixels);
% compute the total area of supposed skin pixels found

figure
imshow(bwImage)

%dilate the skin area found to join nearby connected components
diskRadius = round(0.00001*nrPixels);
SE = strel('disk',diskRadius);
dilatedBWImage = imdilate(bwImage,SE);

figure
imshow(dilatedBWImage)

% compute connected components and get areas and bounding boxes of
% components
CC = bwconncomp(dilatedBWImage);
s  = regionprops(CC,'Area','BoundingBox');

areas = [s.Area];
boxes = [s.BoundingBox];
boxes = vec2mat(boxes,4);
nrBoxes = size(boxes,1);

J = insertObjectAnnotation(rgbImage,'rectangle',boxes,areas,'LineWidth',4, 'Color','red' ,'TextColor','black');
figure
imshow(J)

% join overlapped bounding boxes to obtain big sections containing human
% skin

done = 0;
if nrBoxes == 1
    done = 1;
end

while done == 0
    done = 1;
    for i=1 : nrBoxes
        for j=i+1 : nrBoxes
            overlapRatio = bboxOverlapRatio(boxes(i,:),boxes(j,:));
            if (overlapRatio ~= 0)
                fusedBox = joinBoxes([boxes(i,:);boxes(j,:)]);
                boxes([i,j],:) = [];
                boxes = [boxes;fusedBox];
                done = 0;
                break
            end
        end
        if (done == 0)
            break
        end
    end
    if size(boxes,1) == nrBoxes || size(boxes,1) == 1
        done = 1;
    end
    nrBoxes = size(boxes,1);
end


% compute the percentage of skin pixels in each box: %SkinInBox
percentageOfComponenets = zeros(1,nrBoxes);
for i = 1 : nrBoxes
    area = bwarea(imcrop(bwImage,boxes(i,:)));
    percentageOfComponenets(i) = area/(boxes(i,3)*boxes(i,4));
end

% decide for each box if it contains a naked person
labels = zeros(1,nrBoxes);
for i = 1 : nrBoxes
    facesBoxes = getFaces(imcrop(rgbImage,boxes(i,:)));
    if isempty(facesBoxes)
        if percentageOfComponenets(i) <= 0.3
            if (boxes(i,3)*boxes(i,4))/nrPixels > 0.1
                labels(i) = 1;
            else
                labels(i) = -1;
            end
        else
            if (boxes(i,3)*boxes(i,4))/nrPixels <= 0.1 % %boxInImage
                labels(i) = -1;
            else
                labels(i) = 1;
            end
        end
    else
        faceBox = joinBoxes(facesBoxes);
        faceBox(1) = faceBox(1) + boxes(i,1);
        faceBox(2) = faceBox(2) + boxes(i,2);
        
        if bwarea(imcrop(bwImage,faceBox))/bwarea(imcrop(bwImage,boxes(i,:))) > 0.3 % %faceSkinInSkinBox
            labels(i) = -1';
        else
            labels(i) = 1;
        end
    end
end


figure
imshow(rgbImage)
hold on

for i = 1 : size(labels,2)
    x = [boxes(i,1),boxes(i,1)+boxes(i,3),boxes(i,1)+boxes(i,3),boxes(i,1)];
    y = [boxes(i,2)+boxes(i,4),boxes(i,2)+boxes(i,4),boxes(i,2),boxes(i,2)];
    if labels(i) == 1
        patch(x,y,'red','FaceAlpha', 0.3)
        hold on
    else
        patch(x,y,'green','FaceAlpha', 0.3)
        hold on
    end
end

hold off

% J = insertObjectAnnotation(rgbImage,'rectangle',boxes,labels,'LineWidth',3, 'Color','red' ,'TextColor','black','TextSize',15);
% figure
% imshow(J)



