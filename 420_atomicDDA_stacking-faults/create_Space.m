function [r, r_on] = create_Space(Geometry, Lattice)
%%  Create the coordinates of the scene for a give geometry and lattice
%   r    ...coordinates of all grid points
%   r_on ...list of all dipoles
    
    tic
    fprintf('Building a %s...',Geometry.name);
        
    % find extrema
%     [lim_abc,lim_xyz] = find_Limits_simple(Geometry, Lattice);                         
    [lim_abc,lim_xyz] = find_Limits(Geometry, Lattice);                             % new, much faster version 
 
    fprintf('\b\b\b with a size of %.1fnm x %.1fnm x %.1fnm...', lim_xyz(1,1)-lim_xyz(2,1), lim_xyz(3,2)-lim_xyz(4,2), lim_xyz(5,3)-lim_xyz(6,3));
    % fprintf('\b\b\b with a box size of %d x %d x %d dipoles...', lim_abc(2)-lim_abc(1), lim_abc(4)-lim_abc(3), lim_abc(6)-lim_abc(5));
    
    % define needed space for FFT (at least twice the size in each dimension)
    v = 2;                                                                          % expansion factor
    a_space = v*lim_abc(1)-1:v*lim_abc(2)+1;
    b_space = v*lim_abc(3)-1:v*lim_abc(4)+1;
    c_space = v*lim_abc(5)-1:v*lim_abc(6)+1;
    
    % [r, r_on] = fill_Space_simple(Geometry, Lattice, a_space, b_space, c_space);  % the more didactical but slow version
    [r, r_on] = fill_Space(Geometry, Lattice, a_space, b_space, c_space);           % the very fast version
       
    fprintf('\b\b\b consisting of %d grid points and %d dipoles within %.1fs.\n', length(r_on),sum(r_on),toc);

end