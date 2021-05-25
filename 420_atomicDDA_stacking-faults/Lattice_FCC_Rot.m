function lattice = Lattice_FCC_Rot(spacing)
%%  Definition of the coordinate system
%   Here we us a face centered cubic (fcc) packaging rotated by 90 degree around z axis

    % first some constants
    lattice.spacing = spacing;
    lattice.layerNumber = 1;
    
    sin60 = 0.8660254038;
    yPos = 0.288675134594;
    zPos = 0.816496580927;
    
    % now the transform
    lattice.xyz = @get_xyz;       
    
    function vec = get_xyz(a,b,c,d)
        % rhombohedral
        x = 1.0*a + 0.5*b + 0.5*c;
        y = 0.0*a + sin60*b + yPos*c;
        z = 0.0*a +   0.0*b + zPos*c;
        % cubic
%         x = 1.0*a + 0.5*mod(b,2) + 0.5*mod(c,3);
%         y = 0.0*a + sin60*b + yPos*mod(c,3);
%         z = 0.0*a +   0.0*b + zPos*c;
        
        vec = [-y x z]*lattice.spacing;            % rotation around z axis
    end  
    
    
    % and back transform   
    lattice.abc = @backtransform;   % that's a bit more complicated and therefore outsourced into a seperated function
    
    function vec = backtransform(x,y,z)
        % rhombohedral
        c = z/zPos;
        b = (y - yPos*c)/sin60;
        a = x - 0.5*b - 0.5*c;
        % cubic
%         c = z/zPos;
%         b = (y - yPos*mod(c,3))/sin60;
%         a = x - 0.5*mod(b,2) - 0.5*mod(c,3);

        vec = [a b c]/lattice.spacing;
    end

    % limits
    lattice.limits = @limits;   

    function vec = limits(r)
        a_max = backtransform(r(1),0,0);
        b_max = backtransform(0,r(1),0);
        c_max = backtransform(0,0,r(1));
        vec = [a_max(1) b_max(2) c_max(3)];
    end

    % density needed for polarizability
    lattice.rho = @(wav) sqrt(2) * (wav/lattice.spacing).^3;
    % packaging cubic case (scp): 0.5236 
    % closed packaging (hcp/fcc): 0.7405
    % -> fcp/scp = sqrt(2)

    % check if atoms are allowed
    lattice.okay = @(a,b,c,d) ( true );
    
end
