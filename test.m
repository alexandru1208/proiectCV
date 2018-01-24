close all;
clear all;
rgbImage = imread('beach2.jpg');
bwImage = skin2bin(rgbImage);

[w,h] = size(bwImage);
minNrPixels = round(0.001 * w * h);

bwImage = bwareaopen(bwImage,minNrPixels);

SE = strel('disk',10,8);
% bwImage = imerode(bwImage,SE);
bwImage = imdilate(bwImage,SE);

CC = bwconncomp(bwImage);

s  = regionprops(CC,'Area','BoundingBox');



areas = [s.Area];
areas = areas';
boxes = [s.BoundingBox];
boxes = vec2mat(boxes,4);
nrBoxes = size(boxes,1);

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
                minX = min(boxes(i,1),boxes(j,1));
                minY = min(boxes(i,2),boxes(j,2));
                w = boxes(i,3) - boxes(j,1) + boxes(i,1);
                w = max([w,boxes(i,3),boxes(j,3)]);
                h = boxes(i,4) - boxes(j,2) + boxes(i,2);
                h = max([h,boxes(i,4),boxes(j,4)]);
                boxes([i,j],:) = [];
                boxes = [boxes;minX,minY,w,h];
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

J = insertObjectAnnotation(rgbImage,'rectangle',boxes,boxes(:,1,1,1),'LineWidth',3, 'Color','red' ,'TextColor','black');
figure
imshow(J)



