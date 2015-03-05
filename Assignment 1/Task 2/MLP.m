function [result] = MLP(V,v,W,w,X)
% V is a Q by N matrix of weights for N hidden layer units
% W is an N by O matrix of weights for O output layer units
% v is the bias weight vector (Nx1) for N hidden layer units
% w is the bias weight vector (Ox1) for O output layer units
% X is a Q by M matrix of M training input patterns
% T is a O by M matrix of M training output patterns
% params(1) is the number of training epochs required
% params(2) is the learning rate


[numInputs numExamples] = size(X);
[numHidden numOutput] = size(W);

hiddenOutputOnes = ones([numHidden numExamples]);
outputOutputOnes = ones([numOutput numExamples]);

numExamplesOnes = ones(1,numExamples);

hiddenOutput = sigmoid((V'*X)-(v*numExamplesOnes));
outputOutput = sigmoid((W'*hiddenOutput)-(w*numExamplesOnes));

result = outputOutput;