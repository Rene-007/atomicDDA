function [r, inside, N, M] = create_Plate_atomic(r_atoms, Boost, plane, pos, h_range, v_range, text)
%%  Creates a plate of pixels of a given size
%   r_atoms ...positions off all atoms
%   Boost   ...boosting the atoms a bit to prevent artifacts (hotspots) -- the ideal value is 2/sqrt(3) ~ 1.1547
%   range1 ...all x coordinates
%   range2 ...all y coordinates
%   z_pos   ...the z position of the plate
%   r       ...coordinates of all grid positions
%   inside  ...indices where the grid lies inside the geometry
%   text    ...optional additional text

    if nargin < 7
        text = 'a';
    end

    d_Au = 0.40782;         % diameter of a gold atom in nm
    radius = Boost*d_Au/2;
   
    fprintf('Building %s plate...',text);
    tic
    
    if plane == "xy" || plane == "z"
        [X,Y] = ndgrid(h_range,v_range);
        [M,N] = size(X);
        Z = reshape(pos*ones(N*M,1),M,N);
    end
    if plane == "xz" || plane == "y"
        [X,Z] = ndgrid(h_range,v_range);
        [M,N] = size(X);
        Y = reshape(pos*ones(N*M,1),M,N);    
    end
    if plane == "yz" || plane == "z"
        [Y,Z] = ndgrid(h_range,v_range);
        [M,N] = size(Y);
        X = reshape(pos*ones(N*M,1),M,N);    
    end

    r = [reshape(X',[],1) reshape(Y',[],1) reshape(Z',[],1)];
  
    

    % fast counting along x -- (standard) in most cases more memory efficient(pictures are often wider than tall)
    % fast counting along y -- just uncomment the next line
%     X = X'; Y=Y';

    % mark all pixels that are inside atoms
    
    % CPU code
%     isInside = zeros(M,N);
%     for i = 1:length(r_atoms)
%         isInside = isInside + ((X - r_atoms(i,1)).^2 + (Y - r_atoms(i,2)).^2 + (Z - r_atoms(i,3)).^2 <= radius.^2);
%     end

    % GPU code (Much faster!)
    isInside = gpuArray(zeros(M,N));
    X = gpuArray(X);
    Y = gpuArray(Y);
    Z = gpuArray(Z);
    r_atoms = gpuArray(r_atoms);
    for i = 1:M
        buffer = single(((X(i,:) - r_atoms(:,1)).^2 + (Y(i,:) - r_atoms(:,2)).^2 + (Z(i,:) - r_atoms(:,3)).^2 <= radius.^2));
        isInside(i,:) = vecnorm(buffer,2,1);
    end
    isInside = gather(isInside);
    
    % make a mask of the correct dimension
    inside = logical(reshape(isInside',1,[]));

    fprintf('\b\b\b consisting of %d pixels with %d being inside atoms in %.3fs.\n', length(inside),sum(inside),toc);
    
end