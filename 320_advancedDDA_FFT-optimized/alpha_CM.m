function alpha = alpha_CM(N,n)
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
alpha_CM = 3/(N*4*pi)*(n.^2 - 1)./(n.^2 + 2); 


%% build array of polarizibilities
NoD = length(n);                        % Number of Dipoles
alpha = zeros(3*NoD,1);

% Assume isotropic medium (same polarizability for all directions)
for j = 1:NoD
  alpha(3*(j-1) + 1) = alpha_CM(j);
  alpha(3*(j-1) + 2) = alpha_CM(j);
  alpha(3*(j-1) + 3) = alpha_CM(j);
end
