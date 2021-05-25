function A = create_A(A,k,r)
%% Setting up the interaction matrix A in an optimized way.
%  To save allocation time the old matrix is handed over (as a reference)
%  and as we carefully overwrite everything* it does not need to be
%  initiallized with zeros.

    N = length(r);

    for j=1:N
        J = 3*(j-1);                            % index for the 3x3 Tensors
        Aj = calc_row_Aj(k,r,j);                % calculates a 3jx3 "row" up to the diagonal
        A(1:J+3 ,J+1:J+3) = Aj;                 % fill the lower triangle of the matrix
        A(J+1:J+3 ,1:J+3) = Aj.';               % fill the upper trinagle with the transposed version
    end

    %  *we do not override the main diagonal and its two adjacent diagonals 
    %   (comming from the 3x3 Tensor natur of the matrix) but as they are always zero
    %   and never touched this should be fine   
end



