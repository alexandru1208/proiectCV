function [ joinedBox ] = joinBoxes( boxesMatrix )
minX = min([boxesMatrix(:,1);boxesMatrix(:,1)+boxesMatrix(:,3)]);
minY = min([boxesMatrix(:,2);boxesMatrix(:,2)+boxesMatrix(:,4)]);
maxX = max([boxesMatrix(:,1);boxesMatrix(:,1)+boxesMatrix(:,3)]);
maxY = max([boxesMatrix(:,2);boxesMatrix(:,2)+boxesMatrix(:,4)]);
joinedBox = [minX,minY,maxX-minX,maxY-minY];
end

