rgbImage = imread('beach5.png');
hsvImage = rgb2hsv(rgbImage);
ycbcrImage = rgb2ycbcr(rgbImage);

imshow(rgbImage)

[w,h,d] = size(rgbImage);
for r = 1 : w
   for c = 1 : h 
       R = rgbImage(r,c,1);
       G = rgbImage(r,c,2);
       B = rgbImage(r,c,3);
       H = hsvImage(r,c,1)*360;
       S = hsvImage(r,c,2);
       Y=0.299*R+0.587*G+0.114*B;
       Cb=128+(-0.169*R+331*G+0.500*B);
       Cr=128+(0.500*R-0.419*G-0.081*B);
       
%        Y = ycbcrImage(r,c,1);
%        Cb = ycbcrImage(r,c,2);
%        Cr = ycbcrImage(r,c,3);
      
%        if
%            H>=0.01 && H<=0.1 && S>=0.2 && S<=0.7 && Cr>=125 && Cr<=165 && Cb>=76 && Cb<=126
        if   (H>=0 &&...
          H<=50 &&...
          S>=0.23 &&...
          S<=0.68 &&...
          R>95 &&...
          G>40 &&...
          B>20 &&...
          R>G &&...
          abs(R-G)>15)
%           (R>95 &&...
%           G>40 &&...
%           B>20 &&...
%           R>G &&...
%           abs(R-G)>15 &&...
%           Cr>135 &&...
%           Cb>85 &&...
%           Y>80 )
%       &&...
%           Cr<=(1.5862*Cb)+20 &&...
%           Cr>=(0.3448*Cb)+76.2069 &&...
%           Cr>=(-4.5652*Cb)+234.5652 &&...
%           Cr<=(-1.15*Cb)+301.75 &&...
%           Cr<=(-2.2857*Cb)+432.85)
         
         rgbImage(r,c,1) = 255;
         rgbImage(r,c,2) = 255;
         rgbImage(r,c,3) = 255;
        else
         rgbImage(r,c,1) = 0;
         rgbImage(r,c,2) = 0;
         rgbImage(r,c,3) = 0;
        end
       
   end
end

figure
imshow(rgbImage);