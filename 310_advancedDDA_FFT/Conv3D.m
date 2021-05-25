function [AX] = Conv3D(fftA,X)
%% This is just a helper function for getting the convolution with 3x3 Tensors done easily
%  fftA ... matrix of nine columns [fftA11 fftA12 fftA13 fftA21 ... fftA33]
%  X    ... vector arranged as [Xx1 Xy1 Xz1 Xx2 Xy2 Xz2 Xx3 ...]
%  AX   ... output arranged as [AXx1 AXy1 AXz1 AXx2 AXy2 AXz2 AXx3...]


%% #1 compact version
%     X9 = repmat(reshape(X,3,[]).',1,3);                 % building a [Xx Xy Xz Xx Xy Xz Xx Xy Xz] matrix
%     AX9 = ifft(fftA .* fft(X9));                        % calc overall convolution
% %     AX3 = reshape(sum(reshape(AX9.',3,[])),3,[]).';   % This would give a [AXx AXy AXz] matrix    
%     AX = sum(reshape(AX9.',3,[])).';                    % but we need a [AXx1 AXy1 AXz1 AXx2 AXy2 AXz2 AXx3...] vector


%% #2 clear version -  normal fftA layout
    X3 = reshape(X,3,[]).';
    AXx = ifft(fftA(:,1) .* fft(X3(:,1)) + fftA(:,2) .* fft(X3(:,2)) + fftA(:,3) .* fft(X3(:,3)));
    AXy = ifft(fftA(:,2) .* fft(X3(:,1)) + fftA(:,5) .* fft(X3(:,2)) + fftA(:,6) .* fft(X3(:,3)));
    AXz = ifft(fftA(:,3) .* fft(X3(:,1)) + fftA(:,6) .* fft(X3(:,2)) + fftA(:,9) .* fft(X3(:,3)));
    AX  = reshape([AXx AXy AXz].',[],1);

end