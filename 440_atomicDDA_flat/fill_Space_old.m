function [r,r_on] = fill_Space(Geometry, Lattice, a_space, b_space, c_space)
%%  Fill space with dipoles and check for atoms
%   r    -> all positions
%   r_on -> true if inside geometry (=> atom)

    % first determine size and allocate the arrays
    N = length(a_space)*length(b_space)*length(c_space)*Lattice.layerNumber;
    r = double(zeros(N,3));
    r_on = logical(false(N,1));
    
%     % Max and Min extention of the parameter space
%     % Needed for making the lattice space of cubic shape
%     xMax = Lattice.xyz(a_space(end),0,0,0);    xMax = xMax(1);   % for LatticeB
% %     xMax = Lattice.xyz(a_space(end)+1,0,0,0);  xMax = xMax(1);  % for LatticeBC
%     xMin = Lattice.xyz(a_space(1),0,0,0);      xMin = xMin(1);
%     yMax = Lattice.xyz(0,b_space(end),0,0);    yMax = yMax(2);
%     yMin = Lattice.xyz(0,b_space(1),0,0);      yMin = yMin(2);   
   
    % fill the arrays  
    % the order is very important for getting the convolution work properly
    % LatticeB & LatticeAB_rot:  c-a-b-d 
    % LatticeAB & LatticeB_rot:  c-b-a-d
    
    % buffer Lattice properties for quicker iteration
    stackBuff = Lattice.stackBuff;
    stackCenter = Lattice.stackCenter;
    
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
%                     Pos(1) = mod( (Pos(1)-xMin) , (xMax-xMin) ) + xMin;
%                     Pos(2) = mod( (Pos(2)-yMin) , (yMax-yMin) ) + yMin;
                    
                    % upgrade index and vector of positions
                    i = i+1;
                    r( i, :) = Pos;
                    
                    % check if dipoles are in body
                    if Lattice.okay(a,b,c,d)
%                     if mod(stackBuff(c+stackCenter),Lattice.layerNumber) == d   % quick version           
                        if Geometry.fun(Pos)    
                            r_on(i) = true;
                        end
                    end  
                    
                end
            end
        end
    end
    
    fprintf('\b\b\b\b\b\b\b\b\b');
    
    r = r(1:i,:);
    r_on = r_on(1:i);

end