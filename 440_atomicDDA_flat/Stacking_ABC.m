function stacking = Stacking_ABC(stacking_faults,max)
%%  Definition of the stacking

    % define the middle
    stacking.center = ceil((max)/2);
    
    % calc the stacking vector
    shift_i = ones(1,max)'; 
    shift_j = ones(1,max)'; 
    pos = ones(1,max)';
    
    for i = 1:length(stacking_faults)
        shift_j(stacking.center+stacking_faults(i)+1) = -1;
    end

    for i = 2:max
        shift_j(i) = shift_j(i-1)*shift_j(i);
    end

    for i = 1:max
        pos(i) = sum(shift_j(1:i));
        if shift_j(i) == 1 
            shift_i(i) = 0;
        end
    end

    % set stacking
    stacking.vec = pos - pos(stacking.center);
    stacking.shift = shift_j;
           
    % now the transform
    stacking.pos = @(c)( stacking.vec(c+stacking.center) );    
    stacking.shifted = @(c)( shift_i(c+stacking.center) );
    stacking.sign = @(c)( shift_j(c+stacking.center) );

end
