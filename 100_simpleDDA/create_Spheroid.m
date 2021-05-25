function r = create_Spheroid(long_axis,short_axis, spacing)
%% Creating the coordinates of a sphere for a given diameter and spacing 
%  (distance between the dipoles).
    
    r_long = long_axis /2;
    r_short = short_axis /2;
    
    % needed such that we go through zero
    l_range = 0:spacing:r_long;
    s_range = 0:spacing:r_short;
       
    l_space = -l_range(end):spacing:l_range(end);
    s_space = -s_range(end):spacing:s_range(end);
    
    N = length(l_space) * length(s_space) * length(s_space);
    fprintf('Building %gnm x %gnm Spheroid with...',2*l_space(end),2*s_space(end));

    r = double(zeros(N,3));
    x0 = 0;
    y0 = 0;
    z0 = 0;
    
    i = 1;
    for z = s_space
        for y = s_space
            for x = l_space
                if ( (x-x0)^2/(r_long^2) + ((y-y0)^2 + (z-z0)^2)/(r_short^2) ) <= 1
                    r( i, :) = [x y z];
                    i = i+1;
                end
            end
        end
    end
    
    r = r(1:i-1,:);
    
    fprintf(' %d Dipoles.\n', i-1);
  
end