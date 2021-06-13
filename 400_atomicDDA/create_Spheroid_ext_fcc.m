function [r, r_on] = create_Spheroid_ext_fcc(long_axis,short_axis, spacing)
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
    
    fprintf('Building a %.2fnm x %.2fnm spheroid with...',l_space(end),s_space(end));

    
    %% Determine extended abc space in hex grid
    % some constants
    sin60 = sind(60);
    yPos = 0.288675134594;
    zPos = 0.816496580927;
    
    % set abc coordinates (in hex grid) to zero
    a_min = 0; a_max = 0;
    b_min = 0; b_max = 0;
    c_min = 0; c_max = 0;
    
    % obtain max/min hex abc coordinates
    i = 1;
    for c = s_space
        for b = s_space
            for a = l_space
                x = 1.0*a +   0.5*b +  0.5*c;                
                y = 0.0*a + sin60*b + yPos*c;
                z = 0.0*a +   0.0*b + zPos*c;
                if ( (x-x0)^2/(r_long^2) + ((y-y0)^2 + (z-z0)^2)/(r_short^2) ) <=1
                    if a < a_min
                        a_min = a;
                    end
                    if a > a_max
                        a_max = a;
                    end
                    if b < b_min
                        b_min = b;
                    end
                    if b > b_max
                        b_max = b;
                    end
                    if c < c_min
                        c_min = c;
                    end
                    if c > c_max
                        c_max = c;
                    end
                    i = i+1;
                end
            end
        end
    end
    
    % Calc extended abc space
    a_delta = (a_max-a_min)/spacing;
    b_delta = (b_max-b_min)/spacing;
    c_delta = (c_max-c_min)/spacing; 
    
    a_space = (-a_delta:a_delta)*spacing;
    b_space = (-b_delta:b_delta)*spacing;
    c_space = (-c_delta:c_delta)*spacing;
    
    N = length(a_space)*length(b_space)*length(c_space);

    
    %% Create extended space and list of active dipoles       
    r = double(zeros(N,3));
    r_on = logical(false(N,1));
    
    i = 1;
    for c = c_space
        for b = b_space
            for a = a_space
                x = 1.0*a +   0.5*b +  0.5*c;                
                y = 0.0*a + sin60*b + yPos*c;
                z = 0.0*a +   0.0*b + zPos*c;
                r( i, :) = [x y z];
                if ( (x-x0)^2/(r_long^2) + ((y-y0)^2 + (z-z0)^2)/(r_short^2) ) <=1
                    r_on(i) = true;
                else
                    r_on(i) = false;
                end
                i = i+1;             
            end
        end
    end
       
    fprintf('\b\b\b %d grid points and %d dipoles\n', N,sum(r_on));
end