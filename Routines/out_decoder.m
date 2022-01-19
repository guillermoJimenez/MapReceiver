function L = out_decoder(code,Lext)
% This routine is a decoder for a convolutional code.
% Inputs: 'code'  This is either 1 or 2, and specifes which code that is used
%         'Lext'  This is a 1xN vector, where the n:th element is log[Pr{v(n)=1}/Pr{v(n)=0}]
%
% Output: 'L'     This is a 1xK vector of 1/0 of the decoded vector u


if code==1
    gen=[7;5];
elseif code==2
    gen=[1 7;1 3];
else
    error('No such code');
end
blockl=numel(Lext)/2;
Tc = codertrellis(gen);

  [A1,A0] = decodingAforA_1(Tc);
  P=zeros(size(Tc,1),size(Tc,1)*blockl);
  B1=zeros(size(Tc,1),size(Tc,1)*blockl);
  B0=zeros(size(Tc,1),size(Tc,1)*blockl);
  for n=1:blockl,
    P(:,(n-1)*size(Tc,1)+1:n*size(Tc,1)) = decodinggamma_1(Tc,Lext(2*n-1),Lext(2*n));
  end
  
  for n=1:blockl,
    B1(:,(n-1)*size(Tc,1)+1:n*size(Tc,1))=P(:,(n-1)*size(Tc,1)+1:n*size(Tc,1)).*A1;
    B0(:,(n-1)*size(Tc,1)+1:n*size(Tc,1))=P(:,(n-1)*size(Tc,1)+1:n*size(Tc,1)).*A0;
  end
  f=zeros(size(P,1),1);
  b=zeros(size(P,1),1);
  f(1)=1;
  b(1)=1;
  f=[f zeros(size(P,1),blockl)];
  b=[zeros(size(P,1),blockl) b];
  
  for k=1:blockl,
    f(:,k+1)=P(:,(k-1)*size(Tc,1)+1:k*size(Tc,1))'*f(:,k);
    f(:,k+1)=f(:,k+1)/sum(f(:,k+1));
  end
  for k=blockl:-1:1,
    b(:,k)=P(:,(k-1)*size(Tc,1)+1:k*size(Tc,1))*b(:,k+1);
    b(:,k)=b(:,k)/sum(b(:,k));
  end
  L2=zeros(1,blockl);
  
  
  for n=1:blockl,
    
    x=f(:,n)'*B0(:,(n-1)*size(Tc,1)+1:n*size(Tc,1))*b(:,n+1);
    y=f(:,n)'*B1(:,(n-1)*size(Tc,1)+1:n*size(Tc,1))*b(:,n+1);
    if x==0,
      L2(n) =5;
    elseif y==0,
      L2(n) =-5;
    else
     L2(n)=  log(y/x) ;
    end
    
  end
  if code==1
  L=L2(1:end-2);
  else
  L=L2(1:end-3);
  end    
  L=round(.5*sign(L)+.5);
end

%%
function T = codertrellis(gen)
format compact
T=[];
m=findmem(gen);
taps=generatortaps(gen);


nbrst=2^m;

for state=0:1:nbrst-1,
    
    binst=fliplr(bitget(state,1:m));
    
    %----- nolla in -----
    
    nextstbin=[0 binst(1:end-1)];
    nextst0=sum(bitset(0,find(fliplr(nextstbin))));
    brlabel01=mod(sum(bitand([0 binst],taps(1,:))),2);
    brlabel02=mod(sum(bitand([0 binst],taps(2,:))),2);
    
    %----- etta in -----
    
    nextstbin=[1 binst(1:end-1)];
    nextst1=sum(bitset(0,find(fliplr(nextstbin))));
    brlabel11=mod(sum(bitand([1 binst],taps(1,:))),2);
    brlabel12=mod(sum(bitand([1 binst],taps(2,:))),2);
    
    T=[T;state nextst0 brlabel01 brlabel02  nextst1  brlabel11 brlabel12];
end

end



function m = findmem(gen)
ma=max(gen(:,1));
if bitget(ma,3)==1,
    m=3+3*(size(gen,2)-1);
elseif bitget(ma,2)==1,
    m=2+3*(size(gen,2)-1);
else
    m=1+3*(size(gen,2)-1);
end
m=m-1;
end

function taps=generatortaps(gen);
taps=[];
for k=1:size(gen,2),
    taps=[taps [bitget(gen(1,k),3) bitget(gen(1,k),2) ...
        bitget(gen(1,k),1);bitget(gen(2,k),3) bitget(gen(2,k),2) ...
        bitget(gen(2,k),1)] ];
end
taps=taps(:,3*size(gen,2)-(findmem(gen)+1)+1:end);
end




function [A1,A0] = decodingAforA_1(T)

A1=zeros(size(T,1),size(T,1));
A0=zeros(size(T,1),size(T,1));
for i=0:size(T,1)-1,
  for j=0:size(T,1)-1,
    if T(i+1,2)==j,
      A0(i+1,j+1)=1;
    end
    if T(i+1,5)==j,
      A1(i+1,j+1)=1;
    end
  end
end
end

function gamma = decodinggamma_1(T,L1,L2)

gamma=zeros(size(T,1),size(T,1));


for i =0:size(T,1)-1,
  for j =0:size(T,1)-1,
    if T(i+1,2)==j,
      gamma(i+1,j+1)=exp(T(i+1,3)*L1)/(1+exp(L1))*exp(T(i+1,4)*L2)/(1+exp(L2))/2;
    elseif T(i+1,5)==j,
      gamma(i+1,j+1)=exp(T(i+1,6)*L1)/(1+exp(L1))*exp(T(i+1,7)*L2)/(1+exp(L2))/2;
    end
  end
end
end