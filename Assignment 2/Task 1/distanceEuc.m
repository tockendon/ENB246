function [outputDistance] = distanceEuc(damPixrow, damPixcol, undamPixrow, undamPixcol)
% Purpose:
% Uses a scalar input to calculate Euclidean distance between the damaged
% and un-damaged pixels.
%
% Record of Revisions:
%   Date         Engineer            Descriptions of Change
%  ======       ==========          ========================
%  01/05/2013   Terrance Ockendon   Original Code
%
% Define Variables:
%   damPixrow       -- damaged pixel row coordinate
%   damPixcol       -- damaged pixel column coordinate
%   undamPixrow     -- un-damaged pixel row coordinate
%   undamPixcol     -- un-damaged pixel column coordinate
% outputDistance = ((undamPixrow - damPixrow).^2 + (undamPixcol - damPixcol).^2)^0.5;
% To improve the speed of this function the sqrt can be removed. this does
% not change the look of the output image.
outputDistance = (undamPixrow - damPixrow).^2 + (undamPixcol - damPixcol).^2;