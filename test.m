%% 'Client Code' Portion of Project
%   Max Whitmore - Cosi177a - 4.4.2016 - Textural Inpainting Project
%   REQUIREMENTS:
%       FindInfill.m
%       CrudeFill.m
%       FindFill.m
%       SobelMask.m
%       image file with cropped out hole

%% Running Code

tic

%image to be processed
%picture = input('Please input picture filename: ', 's');
%im = imread(picture);
im = imread('cow2.png');

if size(im,3) == 3      %if color image, convert to grayscale
    im = im2uint8(rgb2gray(im));
end

fprintf('Locating Hole:');
[inner, outline] = FindInfill(im);


%inner = [inner , outline];


fprintf('\nFilling in Hole:');
pim = CrudeFill(im, inner, outline);

%% Plotting Final Images

figure();
subplot(1,2,1); imshow(im), title('Original')
subplot(1,2,2); imshow(pim), title('Filled')

t = toc;
fprintf('\n\nTotal time for filling was %5.2f seconds\n',t)