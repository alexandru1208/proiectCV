clc;
workspace;
clear all;

clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures if you have the Image Processing Toolbox.
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 13;

% Check that user has the Image Processing Toolbox installed.
hasIPT = license('test', 'image_toolbox');
if ~hasIPT
	% User does not have the toolbox installed.
	message = sprintf('Sorry, but you do not seem to have the Image Processing Toolbox.\nDo you want to try to continue anyway?');
	reply = questdlg(message, 'Toolbox missing', 'Yes', 'No', 'Yes');
	if strcmpi(reply, 'No')
		% User said No, so exit.
		return;
	end
end

% %===============================================================================
% % Read in a standard MATLAB color demo image.
% folder = 'D:\Temporary stuff';
% baseFileName = 'RotateTwoColorShapes.jpg';
% % Get the full filename, with path prepended.
% fullFileName = fullfile(folder, baseFileName);
% if ~exist(fullFileName, 'file')
% 	% Didn't find it there.  Check the search path for it.
% 	fullFileName = baseFileName; % No path this time.
% 	if ~exist(fullFileName, 'file')
% 		% Still didn't find it.  Alert user.
% 		errorMessage = sprintf('Error: %s does not exist.', fullFileName);
% 		uiwait(warndlg(errorMessage));
% 		return;
% 	end
% end
rgbImage = imread(fullFileName);
% Get the dimensions of the image.  numberOfColorBands should be = 3.
[rows, columns, numberOfColorBands] = size(rgbImage);
% Display the original color image.
subplot(2, 2, 1);
imshow(rgbImage);
axis on;
title('Original Color Image', 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

% Extract the individual red, green, and blue color channels.
redChannel = rgbImage(:, :, 1);
greenChannel = rgbImage(:, :, 2);
blueChannel = rgbImage(:, :, 3);

% Find the black outlines.
thresholdValue = 100;
blackOutlines = redChannel <= thresholdValue & greenChannel <= thresholdValue & blueChannel <= thresholdValue;
% Display the image.
subplot(2, 2, 2);
imshow(blackOutlines);
title('Black Outlines', 'FontSize', fontSize);

% Fill the outline to make it solid so we don't get boundaries
% on both the inside of the shape and the outside of the shape.
binaryImage = imfill(blackOutlines, 'holes');
% Display the image.
subplot(2, 2, 3);
imshow(binaryImage);
title('Binary Image', 'FontSize', fontSize);

% bwboundaries() returns a cell array, where each cell contains the row/column coordinates for an object in the image.
% Plot the borders of all the coins on the original grayscale image using the coordinates returned by bwboundaries.
subplot(2, 2, 4);
imshow(binaryImage);
axis on;
title('Binary Image', 'FontSize', fontSize);
title('With Boundaries, from bwboundaries()', 'FontSize', fontSize);
hold on;
boundaries = bwboundaries(binaryImage);
numberOfBoundaries = size(boundaries, 1);
for k = 1 : numberOfBoundaries
	thisBoundary = boundaries{k};
	plot(thisBoundary(:,2), thisBoundary(:,1), 'r', 'LineWidth', 3);
end
hold off;

% Define object boundaries
numberOfBoundaries = size(boundaries, 1)
message = sprintf('Found %d boundaries', numberOfBoundaries);
uiwait(helpdlg(message));
boundary1 = boundaries{1};
boundary2 = boundaries{2};
boundary1x = boundary1(:, 2);
boundary1y = boundary1(:, 1);
x1=1;
y1=1;
x2=1;
y2=1;
overallMinDistance = inf; % Initialize.
% For every point in boundary 2, find the distance to every point in boundary 1.
for k = 1 : size(boundary2, 1)
	% Pick the next point on boundary 2.
	boundary2x = boundary2(k, 2);
	boundary2y = boundary2(k, 1);
	% For this point, compute distances from it to all points in boundary 1.
	allDistances = sqrt((boundary1x - boundary2x).^2 + (boundary1y - boundary2y).^2);
	% Find closest point, min distance.
	[minDistance(k), indexOfMin] = min(allDistances);
	if minDistance(k) < overallMinDistance
		x1 = boundary1x(indexOfMin);
		y1 = boundary1y(indexOfMin);
		x2 = boundary2x;
		y2 = boundary2y;
		overallMinDistance = minDistance(k);
	end
end
% Find the overall min distance
minDistance = min(minDistance);
% Report to command window.
minDistance

% Draw a line between point 1 and 2
line([x1, x2], [y1, y2], 'Color', 'y', 'LineWidth', 3);