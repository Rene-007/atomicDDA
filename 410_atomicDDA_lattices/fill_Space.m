function [r,r_on] = fill_Space(Geometry, Lattice, a_space, b_space, c_space)
%%  Fill space with dipoles and check for atoms
%   r    -> all grid points (coordinates)
%   r_on -> true if inside geometry (=> dipole)

    % first determine size for preallocating the arrays
    N = length(a_space)*length(b_space)*length(c_space);

  
    %% Create extended space and list of active dipoles       
    r = double(zeros(N,3));
    r_on = logical(false(N,1));
    
    i = 0;
    for c = c_space 
        for b = b_space  
            for a = a_space
                Pos = Lattice.xyz(a,b,c);
                i = i+1;
                r( i, :) = Pos;
                if Geometry.fun(Pos) <= 1     % check if dipole is in body
                    r_on(i) = true;
                end
            end
        end
    end
    
    % cut out all unused grid points
    r = r(1:i,:);
    r_on = r_on(1:i);

end