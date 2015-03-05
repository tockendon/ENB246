function [outputDistance] = distanceMan(damPixrow, damPixcol, undamPixrow, undamPixcol)
% Purpose:
% Uses a scalar input to calculate Manhattan distance between the damaged
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
outputDistance = abs(undamPixrow - damPixrow) + abs(undamPixcol - damPixcol);
