function a = transmitter(u,M,c,state,bitmap)
%TRANSMITTER return the transmitted signal
% Input: u: data
%        M: number of symbols
%        c: convolutional code (1 or 2)
%        state: seed for the interleave (default = 0)
%        bitmap: constellation setup ('gray', 'bin')
% Output: a: transmitted data

% Use a class of error correcting codes named convolutional codes. (Code1 :N = 2(K + 2), Code2 : N = 2(K + 3))
v = encoder(u, c);

% The next step is to randomly scramble (a.k.a. interleave or permute) the encoded sequence v
vIntrlv = randintrlv(v, state);

% Group the bits in groups of log2(M) adjacent bits. In total we must have N/log2(M) such groups.
groupBits = reshape(vIntrlv,log2(M),[])';

% For each group, map the bits into a message m. There are M possible messages.
m=bi2de(groupBits,'left-msb')';

% For each message, map the message into a constellation point representing the signal space representation of the message.
a = pammod(m,M,0,bitmap);

end

