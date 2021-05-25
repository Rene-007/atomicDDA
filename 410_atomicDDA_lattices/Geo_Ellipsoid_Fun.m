function dist = ellipsoid_fun(r,r0,pa)
%%  Distance function for an ellipsoid 
%   dist < 1 means point is inside the ellipsoid
%
%   r  ... point to test
%   r0 ... center of the ellipsoid 
%   pa ... length of the principle axes

    dist = (r(1)-r0(1))^2/((pa(1)/2)^2) + (r(2)-r0(2))^2/((pa(2)/2)^2) + (r(3)-r0(3))^2/((pa(3)/2)^2);
end