function [lim_abc,lim_xyz] = find_Limits(Geometry, Lattice)
%%  Find the limits of the lattice for the given geometry -- new, much faster Version
%
%   lim_abc -> [min(a), max(a), min(b), max(b), min(c), max(c)]
%   lim_xyz -> [max(x)|xyz, min(x)|xyz, max(y)|xyz, min(y)|xyz, max(y)|xyz, min(y)|xyz]


    % get max extension along the principle axis in lattice coordinates
    LatMin = floor(Lattice.limits(Geometry.min));
    LatMax = ceil(Lattice.limits(Geometry.max));
    
    % basic abc space
    a_space = LatMin(1):LatMax(1);
    b_space = LatMin(2):LatMax(2);
    c_space = LatMin(3):LatMax(3); 
    
    % shorthands for the lengths
    Na = length(a_space);
    Nb = length(b_space);
    Nc = length(c_space);
    N  = Na*Nb*Nc;
    
    % calculate all grid positions
    aa = reshape(repmat(a_space,Nb*Nc,1     ),N,1);
    bb = reshape(repmat(b_space,Nc,   Na    ),N,1);
    cc = reshape(repmat(c_space,1,    Na*Nb ),N,1);
    
    r = Lattice.xyz(aa,bb,cc,0);
    insideGeo = (Geometry.fun(r) <= 1);
    pos = r .* insideGeo;

    % limits in abc space
    lim_abc(1) = min( aa .* insideGeo );
    lim_abc(2) = max( aa .* insideGeo );
    lim_abc(3) = min( bb .* insideGeo );
    lim_abc(4) = max( bb .* insideGeo );
    lim_abc(5) = min( cc .* insideGeo );
    lim_abc(6) = max( cc .* insideGeo );

    % limits in xyz space
    % x max/min
    [~,I]=max(pos(:,1));
    lim_xyz(1,:) = pos(I,:);
    [~,I]=min(pos(:,1));
    lim_xyz(2,:) = pos(I,:);
    
    % y max/min
    [~,I]=max(pos(:,2));
    lim_xyz(3,:) = pos(I,:);
    [~,I]=min(pos(:,2));
    lim_xyz(4,:) = pos(I,:);
    
    % z max/min
    [~,I]=max(pos(:,3));
    lim_xyz(5,:) = pos(I,:);
    [~,I]=min(pos(:,3));
    lim_xyz(6,:) = pos(I,:);
    
end