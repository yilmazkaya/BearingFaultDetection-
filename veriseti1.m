clear all;clc;
load("veriseti2.mat");


cvp = cvpartition(tumdata(:,end),Holdout=0.3);
dataTrain = tumdata(training(cvp),:);
dataValidation = tumdata(test(cvp),:);

Xtrain=verihazirla(dataTrain);
Ytrain=categorical(dataTrain(:,end));

Xtest=verihazirla(dataValidation);
Ytest=categorical(dataValidation(:,end));



katman = [3 5 7 9 11];
numFilters = 200;
minLength = 256;
layers = [ 
sequenceInputLayer(5,MinLength=minLength,Name="emb")
convolution1dLayer(100,numFilters,Name="conv1",Padding="same")
%batchNormalizationLayer(Name="bn"+N)
reluLayer(Name="relu1")
layerNormalizationLayer(Name="norm11")];
lgraph = layerGraph(layers);

numBlocks = numel(katman);

for j = 1:numBlocks
N = katman(j);
block = [

%dropoutLayer(0.2,Name="drop"+N)
convolution1dLayer(1,2*numFilters,Name="conv2"+N,Padding="causal")
reluLayer(Name="relu2"+N)

layerNormalizationLayer(Name="norm2"+N)
globalMaxPooling1dLayer(Name="max"+N)
lstmLayer(100,'OutputMode','sequence',Name="lst"+N)
]

lgraph = addLayers(lgraph,block);
lgraph = connectLayers(lgraph,"norm11","conv2"+N);
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
N = katman(j);
lgraph = connectLayers(lgraph,"lst"+N,"cat/in"+j);
end

figure
plot(lgraph)
title("Network Architecture")

options = trainingOptions("adam", ...
MiniBatchSize=27, ...
MaxEpochs=15, ...
SequencePaddingDirection="left", ...
ValidationData={Xtest,Ytest}, ...
OutputNetwork="best-validation-loss", ...
Plots="training-progress", ...
Verbose=true);
net = trainNetwork(Xtrain,Ytrain,lgraph,options);


%Test İşlemi
miniBatchSize = 27;
TestPred = classify(net,Xtest, ...
    'MiniBatchSize',miniBatchSize, ...
    'SequenceLength','longest');

acc = sum(TestPred == Ytest)./numel(Ytest)

C = confusionmat(TestPred,Ytest);
confusionchart(C)
cm = confusionchart(TestPred,Ytest);
cm.Title='Test Set Confusion Matrix';
cm.RowSummary = 'row-normalized';
cm.ColumnSummary = 'column-normalized';

figure;
%Train İşlemi
miniBatchSize = 27;
TrainPred = classify(net,Xtrain, ...
    'MiniBatchSize',miniBatchSize, ...
    'SequenceLength','longest');

acc = sum(TrainPred == Ytrain)./numel(Ytrain)

C = confusionmat(TrainPred,Ytrain);
confusionchart(C)
cm = confusionchart(TrainPred,Ytrain);
cm.Title='Train Set Confusion Matrix';
cm.RowSummary = 'row-normalized';
cm.ColumnSummary = 'column-normalized';



stats=confusionmatStats(TestPred,Ytest);
mean(stats.accuracy)
mean(stats.precision)
mean(stats.recall)
mean(stats.Fscore)
