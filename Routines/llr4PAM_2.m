function L = llr4PAM_2(r,sigmaSquare,s1,s0,Pr)
%LLR4PAM_2 calculate the LLR taking into account the Pr's
% Input: r: data
%        sigmaSquare: N0/2
%        s1: vector containing the constellation points or symbols which the bit concerned is 1
%        s0: vector containing the constellation points or symbols which the bit concerned is 0
%        Pr:
% Output: L: LLR

L = log( exp((-(r-s1(1)).^2)/(2*sigmaSquare))*Pr(1,1) + exp((-(r-s1(2)).^2)/(2*sigmaSquare))*Pr(1,2) )...
  - log( exp((-(r-s0(1)).^2)/(2*sigmaSquare))*Pr(2,1) + exp((-(r-s0(2)).^2)/(2*sigmaSquare))*Pr(2,2) );


end