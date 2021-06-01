function r = create_Cube( w, d, h, spacing)
%% Create the coordinates of a cube for a given diameter and spacing 
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

 