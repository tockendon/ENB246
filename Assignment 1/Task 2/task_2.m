% Script file: task2.m
% 
% Purpose:
%   This program converts a color image portable network graphics file into
%   a gray scale colour format and reproduces the image. The program then
%   attempts to reconstruct a picture by sampling the gray scale matrix of 
%   the picture randomly and using a learning alogrithm. 
% 
% Record of Revisions:
%       Date        Programmer          Description of change
%       ====        ==========          =====================
% 1.  09/04/2013    T. L. Ockendon      Original code
% 
% Define variables:
% A       -- initial grayscale matrix of image.
% X       -- training matrix which samples grayscale image.
% P       -- sequentially reproduces coordinates of the intial matrix into
%            2 rows containing row coordinate and column coordinate.

% Clear workspace..
clear
% Requests the filename of a colour image file from the user
pic = imread(uigetfile('.png'));
A = rgb2gray(pic);
% Save new image with matlab funciton imwrite
imwrite(A,'OUTPUTgrayscale.png');
A = mat2gray(A);
% Create a matrix X with 3 rows and k columns where k is 20% of the total
% number of pixels in the image.
[Arow, Acol] = size(A);
Xcol = ceil(Acol.*Arow.*0.2);
X = zeros([3 Xcol]);
% Populates 'X' by randomly sampling the gray scale image 'k' times
for jj = 1:Xcol
    rCol = randi([1 Acol]);
    rRow = randi([1 Arow]);
    X(1, jj) = rRow;
    X(2, jj) = rCol;
    X(3, jj) = A(rRow,rCol);
end
% Create p, V, v, W, w matrices using rand function
p = 10;
V = double(rand(2,p));
v = double(rand(p,1));
W = double(rand(p,1));
w = double(rand(1));
T = double(X(3,:));
X = double(X(1:2,:));
param1 = 200000;
param2 = 0.0001;

% Train the MLP
[V,v,W,w,e]=MLPBP(V,v,W,w,X,T,[param1 param2]);
% Generate a matrix P, which is similar to X, however this time for all 
% pixels in the original grayscale image.
P = zeros([2, Acol*Arow], 'double');
kk = 1;
ll = Acol;
Col = 1;
% Using the original size dimensions a 2x(Acol*Arow)P matrix is constructed
% to provide the position of each element by recording the row and column 
% positions of each element. Where the the first row of the P matrix
% records row position and the second row records coloumn position.

% This for loop selects the row.
for Row = 1:Arow
    % This for loop creates 2xAcol parts of the P matrix per loop where for 
    % Acol columns the row is kept constant until all elements in the row
    % have been recorded.
    for Pcol = kk:ll
        P(1,Pcol) = Row;
        P(2,Pcol) = Col;
        Col = Col + 1;
    end
    % To prevent overwriting existing data the code below allows for a new
    % 2xAcol set of data to be added onto the existing P matrix. This
    % also resets the column count to 1.
    Col = Col - Acol;
    kk = kk + Acol;
    ll = ll + Acol;
end
% Pass the V, v,W and w matrices and the new P matrix to the MLP function
% to generate the predictions of the MLP.
Goutput = MLP(V,v,W,w,P);
% Reconstruct and save the new image with the matlab function imwrite
BAM = vec2mat(Goutput,Acol);
imwrite(BAM, 'OUTPUTgrayrecon.png');
% Creates 1x3 subplot of the input, 8 colour rep, and probability rep image
subplot(1,3,1);
imshow(pic)
title('User Input Image')
subplot(1,3,2);
imshow('OUTPUTgrayscale.png')
title('Gray Scale Representation')
subplot(1,3,3);
imshow('OUTPUTgrayrecon.png')
title('Algorithm Reconstruction')