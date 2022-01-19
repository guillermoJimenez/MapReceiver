function berEst = ber(EbNoVec,k,c,state,bitmap,decoding,nIter,d,f)
%BER Summary of this function goes here
% Input: EbNoVec:
%        k:
%        c: convolutional code (1 or 2)
%        state:
%        bitmap: constellation setup ('gray', 'bin')
%        decoding:
%        nIter:
%        d:
%        f:
% Output: berEst:

berEst = zeros(1, length(EbNoVec));

for n = 1:length(EbNoVec)
    numErrs = 0;
    numBits = 0;
    
    while numErrs < 100000 && numBits < 1e6
        % Generate binary data and convert to symbols
        u = randi([0 1], 1, k);
        a = transmitter(u,4,c,state,bitmap);
        Eb = 5; % Es = Eb
        ebno = 10^(EbNoVec(n)/10); % Linear
        sigmaSquare = 1/2 * Eb/ebno;
        r = channel(a,sigmaSquare);
        if strcmp(decoding,'hard')
            [~, e, ~] = hardOutput(r,4,c,state,bitmap,u);
        elseif strcmp(decoding,'soft')
            [~, e, ~] = softOutput(r,sigmaSquare,c,state,bitmap,u);
        else
            [~, e, ~] = iteration(r,sigmaSquare,nIter,c,state,bitmap,u);
        end
               
        numErrs = numErrs + e;
        numBits = numBits + length(u);
    end
    
    % Estimate the BER
    berEst(n) = numErrs/numBits;
    
    % Wait bar and displaying the progress time
    waitbar((n+d*11)/(48*length(EbNoVec)),f,'Loading your data');
    fprintf('%d of %d\n',(n+d*11),48*length(EbNoVec));
    %toc
end
end

