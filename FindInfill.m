function [ subtracted, outline ] = FindInfill( im )
%FINDINFILL Locates A Cropped Hole in an Image
%   Using the original image we can locate a cropped-out hole, and then 
%   the Sobel  Edge detection to locate the outline of the hole
%
%   Conor Lanahan, Max Whitmore, Fatima Hussiani - Cosi177a - 4.4.2016 - Textural Inpainting Project
%   
%   INPUTS:
%       im: image of interest
%
%   OUTPUTS:
%       inner: [1,:] - x coordinates within the hole
%              [2,:] - y coordinates within hole corresponding to the x's
%       outline: [1,:] - x coordinates of the hole edge
%                [2,:] - y coordinates of the hole edge respectively

%% Running Code

bwim = im2bw(im, graythresh(im));
bwim2 = bwim;

ySize = size(im, 1);
xSize = size(im, 2);
count = 0;

fprintf('\n\t1/3 : Image traversal');

for x= 1:xSize      %traverses the entire picture
    for y= 1:ySize
        
        if im(y,x) == 0         %locating hole pixels
            if bwim2(y,x) == 0
                
                bwim2(y,x) = 1;     %swaps the pixel value of b/w image
                count = count + 1;
                
            end
        end
        
    end
end

subtracted = medfilt2(bwim2 - bwim);   %image subtraction to find only the hole!

fprintf('\n\t2/3 : Locating Sobel Edges')

%Sobel Edge detection to help find the outline of the hole
edges = SobelMask(subtracted);

%initiation of inner and outline matrixes
%inner = [0 0]';
%itr = 1;

outline = [0 0]';
itr2 = 1;

fprintf('\n\t3/3 : Image traversal');

for x= 1:xSize          %entire image traversal
    for y= 1:ySize
        
        %in our subtracted image if we find 1 its part of the hole
        %if subtracted(y,x) == 1        
        %    inner(2, itr) = y;
        %    inner(1, itr) = x;
        %    itr = itr + 1;
        %end
        
        %in our sobel edge image, if we find 1 its part of the edge
        if edges(y,x) > 0
            outline(2, itr2) = y;
            outline(1, itr2) = x;
            itr2 = itr2 + 1;
            
            subtracted(y,x) = 1;
        end
        
    end
end


%% Plotting images for debugging

%figure();
%subplot(1,2,1); imshow(subtracted), title('Located Hole');
%subplot(1,2,2); imshow(edges), title('Hole Outline');

end

