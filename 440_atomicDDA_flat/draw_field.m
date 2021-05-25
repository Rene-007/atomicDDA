function handle = draw_field(num,r0,P,Exci,fn,mask,plane,pos,grid_size)
%% Calculates the E field on a grid. 
%   num ... plate number
%   r0  ... positions of all atoms
%   P   ... associated polaristions 
%   Exci... excitation
%   fn  ... scaling function (eg @lin or @log)
%   mask... dipoles have a singularity and need to be masked
%   size... of the plate 

    % create plate with pixels
    d_Au = 0.40782;                                                        % diameter of a gold atom in nm
    zPos = 0.816496580927;
    d_AuX = d_Au;                                                          % lattice distance in x direction
    d_AuY = d_Au*sind(60);                                                 % lattice distance in y direction
    d_AuZ = d_Au*zPos;                                                     % lattice distance in z direction

    if plane == "xy" || plane == "z"
        X = grid_size(1,:);
        Y = grid_size(2,:);
        Z = [0 0];
        h_range = (ceil(X(1)/d_AuX):X(2):ceil(X(3)/d_AuX))*d_AuX;
        v_range = (ceil(Y(1)/d_AuY):Y(2):ceil(Y(3)/d_AuY))*d_AuY;
    end
    if plane == "xz" || plane == "y"
        X = grid_size(1,:);
        Y = [0 0];
        Z = grid_size(2,:);
        h_range = (ceil(X(1)/d_AuX):X(2):ceil(X(3)/d_AuX))*d_AuX;
        v_range = (ceil(Z(1)/d_AuZ):Z(2):ceil(Z(3)/d_AuZ))*d_AuZ;
    end
    if plane == "yz" || plane == "x"
        X = [0 0];
        Y = grid_size(1,:);
        Z = grid_size(2,:);
        h_range = (ceil(Y(1)/d_AuY):Y(2):ceil(Y(3)/d_AuY))*d_AuY;
        v_range = (ceil(Z(1)/d_AuZ):Z(2):ceil(Z(3)/d_AuZ))*d_AuZ;
    end
    [r_plate,inside,N,M] = create_Plate_atomic(r0, mask, plane, pos ,h_range, v_range, num); % Parameters: pos of all atoms, boost, h_range, v_range, z_pos, (optional) text

    % calc the field
    tic
    fprintf('   -> calculating the fields...');
    % [Ex, Ey, Ez] = E_grid_slow(r0, P, Exci, r_plate, N, M);              % slow:   pixel by pixel
    % [Ex, Ey, Ez] = E_grid_cpu(r0, P, Exci, r_plate, N, M);               % medium: line by line -- cpu
    [Ex, Ey, Ez] = E_grid_gpu(r0, P, Exci, r_plate, N, M);                 % fast:   line by line -- gpu
    fprintf('\b\b\b\n   -> this took %.3fs\n', toc);

    % post processing
    E_inc = Exci.Einc3(r_plate);                                           % excitation field
    E_norm = fn(vecnorm((E_inc - [Ex Ey Ez]),2,2));                        % scaled overall field
    E_norm(inside) = 0;                                                    % switch of pixels inside atoms (singularities!)

    % plotting
    xp = reshape(r_plate(:,1),N,M) - X(2)/4;
    yp = reshape(r_plate(:,2),N,M) - Y(2)/4;
    zp = reshape(r_plate(:,3),N,M) - Z(2)/4;
    Ep = reshape(E_norm,N,M);

    if plane == "xy" || plane == "z"
        h_pos = xp;
        v_pos = yp;
    end
    if plane == "xz" || plane == "y"
        h_pos = xp;
        v_pos = zp;
    end
    if plane == "yz" || plane == "x"
        h_pos = yp;
        v_pos = zp;
    end
    
    handle = pcolor(h_pos,v_pos,Ep); hold on;
%     handle = surface(xp,yp,zp,Ep); hold on;
    handle.EdgeColor = 'none';

end