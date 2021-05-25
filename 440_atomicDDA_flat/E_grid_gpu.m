function [Ex,Ey,Ez] = E_grid_gpu(r0,P,Exci,r_grid,N,M)
%% Calculates the E field on a grid. 
%  r0    ... positions of the dipoles (Lx3)
%  P     ... associated polaristions (3*L)
%  Exci  ... excitation
%  r_grid... coordinates of all pixel positions 
%  N/M   ... dimension of the pixel grid

    k = Exci.k;

    r = gpuArray(single(r0/Exci.wav));
    P = gpuArray(single(P));
    x = gpuArray(single(reshape(r_grid(:,1)/Exci.wav,N,M)));
    y = gpuArray(single(reshape(r_grid(:,2)/Exci.wav,N,M)));
    z = gpuArray(single(reshape(r_grid(:,3)/Exci.wav,N,M)));

    Ex = gpuArray(single(zeros(N*M,1)));  
    Ey = gpuArray(single(zeros(N*M,1)));  
    Ez = gpuArray(single(zeros(N*M,1)));  

    [L,~] = size(r);
    
    PxN = reshape(repmat(P,N,1).', 3, []).';        % Polarization [[Px1 Py1 Pz1]...[PxL PyL PzL]] repeated N times (dim P: L*3x1)                         
    RxN = repmat(r,N,1);                            % Dipole Pos.  [[rx1 ry1 rz1]...[rxL ryL rzL]] repeated N times (dim r: Lx3)
    
    for i=1:M
        fprintf('%4d/%4d',i,M);
        xr = reshape(repmat(x(:,i)',L,1),1,[])';    % x Pixel Line [x1 x2 ... xN] repeated L times
        yr = reshape(repmat(y(:,i)',L,1),1,[])';    % y Pixel Line [y1 y2 ... yN] repeated L times
        zr = reshape(repmat(z(:,i)',L,1),1,[])';    % z Pixel Line [z1 z2 ... zN] repeated L times

        r_ij_vec = [xr yr zr] - RxN;                % distance vector       (dim: L*Nx3)
        r_ij = vecnorm(r_ij_vec,2,2);                   % resulting distances   (dim: L*Nx1)
        rt_ij = r_ij_vec(:,:)./r_ij;                % normalized vector     (dim: L*Nx3)
                
        C     = - k^2 * exp(1i*k*r_ij)./r_ij;                              %(dim: L*Nx1)
        beta  =  (1 -   (k*r_ij).^-2 +   1i*(k*r_ij).^-1);                 %(dim: L*Nx1)
        gamma = -(1 - 3*(k*r_ij).^-2 + 3*1i*(k*r_ij).^-1);                 %(dim: L*Nx1)


        %% Calc E(i,:)                                      

        % x row
        buffer =          C.*(gamma.*rt_ij(:,1).*rt_ij(:,1) + beta) .* PxN(:,1);              
        buffer = buffer + C.*(gamma.*rt_ij(:,1).*rt_ij(:,2)       ) .* PxN(:,2);
        buffer = buffer + C.*(gamma.*rt_ij(:,1).*rt_ij(:,3)       ) .* PxN(:,3);            %(dim: L*Nx1)
        Ex((1:N)+(i-1)*N) = sum(reshape(buffer,L,N),1);                    % sum(dim: LxN)-> (dim: Nx1) 

        % y row
        buffer =          C.*(gamma.*rt_ij(:,2).*rt_ij(:,1)       ) .* PxN(:,1);
        buffer = buffer + C.*(gamma.*rt_ij(:,2).*rt_ij(:,2) + beta) .* PxN(:,2);
        buffer = buffer + C.*(gamma.*rt_ij(:,2).*rt_ij(:,3)       ) .* PxN(:,3);            %(dim: L*Nx1)
        Ey((1:N)+(i-1)*N) = sum(reshape(buffer,L,N),1);                    % sum(dim: LxN)-> (dim: Nx1)
        
        % z row
        buffer =          C.*(gamma.*rt_ij(:,3).*rt_ij(:,1)       ) .* PxN(:,1);
        buffer = buffer + C.*(gamma.*rt_ij(:,3).*rt_ij(:,2)       ) .* PxN(:,2);
        buffer = buffer + C.*(gamma.*rt_ij(:,3).*rt_ij(:,3) + beta) .* PxN(:,3);            %(dim: L*Nx1)   
        Ez((1:N)+(i-1)*N) = sum(reshape(buffer,L,N),1);                    % sum(dim: LxN)-> (dim: Nx1)
 
        fprintf('\b\b\b\b\b\b\b\b\b');
    end
    
    Ex = gather(Ex);
    Ey = gather(Ey);
    Ez = gather(Ez);
end