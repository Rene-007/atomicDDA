function C = C_ext(k, E0, Ei, P)
%% Just the extinctin cross section

C = 4*pi*k/norm(E0)^2 * sum( imag(conj(Ei).*P) );
