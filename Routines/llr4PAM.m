function L = llr4PAM(r,sigmaSquare,s1,s0)
%LLR4PAM calculate the LLR
% Input: r: data
%        sigmaSquare: N0/2
%        s1: vector containing the constellation points or symbols which the bit concerned is 1
%        s0: vector containing the constellation points or symbols which the bit concerned is 0
% Output: L: LLR

L = log( exp((-(r-s1(1)).^2)/(2*sigmaSquare)) + exp((-(r-s1(2)).^2)/(2*sigmaSquare)) )...
  - log( exp((-(r-s0(1)).^2)/(2*sigmaSquare)) + exp((-(r-s0(2)).^2)/(2*sigmaSquare)) );

end

