function [r,r_on,r_surf] = fill_FlakeSpace(Flake, Lattice, a_space, b_space, c_space)
%%  Fill space with dipoles and check for atoms
%   r    -> all positions
%   r_on -> true if inside geometry (=> atom)

    % also define the d_space
    d_space = 0:Lattice.layerNumber-1;

    % shorthands for the lengths
    Na = length(a_space);
    Nb = length(b_space);
    Nc = length(c_space);
    Nd = length(d_space);
    N  = Na*Nb*Nc*Nd;
    
    % the counting order is very important for getting the convolution work properly
    % Lattice_ABC_Dir_Y & Lattice_ABC_Dir_XY_rot:  c-a-b-d 
    % Lattice_ABC_Dir_XY & Lattice_ABC_Dir_Y_rot:  c-b-a-d
         
    % calculate all grid positions
    cc = reshape(repmat(c_space,Na*Nb*Nd,1       ),N,1);
    aa = reshape(repmat(a_space,Nb*Nd,   Nc      ),N,1);
    bb = reshape(repmat(b_space,Nd,      Nc*Na   ),N,1);
    dd = reshape(repmat(d_space,1,       Nc*Na*Nb),N,1);
    
    r = Lattice.xyz(aa,bb,cc,dd);
    

    %% Build list of dipoles
    r_on = logical(false(N,1));
    r_surf = logical(false(N,1));
    
    pos_min = [a_space(1), b_space(1), c_space(1), 0];
    
    for i = 1:(length(Flake.positions))
        pos = Flake.positions(i,1:4);
        pos = pos-pos_min;
        
        % c-a-b-d 
        d_sum = pos(4)+1;
        b_sum = pos(2)*Nd;
        a_sum = pos(1)*Nb*Nd;
        c_sum = pos(3)*Na*Nb*Nd;
        
        % c-b-a-d 
        % d_sum = pos(4)+1;
        % a_sum = pos(1)*Nd;
        % b_sum = pos(2)*Na*Nd;
        % c_sum = pos(3)*Na*Nb*Nd;
        
        index = a_sum + b_sum + c_sum + d_sum;       
        r_on(index) = true;
        if Flake.positions(i,5)
            r_surf(index) = true;
        end
    end
     
end