function [ normEdge ] = SobelMask( i )
%   SOBELMASK Applies a sobel x/y filter to an image passed into the function
%   This function will take in any type of image and will return a
%   grayscale image


%% RUNNING CODE

im = im2bw(i, graythresh(i));

sobelxfilt = [-1 0 +1; -2 0 +2; -1 0 +1];
sobelyfilt = [-1 -2 -1; 0 0 0; +1 +2 +1];
[r, c] = size(im);
im = double(im);

xedge = zeros(r, c);
yedge = zeros(r, c);


for dx = 2:c-1
    for dy = 2:r-1
        mask = im((dy-1):(dy+1) , (dx-1):(dx+1));
        
        xfilt = sobelxfilt.*mask;
        xedge(dy, dx) = sum(sum(xfilt));
        
        yfilt = sobelyfilt.*mask;
        yedge(dy, dx) = sum(sum(yfilt));
    end
end

normEdge = sqrt(yedge.^2 + xedge.^2);

end
