function [uHat, errors, ratio] = iteration(r,sigmaSquare,nIter,c,state,bitmap,u)
%ITERATION iterative decoding
% Input: r: data
%        sigmaSquare:
%        nIter:
%        c: convolutional code (1 or 2)
%        state:
%        bitmap: constellation setup ('gray', 'bin')
%        u: orignal information data
% Output: uHat:
%         errors:
%         ratio:

if strcmp(bitmap,'gray')
    B1 = [1 3; -1 -3]; %[s2 s3; s1 s0]
    B2 = [1 -1; 3 -3]; %[s2 s1; s3 s0]
else
    B1 = [1 3; -1 -3]; %[s2 s3; s1 s0]
    B2 = [-1 3; -3 1]; %[s1 s3; s0 s2]  
end

n=0;
while n<=nIter
   if n==0
       
        % ZERO ITERATION
        L_1p = llr4PAM(r,sigmaSquare,B1(1,:),B1(2,:));
        L_2p = llr4PAM(r,sigmaSquare,B2(1,:),B2(2,:));
        L_p = reshape([L_1p' L_2p']', 1, []);

        L = randdeintrlv(L_p,state);
        %L0 = L;
        [L_pnew, Pr] = feedback(L,length(r),c,state);    

   else
          
        L_1p=zeros(1,length(r));
        L_2p=zeros(1,length(r));
        for i=1:length(r)
            if strcmp(bitmap,'gray')
               %GRAY
               PrB1 = [Pr{1,i}(2,2) Pr{1,i}(2,1); Pr{1,i}(1,2) Pr{1,i}(1,1)];
               PrB2 = [Pr{1,i}(2,2) Pr{1,i}(1,2); Pr{1,i}(2,1) Pr{1,i}(1,1)];
            else
               %NON-GRAY
               PrB1 = [Pr{1,i}(2,1) Pr{1,i}(2,2); Pr{1,i}(1,2) Pr{1,i}(1,1)];
               PrB2 = [Pr{1,i}(1,2) Pr{1,i}(2,2); Pr{1,i}(1,1) Pr{1,i}(2,1)];
            end
            L_1p(i) = llr4PAM_2(r(i),sigmaSquare,B1(1,:),B1(2,:),PrB1);
            L_2p(i) = llr4PAM_2(r(i),sigmaSquare,B2(1,:),B2(2,:),PrB2);     
        end

        L_p = reshape([L_1p' L_2p']', 1, []);  
        L_p = L_p - L_pnew;
        L = randdeintrlv(L_p,state);
        [L_pnew, Pr] = feedback(L,length(r),c,state); 
   end
   n=n+1;    
end

% uHat0 = out_decoder(c,L0);
% [errors_0iter, ratio_0iter] = biterr(u,uHat0);

uHat = out_decoder(c,L);
[errors, ratio] = biterr(u,uHat);

end

