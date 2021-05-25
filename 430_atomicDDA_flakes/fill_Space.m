function [r,r_on] = fill_Space(Geometry, Lattice, a_space, b_space, c_space)
%%  Fill space with dipoles and check for atoms -- quick Version
%   r    -> all grid points (coordinates)
%   r_on -> true if inside geometry (=> dipole)
 
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
    
    % build list of dipoles
    onLattice = (mod(Lattice.stackBuff(cc+Lattice.stackCenter),Nd).' == dd);
    insideGeo = (Geometry.fun(r) <= 1);

    r_on = logical(onLattice.*insideGeo);

end