clear all; clc;
load("veriseti2.mat");
plot(tumdata(1,1:60));
tumdata(1,19:27)
sinyal=tumdata(1,1:end-1);
[a1,a2,a3,a4,a5,a6,a7,a8,a9,a10]=fraktallbpresim(sinyal,4);

subplot(5,1,1);
plot(a1);
subplot(5,1,2);
plot(a2);
subplot(5,1,3);
plot(a3);
subplot(5,1,4);
plot(a4);




figure;
subplot(5,1,1);
plot(a6);
subplot(5,1,2);
plot(a7);
subplot(5,1,3);
plot(a8);
subplot(5,1,4);
plot(a9);
subplot(5,1,5);
plot(a10);

figure;
subplot(4,1,1);
plot(tumdata(1,1:end-1));
subplot(4,1,2);
plot(tumdata(481,1:end-1));
subplot(4,1,3);
plot(tumdata(961,1:end-1));
subplot(4,1,4);
plot(tumdata(1441,1:end-1));


clear all;
clc;
load("basarilar.mat");
subplot(2,2,1);
plot(metrics(:,1));
hold on;
plot(metrics(:,2));

subplot(2,2,2);
plot(metrics(:,3));
hold on;
plot(metrics(:,4));

subplot(2,2,3);
plot(metrics(:,5));
hold on;
plot(metrics(:,6));

subplot(2,2,4);
plot(metrics(:,7));
hold on;
plot(metrics(:,8));
