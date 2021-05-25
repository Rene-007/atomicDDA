function [Ex,Ey,Ez] = E_grid_slow(r0,P,Exci,r_grid,N,M)
%% Calculates the E field on a grid. 
%  r0    ... positions of the dipoles (Lx3)
%  P     ... associated polaristions (3*L)
%  Exci  ... excitation
%  r_grid... coordinates of all pixel positions 
%  N/M   ... dimension of the pixel grid

    k = Exci.k;
    r = r0/Exci.wav;

    x = reshape(r_grid(:,1)/Exci.wav,N,M);
    y = reshape(r_grid(:,2)/Exci.wav,N,M);
    z = reshape(r_grid(:,3)/Exci.wav,N,M);
    
    Ex = double(zeros(N,M));  
    Ey = double(zeros(N,M));  
    Ez = double(zeros(N,M));  
    
    for i=1:N
        for j=1:M
            pos = [x(i,j) y(i,j) z(i,j)];
            buffer = E_pixel(k,r,P,pos);
            Ex(i,j) = buffer(1);
            Ey(i,j) = buffer(2);
            Ez(i,j) = buffer(3);
        end
    end
    
    Ex = reshape(Ex, N*M,1);
    Ey = reshape(Ey, N*M,1);
    Ez = reshape(Ez, N*M,1);
end