function C = C_abs(k, E0, P, alpha)
%% Absorption cross section

% dot product in Matlab: first value is complex conjungated
% C = 4*pi*k/norm(E0)^2 * ( imag(dot(P./alpha,P)) - 2/3*k^3*norm(P)^2 );      % After Draine 1988

C = 4*pi*k/norm(E0)^2 * ( imag(dot(P./alpha,P)) );                        % After Purcell and Pennypacker 1973

