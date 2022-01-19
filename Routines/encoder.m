function v = encoder(u,code)
% This routines encodes the sequence u, assumed to be a row-vector of 0/1 into the sequence v. 
% The input 'Code' is either 1 or 2, and specifies the convolutional code used.

if code==1
    taps=[1 1 1; 1 0 1];
    mem=2;
elseif code==2
    taps=[1 1 1 1;1 0 1 1];
    mem=3;
else
    error('No such code');
end
u=[u zeros(1,mem)];
init1=zeros(1,mem);
v=zeros(1,2*length(u));
for o=1:length(u)
    v((o-1)*2+1:o*2)=[mod((taps(1,:)*[u(o) init1]'),2) mod((taps(2,:)*[u(o) init1]'),2)];
    init1(2:end)=init1(1:end-1);
    init1(1)=u(o);
end
end
