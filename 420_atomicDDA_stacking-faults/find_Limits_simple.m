function [lim_abc,lim_xyz] = find_Limits_simple(Geometry, Lattice)
%%  Find the limits of the lattice for the given geometry

    % set min/max values to zero;
    lim_abc = zeros(6,1);
    lim_xyz = zeros(6,3);

    % get max extension along the principle axis in lattice coordinates
    LatMin = floor(Lattice.limits(Geometry.min));
    LatMax = ceil(Lattice.limits(Geometry.max));
    
    % search for extrema
    for c = LatMin(3):LatMax(3) 
        for b = LatMin(2):LatMax(2) 
            for a = LatMin(1):LatMax(1)
                pos = Lattice.xyz(a,b,c,0);       
                if Geometry.fun(pos) <= 1    % check if dipole is in body
                    % update abc limits
                    lim_abc(1) = min( lim_abc(1), a );
                    lim_abc(2) = max( lim_abc(2), a );
                    lim_abc(3) = min( lim_abc(3), b );
                    lim_abc(4) = max( lim_abc(4), b );
                    lim_abc(5) = min( lim_abc(5), c );
                    lim_abc(6) = max( lim_abc(6), c );   
                    % update xyz limits
                    if pos(1) > lim_xyz(1,1)
                        lim_xyz(1,:) = pos;
                    end
                    if pos(1) < lim_xyz(2,1)
                        lim_xyz(2,:) = pos;
                    end
                    if pos(2) > lim_xyz(3,2)
                        lim_xyz(3,:) = pos;
                    end
                    if pos(2) < lim_xyz(4,2)
                        lim_xyz(4,:) = pos;
                    end
                    if pos(3) > lim_xyz(5,3)
                        lim_xyz(5,:) = pos;
                    end
                    if pos(3) < lim_xyz(6,3)
                        lim_xyz(6,:) = pos;
                    end
                end
            end
        end
    end
    
end