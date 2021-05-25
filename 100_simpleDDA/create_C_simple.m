function C = create_C_simple(k, r, alpha)
%% Setting up the interaction matrix C
%  Notation: Schmehl et al. JOSA C 14, 3026 (1997)
%
% k     ...vacuum k vector
% r     ...positions of all dipoles
% alpha ...polarizability of every dipole

N = length(r(:,1));                         % (dim: Nx3)
C = single(zeros(3*N,3*N));

% matrix C consists of NxN tensors each of 3x3 dimension
% iteration over these tensors
for i=1:N
  for j=1:N
    I = 3*(i-1);                            % row index for the tensors
    J = 3*(j-1);                            % column index for the tensors

    if i == j                               % if on main diagonal
      C(I+1,J+1) = 1./alpha(I+1);           % fill tensor diagonal with 1/alpha values
      C(I+2,J+2) = 1./alpha(I+2);           % (remaining parts of Tensor stay zero)
      C(I+3,J+3) = 1./alpha(I+3);

    else                                    % if not on main diagonal
      % some pre-computations
      r_ij_vec = r(i,:) - r(j,:);           % distance vector
      r_ij = norm(r_ij_vec);                % resulting distance        
      rt_ij = (r_ij_vec)/r_ij;              % normalized vector

      c     = - k^2 * exp(1i*k*r_ij)./r_ij;                  
      beta  =  (1 -   (k*r_ij).^-2 +   1i*(k*r_ij).^-1);      
      gamma = -(1 - 3*(k*r_ij).^-2 + 3*1i*(k*r_ij).^-1);    

      % fill local tensor
      % x row
      Aij(1,1) = c.*(gamma.*rt_ij(1).*rt_ij(:,1) + beta);              
      Aij(2,1) = c.*(gamma.*rt_ij(:,1).*rt_ij(:,2)       );
      Aij(3,1) = c.*(gamma.*rt_ij(:,1).*rt_ij(:,3)       );
      % y row
      Aij(1,2) = Aij(2,1);                  % Aij(1,2) = c.*(gamma.*rt_ij(:,2).*rt_ij(:,1));
      Aij(2,2) = c.*(gamma.*rt_ij(:,2).*rt_ij(:,2) + beta);
      Aij(3,2) = c.*(gamma.*rt_ij(:,2).*rt_ij(:,3)       );
      % z row
      Aij(1,3) = Aij(3,1);                  % Aij(1,3) = c.*(gamma.*rt_ij(:,3).*rt_ij(:,1));
      Aij(2,3) = Aij(3,2);                  % Aij(2,3) = c.*(gamma.*rt_ij(:,3).*rt_ij(:,2));
      Aij(3,3) = c.*(gamma.*rt_ij(:,3).*rt_ij(:,3) + beta); 
      
      % write tensor to matrix
      C(I+1:I+3,J+1:J+3) = Aij;
    end
    
  end
end
