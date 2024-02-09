function [LBPbinmap,LBPMin,LBPMax,LBPDifMax,LBPDifMin,HistLBPbinmap,HistLBPMin,HistLBPMax,HistLBPDifMax,HistLBPDifMin]=fraktallbp(data,komsuluk)
D1=[];
D2=[];
D3=[];
D4=[];
D5=[];
D6=[];
D7=[];
D8=[];
D9=[];
binmap1=[];
binmap2=[];
binmap3=[];
binmap4=[];
binmap5=[];
binmap6=[];
binmap7=[];
binmap8=[];
binmap9=[];
l=length(data);

for i=1:l
    kon(1:2*komsuluk)=data(i);
    dat=zeros(1,2*komsuluk);
    if (i<=komsuluk)
        if (i>1)
            dat((komsuluk-i+2):komsuluk)=data(1:(i-1));
        end
        dat((komsuluk+1):2*komsuluk)=data((i+1):(i+komsuluk));
    elseif ((i+komsuluk)>l)
        dat(1:komsuluk)=data((i-komsuluk):(i-1));
        if (i<l)
            dat((komsuluk+1):(l+komsuluk-i))=data((i+1):l);
        end
    elseif ((i>komsuluk) && i<=(l-komsuluk))
        dat(1:komsuluk)=data((i-komsuluk):(i-1));
        dat((komsuluk+1):2*komsuluk)=data((i+1):(i+komsuluk));
    end
    
      C=[dat(1:4) kon(1) dat(5:8)];

      D1(i,:)=C(1)>C(2:9);
      D2(i,:)=C(2)>[C(1) C(3:9)];
      D3(i,:)=C(3)>[C(1:2) C(4:9)];
      D4(i,:)=C(4)>[C(1:3) C(5:9)];
      D5(i,:)=C(5)>[C(1:4) C(6:9)];
      D6(i,:)=C(6)>[C(1:5) C(7:9)];
      D7(i,:)=C(7)>[C(1:6) C(8:9)];
      D8(i,:)=C(8)>[C(1:7) C(9)];
      D9(i,:)=C(9)>[C(1:8)];
end

 binmap1=bi2de(D1)';
 binmap2=bi2de(D2)';
 binmap3=bi2de(D3)';
 binmap4=bi2de(D4)';
 binmap5=bi2de(D5)';
 binmap6=bi2de(D6)';
 binmap7=bi2de(D7)';
 binmap8=bi2de(D8)';
 binmap9=bi2de(D9)';

 binmap=[binmap1;binmap2;binmap3;binmap4;binmap6;binmap7;binmap8;binmap9];
 LbpMax=max(binmap);
 LbpMin=min(binmap);
 LdifMin=binmap5-LbpMin;
 LdifMax=LbpMax-binmap5;
 
 LBPbinmap=binmap5;
 LBPMin=LbpMin;
 LBPMax=LbpMax;
 LBPDifMax=LdifMax;
 LBPDifMin=LdifMin;
 
 HistLBPbinmap=hist(binmap5,256);
 HistLBPMin=hist(LBPMin,256);
 HistLBPMax=hist(LBPMax,256);
 HistLBPDifMax=hist(LBPDifMax,256);
 HistLBPDifMin=hist(LBPDifMin,256);
end




   

