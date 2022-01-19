function r = channel(a,sigmaSquare)
%CHANNEL add AWGN with variance N0/2 to all elements
% Input: a: transmitted data
%        SNR: [dB]
%        Eb:
% Output: r: received data (r = a + w)

w = sigmaSquare * randn(1, length(a));
r = a + w;
end

