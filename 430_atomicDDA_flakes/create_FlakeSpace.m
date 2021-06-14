function [r, r_on, r_surf, lattice] = create_FlakeSpace(filename)
%%  Create the coordinates of the scene for a give geometry and lattice
%   r    ...coordinates of all dipoles
%   r_on ...coordinates of the atoms (dipoles inside the geometry)
    
%% Some Definitions and Setting up
d_Au = 0.40782; % diameter of a gold atom in nm
spacing = d_Au; % nm

% import flake struct
flake = import_flake(filename);  

% extract stacking from data
stacking = Stacking_Flake(flake);

% --- see: https://en.wikipedia.org/wiki/Close-packing_of_equal_spheres ---
lattice = Lattice_ABC_Dir_Y(spacing,stacking);   % standard lattice for flakes
lattice.stacking = stacking;                     % attach flake stacking to lattice

% build geometry
geometry = Geo_Flake(flake,lattice);


%% Find extrema
fprintf('Importing a %s...',geometry.name);

abc_min = geometry.abc_min;
abc_max = geometry.abc_max;
lim_abc = [abc_min(1),abc_max(1),abc_min(2),abc_max(2),abc_min(3),abc_max(3)];
lim_xyz = flake.extrema;

fprintf('\b\b\b with a size of %.1fnm x %.1fnm x %.1fnm...', lim_xyz(2)-lim_xyz(1), lim_xyz(4)-lim_xyz(3), lim_xyz(6)-lim_xyz(5));


%% Define needed space for FFT (at least twice the size in each dimension)
v = 2;  % expansion factor
a_space = v*lim_abc(1)-1:v*lim_abc(2)+1;
b_space = v*lim_abc(3)-1:v*lim_abc(4)+1;
c_space = v*lim_abc(5)-1:v*lim_abc(6)+1;


%% Generate all dipoles and atoms
tic    
[r, r_on, r_surf] = fill_FlakeSpace(flake, lattice, a_space, b_space, c_space);

fprintf('\b\b\b consisting of %d grid points and %d atoms within %.3fs.\n', length(r_on),sum(r_on),toc);

end