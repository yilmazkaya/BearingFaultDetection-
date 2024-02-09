clear all;clc;
load("veriseti1.mat");


cvp = cvpartition(tumdata(:,end),Holdout=0.2);
dataTrain = tumdata(training(cvp),:);
dataValidation = tumdata(test(cvp),:);

Xtrain=verihazirla(dataTrain);
Ytrain=categorical(dataTrain(:,end));

Xtest=verihazirla(dataValidation);
Ytest=categorical(dataValidation(:,end));


%LSTM bölümü*****************************************
numClasses=5;
layers = [ 
    sequenceInputLayer(5,Name="giris")
    lstmLayer(100,'OutputMode','last',Name="lstm0")];

lgraph = layerGraph(layers);

hucreler=[10 20 30 40 50];
numBlocks = numel(hucreler);

for j = 1:numBlocks
N = hucreler(j);
block = [
lstmLayer(N,'OutputMode','last',Name="lstm"+N)
];
lgraph = addLayers(lgraph,block);
lgraph = connectLayers(lgraph,"lstm0","lstm"+N);
end

classNames = unique(Ytrain);
numClasses = numel(classNames);

layers = [
concatenationLayer(1,numBlocks,Name="cat")
fullyConnectedLayer(numClasses,Name="fc")
softmaxLayer(Name="soft")
classificationLayer(Name="classification")];

lgraph = addLayers(lgraph,layers);

for j = 1:numBlocks
N = hucreler(j);
lgraph = connectLayers(lgraph,"lstm"+N,"cat/in"+j);
end

figure
plot(lgraph)
title("Network Architecture")



options = trainingOptions('adam', ...
    'ExecutionEnvironment','cpu', ...
    'GradientThreshold',1, ...
    'MaxEpochs',30, ...
    'MiniBatchSize',17, ...
    'SequenceLength','longest', ...
    'Shuffle','never', ...
    'Verbose',1, ...
    'plots','training-progress', ...
    "ValidationData",{Xtest,Ytest});
 net2 = trainNetwork(Xtrain,Ytrain,layers,options);
 trainPred2 = classify(net2,XTrain);
 LSTMAccuracy = sum(trainPred2 == YTrain)/numel(YTrain)*100
 confusionchart(YTrain,trainPred2,'ColumnSummary','column-normalized',...
 'RowSummary','row-normalized','Title','Confusion Matrix for Train Set with for LSTM');
 testPred2 = classify(net2,XTest);
 figure;
 LSTMAccuracy = sum(testPred2 == YTest)/numel(YTest)*100
 confusionchart(YTest,testPred2,'ColumnSummary','column-normalized',...
 'RowSummary','row-normalized','Title','Confusion Matrix for Test Set with LSTM');
%  %Performans ölçütleri
%   stats=confusionmatStats(testPred2,YTest);
%   mean(stats.accuracy)
%   mean(stats.recall)
%   mean(stats.precision)
%   mean(stats.Fscore)
%LSTM ****************


