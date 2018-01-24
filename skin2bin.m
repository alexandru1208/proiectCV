function [ bwImage ] = skin2bin( rgbImage )
hsvImage = rgb2hsv(rgbImage);
[w,h,~] = size(rgbImage);
bwImage = zeros(w,h);
for r = 1 : w
   for c = 1 : h 
       R = rgbImage(r,c,1);
       G = rgbImage(r,c,2);
       B = rgbImage(r,c,3);
       H = hsvImage(r,c,1)*360;
       S = hsvImage(r,c,2);
       if(H>=0 &&...
          H<=50 &&...
          S>=0.23 &&...
          S<=0.68 &&...
          R>95 &&...
          G>40 &&...
          B>20 &&...
          R>G &&...
          abs(R-G)>15)
      
         bwImage(r,c) = 1;
        end
   end
end
end

