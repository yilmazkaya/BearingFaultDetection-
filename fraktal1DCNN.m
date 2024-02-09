% clear all;
% clc;
% load ('ECGData.mat');
% hucreler={};
% for ii=1:size(tumdata,1)
% dt=tumdata(ii,1:end-1);
% [l1 l2 l3 l4 l5,l6,l7,l8,l9,l10] =klbp(dt,4);
% X=[l6;l7;l8;l9;l10];
% hucreler{ii}=num2cell(X);
% end
% hucreler=hucreler';
% hucreler=[hucreler num2cell(tumdata(:,end))];

load ("huc.mat");
hucreler=huc;
[m,n] = size(hucreler) ;
P = 0.50 ;
idx = randperm(m)  ;
XT = hucreler(idx(1:round(P*m)),:) ; 
XTs = hucreler(idx(round(P*m)+1:end),:) ;

XTrain=XT(:,1);
YTrain=categorical(cell2mat(XT(:,2)));
XTest=XTs(:,1);
YTest=categorical(cell2mat(XTs(:,2)));

%1DCNN*********************************************************

classes = categories(YTrain);
numClasses = numel(classes)
numFeatures = size(XTrain{1},1);
filterSize = 3;
numFilters = 32;
layers = [ ...
 sequenceInputLayer(numFeatures)
 convolution1dLayer(filterSize,numFilters,Padding="causal")
 reluLayer
 layerNormalizationLayer
 convolution1dLayer(filterSize,2*numFilters,Padding="causal")
 reluLayer
 layerNormalizationLayer
 globalAveragePooling1dLayer
 fullyConnectedLayer(numClasses)
 softmaxLayer
 classificationLayer];

miniBatchSize = 127;
options = trainingOptions("sgdm", ...
 MiniBatchSize=miniBatchSize, ...
 MaxEpochs=70, ...
 SequencePaddingDirection="left", ...
 ValidationData={XTest,YTest}, ...
 Plots="training-progress", ...
 Verbose=0);

net = trainNetwork(XTrain,YTrain,layers,options);

YPredTrain = classify(net,XTrain, ...
 MiniBatchSize=miniBatchSize, ...
 SequencePaddingDirection="left");
confusionchart(YTrain,YPredTrain,'ColumnSummary','column-normalized',...
 'RowSummary','row-normalized','Title','Confusion Matrix for Train Set with 1D-CNN')
figure
YPredTest = classify(net,XTest, ...
 MiniBatchSize=miniBatchSize, ...
 SequencePaddingDirection="left");
confusionchart(YTest,YPredTest,'ColumnSummary','column-normalized',...
 'RowSummary','row-normalized','Title','Confusion Matrix for Test Set with 1D-CNN')

%1DCNN******************************************************
%GradCam

numChannels = size(huc{1},2);
numObservations = numel(huc(:,1));
figure
tiledlayout(2,2)
for i = 1:4
    nexttile
    stackedplot(huc{i,1},DisplayLabels="Channel "+(1:numChannels));
    title("Observation "+i)
    xlabel("Time Step")
end

numFailuresToShow = 2;
isCorrect = YPredTest =="1" & YTest=="1" ;
idxValidationFailure = find(isCorrect,numFailuresToShow);

for i = 1:numFailuresToShow
    figure
 %   t = tiledlayout(numChannels,1);
    idx = idxValidationFailure(i);
    
    modifiedSignal = XTest{idx};
    modifiedSignal=modifiedSignal';
    importance = gradCAM(net,modifiedSignal,"1");
    for j = 1:numChannels
    nexttile
    plotWithColorGradient(modifiedSignal(j,:),importance');
    ylabel("Channel "+j)
    xlabel("Time Steps")  
        if ~isempty(failureLocationValidation{idx})
            xline(failureLocationValidation{idx}(1),":")
            xline(failureLocationValidation{idx}(end),":")
        end
    end
    title(t,"Grad-CAM: Validation Observation "+idx)

    c = colorbar;
    c.Layout.Tile = "east";
    c.Label.String = "Grad-CAM Importance";
end
