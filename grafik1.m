clear all;
clc;

veri=load('veriseti3.mat');
veri=veri.tumdata;
subplot(4,1,1);
plot(veri(1,1:1000))

subplot(4,1,2);
plot(veri(481,1:1000))


subplot(4,1,3);
plot(veri(961,1:1000))


subplot(4,1,4);
plot(veri(1441,1:1000))





