function [r,r_on] = fill_Space_simple(Geometry, Lattice, a_space, b_space, c_space)
%%  Fill space with dipoles and check for atoms
%   r    -> all grid points (coordinates)
%   r_on -> true if inside geometry (=> dipole)

    % first determine size for preallocating the arrays
    N = length(a_space)*length(b_space)*length(c_space)*Lattice.layerNumber;
 
    % Max and Min extention of the parameter space
    % Needed for making a cube-shaped lattice space
    % xMax = Lattice.xyz(a_space(end),0,0,0);    xMax = xMax(1);   % for Lattice_ABC_Dir_Y
    % xMax = Lattice.xyz(a_space(end)+1,0,0,0);  xMax = xMax(1);   % for Lattice_ABC_Dir_XY
    % xMin = Lattice.xyz(a_space(1),0,0,0);      xMin = xMin(1);
    % yMax = Lattice.xyz(0,b_space(end),0,0);    yMax = yMax(2);
    % yMin = Lattice.xyz(0,b_space(1),0,0);      yMin = yMin(2); 
  
    
    %% Create extended space and list of active dipoles       
    r = double(zeros(N,3));
    r_on = logical(false(N,1));

   
    % fill the arrays  
    % the order is very important for getting the convolution work properly
    % Lattice_ABC_Dir_Y & Lattice_ABC_Dir_XY_rot:  c-a-b-d 
    % Lattice_ABC_Dir_XY & Lattice_ABC_Dir_Y_rot:  c-b-a-d

    
    fprintf('layer    ');    
    i = 0;

    for c = c_space
        fprintf('\b\b\b\b%4d',c);
        for a = a_space
            for b = b_space              
                for d = 0:Lattice.layerNumber-1
                    
                    % get lattice position
                    Pos = Lattice.xyz(a,b,c,d);
                    
                    % optional: move lattice space into a cubic shape
                    % Pos(1) = mod( (Pos(1)-xMin) , (xMax-xMin) ) + xMin;
                    % Pos(2) = mod( (Pos(2)-yMin) , (yMax-yMin) ) + yMin;
                    
                    % upgrade index and vector of positions
                    i = i+1;
                    r( i, :) = Pos;
                    
                    % check if dipoles are in body
                    if Lattice.okay(a,b,c,d)
                    % if mod(stackBuff(c+stackCenter),Lattice.layerNumber) == d   % quick version
                        if Geometry.fun(Pos) <= 1    
                            r_on(i) = true;
                        end
                    end

                    
                end
            end
        end
    end
    
    fprintf('\b\b\b\b\b\b\b\b\b');  

end