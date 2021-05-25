function geo = Geo_Spheroid(r0,l_long,l_short)
%%  Definition of a spheroid
%   r0      ... center of the spheroid
%   l_long  ... length long axis 
%   l_short ... length short axis 

    axes = [l_long, l_short, l_short];               % x-Pol

    geo.name = "spheroid";
    geo.max = axes/2;            
    geo.min = -axes/2;            
    geo.fun = @(r)( Geo_Ellipsoid_Fun(r, r0, axes) );

end