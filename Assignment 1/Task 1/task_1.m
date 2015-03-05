% Script file: task1.m
% 
% Purpose:
%   This program converts a color image portable network graphics file into
%   an 8 colour format and reproduces the image. The program then
%   reconstructs an 8 colour picture by the max value probability colour 
%   appearing in each pixel of the picture by pixel rows, and pixel 
%   columns, & all pixels.
% 
% Record of Revisions:
%       Date        Programmer          Description of change
%       ====        ==========          =====================
% 1.  09/04/2013    T. L. Ockendon      Original code
% 
% Define variables:
% A       -- initial 8 colour matrix of image
% B       -- an array of a logical matrices of with 1 colour per dimension
% AllProb -- 1x8 probablity matrix of colour probability in image
% RowProb -- Arowx8 probability matrix of colour probability in each row
% ColProb -- Acolx8 probability matrix of colour probability in each column
% ProbRGB -- ArowxAcol reconstructed matrix of probable colours per element

% Clear any previous data in the workspace
clear, clc
% Requests the filename of a colour image file from the user
pic = uigetfile('.png');
% Loads the image and represents it as an n*m*3 array of red, green and
% blue intensity values
[A,MAP] = imread(pic);
if ~isempty(MAP)
    pic = ind2rgb(A,MAP);
end
% The image from a red, green and blue (RGB) representation to an
% indexed image with an associated colormap containing 8 colours
[A,MAP] = rgb2ind(A,8);
imwrite(A, MAP, 'OUTPUT_8Colour.png');
% Calulate the probability of the occurance of each of the 8 colours
[Arow,Acol] = size(A);
B = cat(3, A==0, A==1, A==2,A==3,A==4,A==5,A==6,A==7);
for index = 1:1:8
    AllProb(index) = sum(sum(B(:,:,index)))/(Arow*Acol);
end
% Calculate the probabilities for each of the colours occuring in each row
[m, n, o] = size(B);
for jj = 1:1:o
    for ii = 1:1:m;
        RowProb(jj,ii) = sum(B(ii,:,jj));
    end
end
% Transpose RowProb matrix to position colours in correct columns
RowProb = RowProb.';
RowProb = RowProb*(1/n);
% Calculate the probabilities for each of the colours occuring in each
for ll = 1:1:o
    for kk = 1:1:n;
        ColProb(kk,ll) = sum(B(:,kk,ll));
    end
end
ColProb = ColProb*(1/m);
% Apply the most probable color to the respective element being analysed
    for yRGB = 1:1:n
        for xRGB = 1:1:m
            % Gets max value probability considering row, column, & image.
            % Inserts max value probability              
            [val, loc] = max(RowProb(xRGB,:).*ColProb(yRGB,:)./AllProb);
            ProbRGB(xRGB,yRGB) = loc;
        end
    end
% Writes probability reconstruction of image from matrix to image file
imwrite(ProbRGB, MAP, 'OUTPUT_Prob8Colour.png');
% Creates 1x3 subplot of the input, 8 colour rep, and probability rep image
subplot(1,3,1);
imshow(pic)
title('User Input Image')
subplot(1,3,2);
imshow('OUTPUT_8Colour.png')
title('8 Colour Reconstruction')
subplot(1,3,3);
imshow('OUTPUT_Prob8Colour.png')
title('Probability Output Image')