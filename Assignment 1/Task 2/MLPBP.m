function [V,v,W,w,e] = MLPBP(V,v,W,w,X,T,params)
%function [V,v,W,w,e] = MLPBP(V,v,W,w,X,T,params)
%
% Implementation of the backpropagation learning algorithm for a single
% hidden layer MLP. Returns weights updated by backpropagation over X and T
%
% V is a Q by N matrix of weights for N hidden layer units
% W is an N by O matrix of weights for O output layer units
% v is the bias weight vector (Nx1) for N hidden layer units
% w is the bias weight vector (Ox1) for O output layer units
% X is a Q by M matrix of M training input patterns
% T is a O by M matrix of M training output patterns
% params(1) is the number of training epochs required
% params(2) is the learning rate
% e SSE after each epoch

%Changelog:
% 15 March 2013, haywardr, initial code
% 22 March 2013, haywardr, corrected calculation of deltav and deltaw.
% These incorrectly used deltaV and deltaW rather than the slopes. 
% Added RMSE


%track SSE error in e
e =zeros(1,params(1));

eta = params(2);


[numInputs numExamples] = size(X);
[numHidden numOutput] = size(W);

%setup the bias values
hiddenOutputOnes = ones([numHidden numExamples]);
outputOutputOnes = ones([numOutput numExamples]);

numExamplesOnes = ones(1,numExamples);


for i=1:params(1),
    %forward propagate signals
   hiddenOutput = sigmoid((V'*X)-(v*numExamplesOnes));
   outputOutput = sigmoid((W'*hiddenOutput)-(w*numExamplesOnes));
   
   %calculate the sigmoid derivative at each layer
   hiddenDerivative = hiddenOutput .* (hiddenOutputOnes - hiddenOutput);
   outputDerivative = outputOutput .* (outputOutputOnes - outputOutput);
   
   %calculate the error at the output layer
   error = (T-outputOutput);
   
   %gradients for each of the weight matrices
   slopeW = (error .* outputDerivative); %OxM
   slopeV = ((W*slopeW) .* hiddenDerivative); % NxM
   
   %calculate weight changes
   deltaV = (X * slopeV'); %QxN
   deltav = sum(slopeV,2); %Nx1
   deltaW = (hiddenOutput * slopeW'); %NxO
   deltaw = sum(slopeW,2); %Ox1
   
   sumSquaredError = sum(sum(error .^2)');
   e(i) = sumSquaredError;
   fprintf('Epoch: %d: SSE=%15.20f RMSE=%15.20f\n',...
       i,sumSquaredError,sqrt(sumSquaredError)/numExamples);
       
   %adapt weights
   V = V + eta.*deltaV; %QxN
   v = v - eta.*deltav; %Nx1
   W = W + eta.*deltaW; %NxO
   w = w - eta.*deltaw; %Ox1
   
end