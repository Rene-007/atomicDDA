function r = create_Sphere(diameter, spacing)
%% Create the coordinates of a sphere for a given diameter and spacing 
%  (distance between the dipoles).
    
radius = diameter /2;

r = [];

for x = -radius:spacing:radius
    for y = -radius:spacing:radius
        for z = -radius:spacing:radius
            if norm([x y z]) <= radius
                r( end+1, :) = [x y z];
            end
        end
    end
end

 