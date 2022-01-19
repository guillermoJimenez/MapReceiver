function L = decoder(code,Lext)
% This routine is updating the probabilities of the vector v  
% Inputs: 'code'  This is either 1 or 2, and specifes which code that is used
%         'Lext'  This is a 1xN vector, where the n:th element is log[Pr{v(n)=1}/Pr{v(n)=0}]
%
% Output: 'L'     This is a 1xN vector, where the n:th element is an updated version of log[Pr{v(n)=1}/Pr{v(n)=0}]

Lext=min(max(Lext,-10),10);
if code==1
    gen=[7;5];
    K=numel(Lext)/2-2;
    blockl=K+2;
elseif code==2
    gen=[1 7;1 3];
    K=numel(Lext)/2-3;
     blockl=K+3;
else
    error('No such code');
end

Tc = codertrellis(gen);
[A1_1,A0_1,A1_2,A0_2] = decodingAforB(Tc);
P=zeros(size(Tc,1),size(Tc,1),blockl);
for n=1:blockl,
    P(:,:,n) = decodinggamma(Tc,Lext(2*n-1),Lext(2*n));
end
for u=1:size(P,3),
    B0_1(:,:,u)=P(:,:,u).*A0_1;
    B0_2(:,:,u)=P(:,:,u).*A0_2;
    B1_1(:,:,u)=P(:,:,u).*A1_1;
    B1_2(:,:,u)=P(:,:,u).*A1_2;
end
f=zeros(size(P,1),1);
b=zeros(size(P,1),1);
f(1)=1;
b(1)=1;
f=[f zeros(size(P,1),size(P,3))];
b=[zeros(size(P,1),size(P,3)) b];

for k=1:blockl,
    f(:,k+1)=P(:,:,k)'*f(:,k);
    f(:,k+1)=f(:,k+1)/sum(f(:,k+1));
end
for k=blockl:-1:1,
    b(:,k)=P(:,:,k)*b(:,k+1);
    b(:,k)=b(:,k)/sum(b(:,k));
end

L1=[];
L2=[];
for n=1:size(P,3),
    if f(:,n)'*B1_1(:,:,n)*b(:,n+1)==0,
        L1=[L1 -5 0];
    elseif f(:,n)'*B0_1(:,:,n)*b(:,n+1)==0,
        L1=[L1 5 0];
    else
        L1=[L1 log(f(:,n)'*B1_1(:,:,n)*b(:,n+1)/(f(:,n)'*B0_1(:,:,n)*b(:,n+1))) 0];
    end
    
    if f(:,n)'*B0_2(:,:,n)*b(:,n+1)==0,
        L2=[L2 0 5];
    elseif f(:,n)'*B1_2(:,:,n)*b(:,n+1)==0,
        L2=[L2 0 -5];
    else
        L2=[L2 0 log(f(:,n)'*B1_2(:,:,n)*b(:,n+1)/(f(:,n)'*B0_2(:,:,n)*b(:,n+1))) ];
    end
    
end
L=L1+L2-Lext;
end

%% sub routines
function gamma = decodinggamma(T,L1,L2)
gamma=zeros(size(T,1),size(T,1));
for i =0:size(T,1)-1,
    gamma(i+1,T(i+1,2)+1)=exp(T(i+1,3)*L1)/(1+exp(L1))*exp(T(i+1,4)*L2)/(1+exp(L2))/2;
    gamma(i+1,T(i+1,5)+1)=exp(T(i+1,6)*L1)/(1+exp(L1))*exp(T(i+1,7)*L2)/(1+exp(L2))/2;
end
end

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

function [A1_1,A0_1,A1_2,A0_2] = decodingAforB(T)
A1_1=zeros(size(T,1),size(T,1));
A0_1=zeros(size(T,1),size(T,1));
A1_2=zeros(size(T,1),size(T,1));
A0_2=zeros(size(T,1),size(T,1));
for i=0:size(T,1)-1,
    for j=0:size(T,1)-1,
        if T(i+1,2)==j,
            
            if T(i+1,3)==0,
                A0_1(i+1,j+1)=1;
            end
            if T(i+1,4)==0,
                A0_2(i+1,j+1)=1;
            end
            if T(i+1,3)==1,
                A1_1(i+1,j+1)=1;
            end
            if T(i+1,4)==1,
                A1_2(i+1,j+1)=1;
            end
            
        end
        if T(i+1,5)==j,
            if T(i+1,6)==0,
                A0_1(i+1,j+1)=1;
            end
            if T(i+1,7)==0,
                A0_2(i+1,j+1)=1;
            end
            if T(i+1,6)==1,
                A1_1(i+1,j+1)=1;
            end
            if T(i+1,7)==1,
                A1_2(i+1,j+1)=1;
            end
        end
    end
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

