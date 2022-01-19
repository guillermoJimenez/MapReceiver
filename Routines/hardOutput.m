function [uHat, errors, ratio] = hardOutput(r,M,c,state,bitmap,u)
%HARDOUTPUT Hard-output decoding
% Input: r: received data
%        M: number of symbols
%        c: convolutional code (1 or 2)
%        state: 
%        bitmap: constellation setup ('gray', 'bin')
%        u: orignal information data
% Output: uHat:
%         errors:
%         ratio:

vp = reshape(de2bi(pamdemod(r,M,0,bitmap),'left-msb').',1,[]);
vHat = randdeintrlv(vp, state);
uHat = out_decoder(c,10*(vHat-0.5));
[errors, ratio] = biterr(u,uHat);
end

