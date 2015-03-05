function [res] = sigmoid(X)
%function [res] = sigmoid(X)
%
% Implementation of the logistic function

res = 1.0 ./ (1.0+exp(-X));

