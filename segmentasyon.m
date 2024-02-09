
clear all;

tumdata=[];

filelist=dir('veriseti\Dataset1\*.mat');

for kk=1:length(filelist)

dosya=load(strcat('veriseti\Dataset1\',filelist(kk).name));      
raw_sig=dosya.data;
K = 1000;                          % length of each segment
N = ceil(numel(raw_sig) / K);     % number of segments
M = N * K;                        % length of signal we need
rdm_seg = raw_sig;                % copy
rdm_seg(M) = 0;                   % pad with zeros
rdm_seg = reshape(rdm_seg, K, N); % reshape, each column contains K consecutive samples

segment=rdm_seg';

tumdata=[tumdata;segment(1:end-1,:)];
end

targets=[];
for i=1:5
    for j=1:480
  targets=[targets;i];
    end
end
tumdata=[tumdata targets];


