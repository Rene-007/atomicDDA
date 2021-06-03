function r = create_Cuboid( w, d, h, spacing)
%% Create the coordinates of a rectangular cuboid for a given width, depht and height as well as spacing
%  (distance between the dipoles).
    
r = [];

for x = -w/2:spacing:w/2
    for y = -d/2:spacing:d/2
        for z = -h/2:spacing:h/2
%             if norm([x y z]) <= radius
                r( end+1, :) = [x y z];
%             end
        end
    end
end

 