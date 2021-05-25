function alpha = alpha_CM_vec(N,n)
%% Clausius-Mossoti polarizability
%
% Wikipedia (cgs units):
%
% n^2 - 1    4*pi
% -------- = ---- N * alpha_m
% n^2 + 2     3
%
% N is the number of dipoles per unit volume,
% alpha_m the mean polarizability and n the relative refractive index. 


%% calc polarizability of an individual dipole
alpha = 3 ./ (N*4*pi).*(n.^2 - 1)./(n.^2 + 2); 
% alpha = N * 3/(4*pi).*(n.^2 - 1)./(n.^2 + 2); 


