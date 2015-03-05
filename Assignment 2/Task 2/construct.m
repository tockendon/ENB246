function construct(imageFile, probSamp)
% Example
%    construct('test.png', 0.5)
% Purpose:
% Takes a filename and a probability 'probSamp' as parameters. The function
% loads an image from file, and then sets the R, G and B channels of a 
% pixel to zero with the given probability.
%
% Record of Revisions:
%   Date         Engineer            Descriptions of Change
%  ======       ==========          ========================
%  10/05/2013   Terrance Ockendon   Original Code

% Define Variables:
%    imageFile       -- Image file
%    probSamp        -- Sample probability value (between 0 to 1)

% This is a helper funciton to read the image and convert it to RGB
[picMAT] = getRGB(imageFile);
% Samples the image depending on 'probadder'
if probSamp < 1
    [picRow, picCol, ~] = size(picMAT);
    randBlack = randperm(picRow*picCol, ceil(probSamp*picRow*picCol));
    for ii = 1:3
        picMAT(randBlack+(ii-1)*picRow*picCol) = 0;
    end
    blackMAT = picMAT;
    imshow(blackMAT,'InitialMagnification','fit');
    savePic(imageFile, probSamp, blackMAT);
else
%     If the probability amount it greater than or equal to the whole image
%     will return a black picture.
    [row, col, dim] = size(picMAT);
    blackMAT = zeros(row,col,dim);
    imshow(blackMAT,'InitialMagnification','fit');
    savePic(imageFile, probSamp, blackMAT);
end
% Helper Function:
function [img] = getRGB(imageFile)
% Load image.
[img, map] = imread(imageFile);
% Convert to RGB if an indexed image has been loaded.
if size(map) ~= 0 
img = ind2rgb(img,map);
end
% Convert to double precision to avoid errors with various functions.
[img] = im2double(img);
end
function savePic(imageFile, probSamp, blackMAT)
% This function was purely made to hide all the clutter involved in
% creating a figure and saving the image to a filename as per the analysis
% methods used.
[~, s1, ~] = fileparts(imageFile);
s2 = num2str(probSamp);
fileName = sprintf('%s-prob-%s', s1, s2);
% Writes the new image to file
imwrite(blackMAT,[fileName,'.png']);
end
end

























