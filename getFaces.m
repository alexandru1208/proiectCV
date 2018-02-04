function [ faceBox ] = getFaces( I )
faceDetector = vision.CascadeObjectDetector('MergeThreshold',10); %initializare detector pentru fata
faceBox = step(faceDetector,I); % detectarea fetei cu ajutorul detectorului
end

