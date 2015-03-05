function [colourSum] = colourAverage(rgbDist)
% Purpose:
% To find the 'k' nearest neightbours and to calculate there average RGB
% intensities.
%
% Record of Revisions:
%   Date         Engineer            Descriptions of Change
%  ======       ==========          ========================
%  01/05/2013   Terrance Ockendon   Original Code
%
% Define Variables:
%   rgbDist         -- Is a k by 4 array, where columns 1, 2 and 3
%                      correspond to the red, green and blue intensities
%                      respectively, and the fourth column gives the
%                      distance of the pixel to the one that you are trying
%                      to colour.
%   colourSum       -- Is the output rgb matrix containing the average sum
%                      of the rgb values calculated from the k nearest
%                      pixels.
colourSum = zeros(1,3);
[k, ~] = size(rgbDist);
for col = 1:3
    colourSum(1,col) = sum(rgbDist(:,col)).*(1/k);
end