function [ im ] = CrudeFill( im, inner, outline )
%   CRUDEFILL Copy-and-Paste Algorithm for Filling a Hole
%   This take pixels on the same x-axis and puts them into where the hole
%   is found to be. This very preliminarily fills in the hole with the
%   possibilty it is taking the wrong texture.
%
%   Cosi177a - 4.4.2016 - Textural Inpainting Project
% 
%% Running Code

%define as a percent of the hole size ie(.1 = 10% the size of the hole)
sizeOfWindows = .4;

windowSize = floor(sizeOfWindows * sqrt((size(inner,1)*size(inner,2))));


fprintf('\n\t1/2 : Creating textural template database');

 %finds what can be used to fill in hole
filler = FindFill(im, outline, windowSize, inner);
%s = size(im,2);

%inner = Sort(inner);

fprintf('\n\t2/2 : Pulling squares');

i = im;
%loop to process each of the pxls found in the hole
for x = 1: floor(windowSize/2) :size(inner,2)
    for y = 1: floor(windowSize/2) :size(inner,1)
        
        if inner(y,x) == 1
            i = CopyTexture(i, x, y, filler, windowSize);
        end
    
    end
end

for x= 1:size(inner,2)
    for y= 1:size(inner,1)
        
        if inner(y,x) == 1
            im(y,x) = i(y,x);
        end
    end
end


end