function lattice = Lattice_ABC_Dir_XY(spacing,stacking)
%%  Definition of the coordinate system
%   Here we us a face centered cubic (fcc) packaging with stacking faults
%   Dir_XY: stacking parameter d influences x and y coordinates 

    % first some constants
    lattice.spacing = spacing;
    lattice.layerNumber = 3;
    
    sin60 = sind(60);
    yPos = 0.288675134594;
    zPos = 0.816496580927;
    
    % buffer for faster space filling
    lattice.stackCenter = stacking.center;
    cRange = (1-lattice.stackCenter):lattice.stackCenter;   % range of c values
    lattice.stackBuff = stacking.vec(lattice.stackCenter+cRange)' - cRange + 1;

    % now the transform
    lattice.xyz = @get_xyz;       
    
    function vec = get_xyz(a,b,c,d)
        % layers rhombohedral
        x = 1.0*a + 0.5*b + 0.5*(c+d-1);
        y = 0.0*a + sin60*b + yPos*(c+d-1);
        z = 0.0*a +   0.0*b + zPos*c;  
        vec = [x y z]*lattice.spacing;
    end  

    % and back transform   
    lattice.abc = @get_abc;   
    
    function vec = get_abc(r)
        r0 = r/lattice.spacing;
        x = r0(1); y = r0(2); z = r0(3);
        c = round(z/zPos);
        d = mod(stacking.pos(c)-c+1,3);
        b = round((y - yPos*(c+(d-1)))/sin60);
        a = round(x - 0.5*(b + c+(d-1)));
        vec = [a b c];
    end

     % limits
    lattice.limits = @limits;   

    function vec = limits(r)
        a_max = get_abc([r(1),0,0]);
        b_max = get_abc([0,r(1),0]);            
        c_max = get_abc([0,0,r(1)]);
        vec = [a_max(1) b_max(2) c_max(3)];
    end


    % density needed for polarizability
    lattice.rho = @(wav) sqrt(2) * (wav/lattice.spacing).^3;
    % packaging cubic case (scp): 0.5236 
    % closed packaging (hcp/fcc): 0.7405
    % -> fcc/scp = sqrt(2)

    
    % check if atoms are allowed
    lattice.okay = @(a,b,c,d) ( mod((stacking.pos(c)-c+1),lattice.layerNumber) == d );
    
end
