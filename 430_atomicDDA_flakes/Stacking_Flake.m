function stacking = flake_stacking(flake)
%%  Definition of the stacking

    % define the middle
    stacking.center = flake.center(3);
    stacking.vec = flake.stacking.pos - 1;
    stacking.shift = flake.stacking.shift_j;
           
    % now the transform
    stacking.pos = @(c)( stacking.vec(c+stacking.center) );    
    stacking.shifted = @(c)( shift_i(c+stacking.center) );
    stacking.sign = @(c)( shift_j(c+stacking.center) );

end
