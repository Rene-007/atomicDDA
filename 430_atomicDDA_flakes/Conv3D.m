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
%     X3 = reshape(X,3,[]).';
%     % normal fftAlayout
%     AXx = ifft(fftA(:,1) .* fft(X3(:,1)) + fftA(:,2) .* fft(X3(:,2)) + fftA(:,3) .* fft(X3(:,3)));
%     AXy = ifft(fftA(:,2) .* fft(X3(:,1)) + fftA(:,5) .* fft(X3(:,2)) + fftA(:,6) .* fft(X3(:,3)));
%     AXz = ifft(fftA(:,3) .* fft(X3(:,1)) + fftA(:,6) .* fft(X3(:,2)) + fftA(:,9) .* fft(X3(:,3)));
%     AX  = reshape([AXx AXy AXz].',[],1);


%% #3  version with memory optimized fftA layout
%     X3 = reshape(X,3,[]).';
%     AXx = ifft(fftA(:,1) .* fft(X3(:,1)) + fftA(:,2) .* fft(X3(:,2)) + fftA(:,3) .* fft(X3(:,3)));
%     AXy = ifft(fftA(:,2) .* fft(X3(:,1)) + fftA(:,4) .* fft(X3(:,2)) + fftA(:,5) .* fft(X3(:,3)));
%     AXz = ifft(fftA(:,3) .* fft(X3(:,1)) + fftA(:,5) .* fft(X3(:,2)) + fftA(:,6) .* fft(X3(:,3)));    
%     AX  = reshape([AXx AXy AXz].',[],1);
    

%% #4  version with memory optimized fftA layout and precalculated fftX (30%-50% faster)
    fftX = fft(reshape(X,3,[]).');
    AXx = ifft(fftA(:,1) .* fftX(:,1) + fftA(:,2) .* fftX(:,2) + fftA(:,3) .* fftX(:,3));
    AXy = ifft(fftA(:,2) .* fftX(:,1) + fftA(:,4) .* fftX(:,2) + fftA(:,5) .* fftX(:,3));
    AXz = ifft(fftA(:,3) .* fftX(:,1) + fftA(:,5) .* fftX(:,2) + fftA(:,6) .* fftX(:,3));    
    AX  = reshape([AXx AXy AXz].',[],1);
    
    
%% #4a  optimized arrayfun version of #4 -- additional ~20% faster on a GPU -- !!! but only with the profiler on !!!
%     fftX = fft( reshape(X,3,[]).' );
%     AXx = ifft( arrayfun(@mulPlus, fftA(:,1), fftX(:,1), fftA(:,2), fftX(:,2), fftA(:,3), fftX(:,3)) );
%     AXy = ifft( arrayfun(@mulPlus, fftA(:,2), fftX(:,1), fftA(:,4), fftX(:,2), fftA(:,5), fftX(:,3)) );
%     AXz = ifft( arrayfun(@mulPlus, fftA(:,3), fftX(:,1), fftA(:,5), fftX(:,2), fftA(:,6), fftX(:,3)) );    
%     AX  = reshape([AXx AXy AXz].',[],1);
%     
%     % the following function together with arrayfun leads to an element-wise evaluation of
%     % the whole expression instead of evaluating the vector multiplications first and adding  
%     % them together afterwards, i.e. memory allocactions and memory transfer are reduced
%     function all = mulPlus(a1,b1,a2,b2,a3,b3)
%         all = a1.*b1 + a2.*b2 + a3.*b3;
%     end

%% #5  version with memory optimized fftA layout and precalculated fftX1...ffX3 (depending on the CPU/GPU: much faster or equally fast)
%     X3 = reshape(X,3,[]).';
%     fftX1 = fft(X3(:,1));
%     fftX2 = fft(X3(:,2));
%     fftX3 = fft(X3(:,3));
%     AXx = ifft(fftA(:,1) .* fftX1 + fftA(:,2) .* fftX2 + fftA(:,3) .* fftX3);
%     AXy = ifft(fftA(:,2) .* fftX1 + fftA(:,4) .* fftX2 + fftA(:,5) .* fftX3);
%     AXz = ifft(fftA(:,3) .* fftX1 + fftA(:,5) .* fftX2 + fftA(:,6) .* fftX3);    
%     AX  = reshape([AXx AXy AXz].',[],1);


%% #5z  version with memory optimized fftA layout and precalculated fftX1...ffX3 (depending on the CPU/GPU: much faster or equally fast)
%     X3 = reshape(X,3,[]).';
%     fftX1 = fft(X3(:,1));
%     fftX2 = fft(X3(:,2));
%     fftX3 = fft(X3(:,3));
%     buf = arrayfun(@mulPlus, fftA(:,1), fftX1, fftA(:,2), fftX2, fftA(:,3), fftX3);
%     AXx = ifft(buf);
%     buf = arrayfun(@mulPlus, fftA(:,2), fftX1, fftA(:,4), fftX2, fftA(:,5), fftX3);
%     AXy = ifft(buf);
%     buf = arrayfun(@mulPlus, fftA(:,3), fftX1, fftA(:,5), fftX2, fftA(:,6), fftX3);
%     AXz = ifft(buf);  
%     AX  = reshape([AXx AXy AXz].',[],1);
%     
%     function all = mulPlus(a1,b1,a2,b2,a3,b3)
%         all = a1.*b1 + a2.*b2 + a3.*b3;
%     end    
    
%% #6  version with memory optimized fftA layout and precalculated ddtX1...fffX3 and splitted fftA
%   -> Conv3D a tiny bit faster but the whole routine slower (probably due to required additional garbadge collection)
%     X3 = reshape(X,3,[]).';
%     fftX1 = fft(X3(:,1));
%     fftX2 = fft(X3(:,2));
%     fftX3 = fft(X3(:,3));
%     fftA1 = fftA(:,1);
%     fftA2 = fftA(:,2);
%     fftA3 = fftA(:,3);
%     fftA4 = fftA(:,4);
%     fftA5 = fftA(:,5);
%     fftA6 = fftA(:,6);
%     AXx = ifft(fftA1 .* fftX1 + fftA2 .* fftX2 + fftA3 .* fftX3);
%     AXy = ifft(fftA2 .* fftX1 + fftA4 .* fftX2 + fftA5 .* fftX3);
%     AXz = ifft(fftA3 .* fftX1 + fftA5 .* fftX2 + fftA6 .* fftX3);    
%     AX  = reshape([AXx AXy AXz].',[],1);

end