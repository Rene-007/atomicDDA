function fftA = create_fftA(k,r)
%% Setting up a row of the circularized interaction matix A and directly returning its FFT.
%  The individual elements are calculated after Schmehl 1997 -- Appendix 3

    N = size(r,1);      
    center = floor(N/2) + 1;                        % the center point of our geometry definition
                                                    % (Not the center of the particle!)                                                   
                                                    % it is very importat get that right in order
                                                    % to get the convolution to work 
                                                  

    %% Some pre-computations      
    r_center = repmat(r(center,:),N,1);             % center position replicated as a matrix
    r_all = r([center:N, 1:center-1],:);            % all the other vectors in a circulant arrangement
    r_ij_vec = r_center - r_all;                    % distance vector       (dim: Nx3)
    r_ij = vecnorm(r_ij_vec,2,2);                   % resulting distances   (dim: Nx1)
    rt_ij = r_ij_vec(:,:)./r_ij;                    % normalized vector     (dim: Nx3)

    C     = - k^2 * exp(1i*k*r_ij)./r_ij;                                 % (dim: Nx1)
    beta  =  (1 -   (k.*r_ij).^-2 +   1i*(k.*r_ij).^-1);                  % (dim: Nx1)
    gamma = -(1 - 3*(k*r_ij).^-2 + 3*1i*(k*r_ij).^-1);                    % (dim: Nx1)

    
    %% Allocating and filling the row array

    %normal layout
    Aj = zeros(1*N,9);                                % allocate the memory 

    % x row
    Aj(1:N,1) = C.*(gamma.*rt_ij(:,1).*rt_ij(:,1) + beta);              
    Aj(1:N,2) = C.*(gamma.*rt_ij(:,1).*rt_ij(:,2)       );
    Aj(1:N,3) = C.*(gamma.*rt_ij(:,1).*rt_ij(:,3)       );
    % y row
    Aj(1:N,4) = Aj(1:N,2);
    Aj(1:N,5) = C.*(gamma.*rt_ij(:,2).*rt_ij(:,2) + beta);
    Aj(1:N,6) = C.*(gamma.*rt_ij(:,2).*rt_ij(:,3)       );
    % z row
    Aj(1:N,7) = Aj(1:N,3);
    Aj(1:N,8) = Aj(1:N,6);
    Aj(1:N,9) = C.*(gamma.*rt_ij(:,3).*rt_ij(:,3) + beta);   
       
    Aj(isnan(Aj))=0;                                % removing all NaN which occured due do division by zero
    
    
    %% Final Fast Fourier Transformation
    fftA = fft(Aj);
 
end



