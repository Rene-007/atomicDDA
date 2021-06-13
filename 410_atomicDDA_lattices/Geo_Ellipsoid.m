function geo = Geo_Ellipsoid(r0,l_x,l_y,l_z)
%%  Definition of a ellipsoid
%   r0      ... center of the spheroid
%   l_x/y/z ... length x/y/z axis 

    axes = [l_x, l_y, l_z];              

    geo.name = "ellipsoid";
    geo.max = axes/2;            
    geo.min = -axes/2;            
    geo.fun = @(r)( Geo_Ellipsoid_Fun(r, r0, axes) );

end