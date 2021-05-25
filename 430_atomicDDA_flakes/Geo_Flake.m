function geo = Geo_Flake(Flake, Lattice)
%%  Definition of a flake geometry
%   r0      ... center of the spheroid
%   l_long  ... length long axis 
%   l_short ... length short axis 

    geo.name = "flake";
    geo.lattice = Lattice;
    
    % minima
    abc = ijk_to_abcd(min(Flake.extremaIJK));                        
    geo.abc_min = abc;
    geo.min = Lattice.xyz(abc(1), abc(2), abc(3), 0);
    
    % maxima
    abc = ijk_to_abcd(max(Flake.extremaIJK));
    geo.abc_max = abc;
    geo.max = Lattice.xyz(abc(1), abc(2), abc(3), 0);

    geo.fun = @fun;
    
    
    % definition of the coordinate mapping
    function abcd = ijk_to_abcd(ijk)       
        % Lattice_ABC_Dir_XY
        % c = ijk(3);
        % d = mod(stacking.pos(c)-c+1,3);     
        % p = 1/3*(stacking.pos(c) - (c+(d-1)));
        % b = ijk(2) + p;
        % a = ijk(1) - 1/2*(p+(d-1));

        % Lattice_ABC_Dir_Y    
        c = ijk(3);
        d = mod(c-geo.lattice.stacking.pos(c)+1,3);   
        p = 1/3*(geo.lattice.stacking.pos(c) - (c+2*(d-1)));
        b = ijk(2) + p;
        a = ijk(1) - 1/2*(p);
            
        abcd(1) = a;
        abcd(2) = b;
        abcd(3) = c;
        abcd(4) = d;
    end

end