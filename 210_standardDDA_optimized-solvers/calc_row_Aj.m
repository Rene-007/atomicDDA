function Aj = calc_row_Aj(k,r,j)
%% Calculates a row up to the diagonal (position j) of the matrix. 
%  As a "row" consists of 3x3 Green's tensors elements we obtain 3jx3
%  elements. Equations are modeled after Schmehl 1997 but in cgs.
%
%  Notation: Schmehl et al. JOSA A 14, 3026 (1997)


    %% Some pre-computations    
    r_ij_vec = repmat(r(j,:),j,1) - r(1:j,:);       % distance vector       (dim: jx3)
    r_ij = vecnorm(r_ij_vec,2,2);                   % resulting distances   (dim: jx1)

    rt_ij = r_ij_vec(:,:)./r_ij;                    % normalized vector     (dim: jx3)
    rt_ij(j,:) = 0;                                 % remove NaNs

    C     = - k^2 * exp(1i*k*r_ij)./r_ij;                   C(j) = 0;      %(dim: jx1)
    beta  =  (1 -   (k*r_ij).^-2 +   1i*(k*r_ij).^-1);      beta(j) = 0;   %(dim: jx1)
    gamma = -(1 - 3*(k*r_ij).^-2 + 3*1i*(k*r_ij).^-1);      gamma(j) = 0;  %(dim: jx1)

    
    %% Allocating and filling the row array
    Aj = zeros(3*j,3);                              % Doing the same allocation trick as for A makes things
                                                    % slower, probably because Aj has no fixed length and
                                                    % dealing with this (Aj -> Aj(1:3J)) creates more overhead
                                                    % than what can be gained.

    % x row
    Aj(1:3:3*j,1) = C.*(gamma.*rt_ij(:,1).*rt_ij(:,1) + beta);              
    Aj(2:3:3*j,1) = C.*(gamma.*rt_ij(:,1).*rt_ij(:,2)       );
    Aj(3:3:3*j,1) = C.*(gamma.*rt_ij(:,1).*rt_ij(:,3)       );
    % y row
    Aj(1:3:3*j,2) = Aj(2:3:3*j,1);                  % Aj(1:3:3*j,2) = C.*(gamma.*rt_ij(:,2).*rt_ij(:,1));
    Aj(2:3:3*j,2) = C.*(gamma.*rt_ij(:,2).*rt_ij(:,2) + beta);
    Aj(3:3:3*j,2) = C.*(gamma.*rt_ij(:,2).*rt_ij(:,3)       );
    % z row
    Aj(1:3:3*j,3) = Aj(3:3:3*j,1);                  % Aj(1:3:3*j,3) = C.*(gamma.*rt_ij(:,3).*rt_ij(:,1));
    Aj(2:3:3*j,3) = Aj(3:3:3*j,2);                  % Aj(2:3:3*j,3) = C.*(gamma.*rt_ij(:,3).*rt_ij(:,2));
    Aj(3:3:3*j,3) = C.*(gamma.*rt_ij(:,3).*rt_ij(:,3) + beta);

    
    % Note, due to the symmetry of the matrix, unrolling is quicker than 
    % nicely looping over all elements as one can so assign 
    % e.g. Aj(1:3:3*j,2) = Aj(2:3:3*j,1). 
    % Directly multiplying each element with "C" is also quicker.
    
end