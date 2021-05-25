function geo = Geo_SpheroidPair(r0,l_long,l_short,gap)
%%  Definition of a spheroid pair
%   r0      ... center of the spheroid pair
%   l_long  ... length long axis of each spheroid
%   l_short ... length short axis of each spheroid 
%   gap     ... gap between the two

    r1 = r0 + [+(l_long + gap)/2 0 0];              % center spheroid 1
    r2 = r0 + [-(l_long + gap)/2 0 0];              % center spheroid 2
    axes = [l_long, l_short, l_short];              % x-Pol
    
    geo.name = "spheroid pair";
    geo.max = (+axes + [+(l_long + gap) 0 0])/2;           
    geo.min = (-axes + [-(l_long + gap) 0 0])/2;           
    geo.fun = @(r)( min (Geo_Ellipsoid_Fun(r, r1, axes), Geo_Ellipsoid_Fun(r, r2, axes)));

end