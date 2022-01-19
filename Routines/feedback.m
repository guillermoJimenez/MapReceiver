function [L_pnew,Pr] = feedback(L,len,c,state)
%FEEDBACK Summary of this function goes here
% Input: L: 
%        len:
%        c: convolutional code (1 or 2)
%        state:
% Output: L_pnew:
%         Pr:

% NEXT ITERATION
L_new = decoder(c,L);
L_pnew = randintrlv(L_new,state);
L_res = reshape(L_pnew,2,[]);

q1 = L_res(1,:);
q2 = L_res(2,:);

Pr = cell(1,len);
Pr1_0 = 1./(1+exp(q1));
Pr1_1 = exp(q1)./(1+exp(q1));
Pr2_0 = 1./(1+exp(q2));
Pr2_1 = exp(q2)./(1+exp(q2));

for i=1:len
    Pr{i}=[Pr1_0(i); Pr1_1(i)].*[Pr2_0(i) Pr2_1(i)];
end
end

