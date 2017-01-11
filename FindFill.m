function [ filler ] = FindFill( im, outline, windowSize, inner )
%   FINDFILL Finds Areas of Similar Texture based on Intesity
%   Use of image segementaion and thresholding to find similar intensity
%   based testures
%
%   Cosi177a - 4.4.2016 - Textural Inpainting Project
% 

%Image segmentation based on intensity
numOfSteps = 12;
step = 256 / numOfSteps;

% im = medfilt2(im);
% 
% se = strel('disk', 20);
% Io = imopen(im, se);
% Ie = imerode(im, se);
% Iobr = imreconstruct(Ie, im);
% Ioc = imclose(Io, se);
% Iobrd = imdilate(Iobr, se);
% Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
% Iobrcbr = imcomplement(Iobrcbr);
% fgm = imregionalmax(Iobrcbr);

im = kmeans(im);

im = im2uint8(im);
im = ceil(im/step) * step;    %binning our pixels to 8 steps (determined)


%% Running Code
index = [0];
%We take the outline to get a general idea of what surrounds those pixels...
for i= 1:size(outline, 2)
    x = outline(1, (i));
    y = outline(2, (i));
    
    %3x3 mask around the outline pixel
    roi = im((y-2):(y+2) , (x-2):(x+2));
    
    %average whats around it
    avg = sum(sum(roi))/8;
    index(i) = avg;
end

%finding total average around the outline
tAvg = sum(index) / size(index,2);
values = unique(im)';
test = 0;

for i= 1:size(values, 2)
    if values(1,i) > tAvg && test == 0
        test = 1;
        
        low = tAvg - values(1,i-1);
        high = values(1,i) - tAvg;
        
        if low < high
            v = values(1, i-1);
        else
            v = values(i);
        end
    end
end

filler = [0 0]';
itr = 1;
r = floor(windowSize/2) + 1;

for x= 1:size(im,2)         %traverse entire picture
    for y= 1:size(im,1)
        
        %if the pixel value is close to the texture intensity surrounding
        %the hole, add it to possible filler points
        if im(y,x) == v 
            if (x < (size(im, 2) - r)) && (x > r) && (y < (size(im, 1) - r)) && (y > r)
                pull = im((y-r):(y+r), (x-r):(x+r));
                c = 0;
                
                for i= 1:size(pull,2)
                    for j= 1:size(pull,1)
                        if (pull(j,i) == v)
                            c = c+1;
                        end
                    end
                end
                
                if c >= (windowSize*windowSize*.9)
                    filler(1,itr) = x;
                    filler(2,itr) = y;
                    itr = itr + 1;
                end
                
            end
        end
    end
end



%% Plotting to help debugging

figure();
% subplot(1,2,1); 
imshow(im); title('Texture Segmentation');
% subplot(1,2,2); imhist(im); title('tex.Seg.Hist.');


%% Termination Catch

if(size(filler,2) == 1)
    error('No fillers could be found using defined fill size!');
end
end

