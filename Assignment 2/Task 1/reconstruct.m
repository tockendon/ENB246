function reconstruct(imageFile, kVal, distanceFunc, colourFunc)
% reconstruct Reconstruct a damaged image with limited coloured pixels
% 
% Example
%    reconstruct('fig1a.png', 4, @distanceEuc, @colourAverage)
% 
% Purpose:
% Reconstruct an image by determining colour for damaged pixels taking the
% average of the 'k'closest pixels. The user is prompted at the start to
% choose from 2 distance and 2 colour calculation methods. A subplot is
% displayed to show the image before and after reconstruction.
%
% Record of Revisions:
%   Date         Engineer            Descriptions of Change
%  ======       ==========          ========================
%  01/05/2013   Terrance Ockendon   Original Code
%  03/05/2013   Terrance Ockendon   Made more efficient. Reduced runtime
%                                   from 50+ min to 2.5 min.
%  04/05/2013   Terrance Ockendon   Seperating code into functions
%  04/05/2013   Terrance Ockendon   Whole process has been reduced to under
%                                   2 seconds
%  07/05/2013   Terrance Ockendon   Renaming functions
%  13/05/2013   Terrance Ockendon   Removed vectorisation from distance
%                                   function to accept scalar values.
%  21/05/2013   Terrance Ockendon   Removed all vectorised functions from
%                                   anything to do with pixel distance
%                                   location. Fig1a takes about 25 seconds.
%                                   Also, adding the final touches for
%                                   release.
% Define Variables:
%    imageFile       -- Image file
%    kVal            -- Parameter which tells the function how many of the
%                       'k' closest pixels to find for colour calculation.
%    distanceFunc    -- This is a function for the handle function of
%                       distance calculation which is either @distanceEuc
%                       or @distanceMan.
%    colourFunc      -- This is a function for the handle function of
%                       colour calculation which is either @colourAverage
%                       or @colourCustom.
tic
% Reads image to RGB array and creates a copy for later comparison
pictureMat = imread(imageFile);
pictureBefore = pictureMat;
% Locates all damaged and un-damaged pixels, returning them in row arrays
% of with their values for row and column co-ordinate
[damPixrow, damPixcol, undamPixrow, undamPixcol] = rgbStatus(pictureMat);
% Pre-allocate arrays
rgbDist = zeros(kVal,4);
distSpace = zeros(1,size(undamPixrow,2));
% Loops to replace every damaged pixel with a calculated colour from 'k'
% nearest un-damaged pixels.
for kk = 1:size(damPixrow,2)
    % Finds distances of 'k' closest pixels by using scalar values
    for ll = 1:size(undamPixrow,2)
        [distSpace(1,ll)] = distanceFunc(...
            damPixrow(kk),...
            damPixcol(kk),...
            undamPixrow(ll),...
            undamPixcol(ll));
    end
    %  Finds the minimum distance 'd' distances replacing the minimum value
    %  with infinity so that the next minimum is found.
    for ind = 1:kVal
        [ distVal, indexPos ] = min(distSpace);
        distSpace(1,indexPos) = inf;
        [rgbDist(ind,:)] = rgbInput(undamPixrow(indexPos),...
            undamPixcol(indexPos), distVal, pictureMat);
    end
    % Sorts the rgb and distance matrix according to distance.
%     sort(rgbDist,4);
    [colourSum] = colourFunc(rgbDist);
    % Once rgbDist is created it is then input into the colourFunc which
    % then calculates a colour depending on the chosen handle.
    % colourSum then contains the new rgb value and replaces the damaged
    % pixel rgb intensities.
    for dim = 1:3
        pictureMat(damPixrow(kk), damPixcol(kk), dim) = colourSum(1,dim);
    end
    fprintf('%d of %d \n',kk, size(damPixrow,2))
end
% Creates a filename according to parameters used to reconstruct image
displayPlot(imageFile, distanceFunc, colourFunc, pictureBefore, pictureMat, kVal);
end
% Helper Functions, descriptions of each functions purpose inside:
function [damPixrow, damPixcol, undamPixrow, undamPixcol] = rgbStatus(pictureMat)
% this function locates all the damaged and undamaged pixels and returns
% them as row vectors
img = single(pictureMat);
img = sum(img, 3);
[row, col] = size(img);
colour = img > 0;
black = ~colour;
colour = colour';
colour = colour(:)';
black = black';
black = black(:)';
% Create repeating rows in a vector
for i = 1:row % 1:row
    b(i,:) = ones(1,col) .*i; %1:col
end
b = b'; % Flip to become a single row
x = b(:)'; % row
% Create repeating columns.
y = repmat(1:col,1,row); % col
undamPixrow = x.*colour;
undamPixcol = y.*colour;
damPixrow = x.*black;
damPixcol = y.*black;
undamPixrow(undamPixrow==0) = [];
undamPixcol(undamPixcol==0) = [];
damPixrow(damPixrow==0) = [];
damPixcol(damPixcol==0) = [];
end
function displayPlot(imageFile, distanceFunc, colourFunc, pictureBefore, pictureMat, k)
% This function was purely made to hide all the clutter involved in
% creating a figure and saving the image to a filename as per the analysis
% methods used.
[~, s1, ~] = fileparts(imageFile);
s2 = func2str(distanceFunc);
s3 = func2str(colourFunc);
fileName = sprintf('%s-%d-%s-%s%s', s1, k, s2, s3);
% Writes the new image to file
imwrite(pictureMat,[fileName,'.png']);
% Displays subplot of before and after shots
fileOrig = sprintf('Original Image:\n%s', s1);
subplot(1,2,1), subimage(pictureBefore);
title(fileOrig);
axis off
fileRecon = sprintf('Reconstructed Image: \n%s, k=%d, %s, %s', s1, k, s2, s3);
subplot(1,2,2), subimage(pictureMat);
title(fileRecon);
axis off
end
function [rgbRow]=rgbInput(undamPixrow, undamPixcol, distSpace, pictureMat)
% Creates a row to build the 'k' x 4 array, where columns 1, 2, & 3
% correspond to the red, green, blue intensities, and the 4th column gives
% the distance from the damaged pixel to the undamaged pixel.
rgbRow(1,:) = pictureMat(undamPixrow, undamPixcol, :);
rgbRow(1,4) = distSpace;
end