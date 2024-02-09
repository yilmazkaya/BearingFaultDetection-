clear all;
load('ECGData.mat');


dt=tumdata(1,1:end-1);
a=lbp(dt,4);

