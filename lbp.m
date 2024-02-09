function [binmap]=lbp(data,komsuluk)
%% örnek kullaným
% data = wgn(100,1,0);
% data=data';
% komsuluk=4;
% [a,b]=vectmap(data,komsuluk)
%%
binlist=[];
binmap=[];

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
    
    binlist(i,:)=(kon>dat);
    
end

    b=bi2de(binlist);
    count=zeros(1,256);
    for k=1:256
    count(k)=length(find(b==(k-1)));
    end

binmap=count;

end



   

