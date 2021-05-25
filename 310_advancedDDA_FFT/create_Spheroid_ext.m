function [r, r_on] = create_Spheroid_ext(long_axis,short_axis, spacing)
%% Creating the coordinates of a spheroid for a given diameter and spacing with an extended grid
%  (distance between the dipoles).
    
    %% General parameters
    % center of particle
    x0 = 0;
    y0 = 0;
    z0 = 0;
    
    % radii
    r_long = long_axis /2;
    r_short = short_axis /2;
    
    
    %% Calc size of the extended space
    % needed to guarantee that we go through zero
    l_range = 0:spacing:r_long;
    s_range = 0:spacing:r_short;
       
    l_space = -2*l_range(end):spacing:2*l_range(end);          % factor 2 just to be safe
    s_space = -2*s_range(end):spacing:2*s_range(end);          % to not miss any dipole interaction

    N = length(l_space) * length(s_space) * length(s_space);  
    fprintf('Building a %gnm x %gnm spheroid with %d grid points...',l_space(end),s_space(end),N);
    
    
    %% Create extended space (list of a grid positions)
    r = double(zeros(N,3));
    i = 1;
    for z = s_space
        for y = s_space
            for x = l_space
                r( i, :) = [x y z];
                i = i+1;
            end
        end
    end  

    %% Create dipoles (list of all active grid positions)
    r_on = logical(false(N,1));  
    i = 1;
    for z = s_space
        for y = s_space
            for x = l_space
                if ( (x-x0)^2/(r_long^2) + ((y-y0)^2 + (z-z0)^2)/(r_short^2) ) <= 1
                    r_on(i) = true;
                else
                    r_on(i) = false;
                end
                i = i+1;
            end
        end
    end
    
    fprintf('\b\b\b and %d dipoles\n', sum(r_on));
end