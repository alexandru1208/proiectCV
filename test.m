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

J = insertObjectAnnotation(rgbImage,'rectangle',boxes,boxes(:,1,1,1),'LineWidth',3, 'Color','red' ,'TextColor','black');
figure
imshow(J)

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
                x1 = boxes(i,1);
                x2 = boxes(j,1);
                y1 = boxes(i,2);
                y2 = boxes(j,2);
                w1 = boxes(i,3);
                w2 = boxes(j,3);
                h1 = boxes(i,4);
                h2 = boxes(j,4);
                
                minX = min([x1,x1+w1,x2,x2+w2]);
                minY = min([y1,y1+h1,y2,y2+h2]);
                maxX = max([x1,x1+w1,x2,x2+w2]);
                maxY = max([y1,y1+h1,y2,y2+h2]);
                
                boxes([i,j],:) = [];
                boxes = [boxes;[minX,minY,maxX-minX,maxY-minY]];
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



