function lattice = Lattice_SCP(spacing)
%%  Definition of the coordinate system
%   Here we us a simple cubic packing (scp)

    % first some constants
    lattice.spacing = spacing;
        
    % now the transform
    lattice.xyz = @(a,b,c)( ([a b c ]) *lattice.spacing );       
    
    % and back transform   
    lattice.abc = @backtransform;   % that's used multiple times and therefore outsourced into a seperated function
    
    function vec = backtransform(x,y,z)
        vec = [x y z]/lattice.spacing;
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
    lattice.rho = @(wav) (wav/lattice.spacing)^3;
        
end
