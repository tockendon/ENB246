function [colourSum] = colourCustom(rgbDist)
% Purpose:
% To find the k closest pixels and to calculate a custom
% approximation for the RGB values where the closer pixels have a
% greater influence on the colour choosen for the damaged pixel.
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
%   colourSum       -- Is the output rgb matrix containing a weighted
%                      average sum of the rgb values calculated from the k
%                      nearest pixels.

[kVals, ~] = size(rgbDist);
proB(1,1) = 0.5;
for ii = 2:kVals
    proB(ii,1) = proB(ii-1,1)/2;
end
rgbDist2 = zeros(1,3);
for ii = 1: kVals
    rgbDist2 = rgbDist2 + rgbDist(ii,1:3)*proB(ii);
end
colourSum = rgbDist;
