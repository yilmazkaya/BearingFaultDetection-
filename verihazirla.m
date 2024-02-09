function sonuc=verihazirla(data)
tumdata=data;
hucreler={};
for i=1:size(tumdata,1)
dt=tumdata(i,1:end-1);
[K1,K2,K3,K4,K5,K6,K7,K8,K9,K10]=fraktallbpresim(dt,4);
%K6=lbp(dt,4);
K=[K6; K7; K8; K9; K10];
%K=[K6];
hucreler{i}=K;

end
hucreler=hucreler';

sonuc=hucreler;
end