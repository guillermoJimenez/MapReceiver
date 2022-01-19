function [uHat, errors, ratio] = softOutput(r,sigmaSquare,c,state,bitmap,u)
%SOFTOUTPUT soft-output decoding
% Input: r: data
%        sigmaSquare:
%        c:
%        state:
%        B1: matrix containing the vectors s1 and s0 which has:
%            1st row -> s1: symbols with FIRST bit 1; 2nd row -> s0: symbols with FIRST bit 0
%        B2: matrix containing the vectors s1 and s0 which has:
%            1st row -> s1: symbols with SECOND bit 1; 2nd row -> s0: symbols with SECOND bit 0
%        c: convolutional code (1 or 2)
%        bitmap: constellation setup ('gray', 'bin')
%        u: orignal information data
% Output: uHat:
%         errors:
%         ratio:

if strcmp(bitmap,'gray')
    B1 = [1 3; -1 -3];
    B2 = [1 -1; 3 -3];
else
    B1 = [1 3; -1 -3];
    B2 = [-1 3;-3 1];    
end
L_1p = llr4PAM(r,sigmaSquare,B1(1,:),B1(2,:));
L_2p = llr4PAM(r,sigmaSquare,B2(1,:),B2(2,:));

L_p = reshape([L_1p' L_2p']', 1, []);
L = randdeintrlv(L_p, state);

uHat = out_decoder(c, L);
[errors, ratio] = biterr(u,uHat);
end

