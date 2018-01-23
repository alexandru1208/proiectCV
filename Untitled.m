peopleDetector = vision.PeopleDetector;
I = imread('visionteam1.jpg');
[bboxes,scores] = step(peopleDetector,I);
I = insertObjectAnnotation(I,'rectangle',bboxes,scores);
figure, imshow(I)
title('Detected people and detection scores');