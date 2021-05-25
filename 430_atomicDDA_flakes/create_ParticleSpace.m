function [r, r_on, lattice] = create_ParticleSpace()
%%  Create the coordinates of the scene for a give geometry and lattice
%   r    ...coordinates of all dipoles
%   r_on ...coordinates of the atoms (dipoles inside the geometry)
    
%% Definition of the particle
d_Au = 0.40782; % diameter of a gold atom in nm
spacing = d_Au; % nm

% stacking = Stacking_ABC([0],200);
stacking = Stacking_ABC([-3,4],200);
% stacking = Stacking_ABC([-40],200);

% --- see: https://en.wikipedia.org/wiki/Close-packing_of_equal_spheres ---
% lattice = Lattice_FCC(spacing);                % face centered cubic packing
% lattice = Lattice_FCC_Rot(spacing);            % face centered cubic packing rotated by 90 degree around z axis
lattice = Lattice_ABC_Dir_Y(spacing,stacking);   % standard lattice for flakes
% lattice = Lattice_ABC_Dir_Y_rot(spacing,stacking);
% lattice = Lattice_ABC_Dir_XY(spacing,stacking);
% lattice = Lattice_ABC_Dir_XY_rot(spacing,stacking);

% geometry = Geo_Ellipsoid([0 0 0], 5,5,5);      % Parameters (center, l_x, l_y, l_z)
geometry = Geo_Spheroid([0 0 0], 10,5);        % Parameters (center, long_axis, short_axis)
% geometry = Geo_SpheroidPair([0 0 0], 30,15,2);   % Parameters (center, long_axis, short_axis, gap)


%% Find extrema
fprintf('Building a %s...',geometry.name);
[lim_abc,lim_xyz] = find_Limits(geometry, lattice);   
fprintf('\b\b\b with a size of %.1fnm x %.1fnm x %.1fnm...', lim_xyz(1,1)-lim_xyz(2,1), lim_xyz(3,2)-lim_xyz(4,2), lim_xyz(5,3)-lim_xyz(6,3));
%     fprintf('\b\b\b with a box size of %d x %d x %d dipoles...', lim_abc(2)-lim_abc(1), lim_abc(4)-lim_abc(3), lim_abc(6)-lim_abc(5));


%% Define needed space for FFT (at least twice the size in each dimension)
v = 2;  % expansion factor
a_space = v*lim_abc(1)-1:v*lim_abc(2)+1;
b_space = v*lim_abc(3)-1:v*lim_abc(4)+1; 
c_space = v*lim_abc(5)-1:v*lim_abc(6)+1;


%% Generate all grid points and dipols/atoms
tic
[r, r_on] = fill_Space(geometry, lattice, a_space, b_space, c_space);
% [r, r_on] = fill_Space_simple(geometry, lattice, a_space, b_space, c_space);

fprintf('\b\b\b consisting of %d grid points and %d atoms within %.3fs.\n', length(r_on),sum(r_on),toc);

end