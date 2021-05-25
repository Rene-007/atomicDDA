classdef Exci_PlaneWave
%%  Definition of a plane wave
%   wav ... vacuum wavelength
%   phi ... angle of incidence
%   n_s ... dielectric index of surrounding

    properties
        i;
        setWav;                                                  % needed for some hack further down
        wavelengths;
        k;
        E0;
        kvec;
        
    end
    
    methods 
        % constructor
        function obj = Exci_PlaneWave(wavelengths,phi,n_s)
            obj.wavelengths = wavelengths;                       % array of wavelength
            obj.i = 1;                                           % set the first wavelength as default
            obj.k = 2*pi*n_s;                                    % wave number

            obj.E0 = [cos(phi) 0 sin(phi)];                      % electric field vector -- p polarization
            % obj.E0 = [0 cos(phi) sin(phi)];                    % electric field vector -- s polarization
            obj.kvec = obj.k*[sin(phi) 0 -cos(phi)];             % wave vector
 

        end
        
        % return current wavelength
        function wav = wav(obj)                                 
            wav = obj.wavelengths(obj.i);                                      
        end
        
        % return current incicent field
        function E = Einc3(obj,r0)
                E = obj.E0 .*exp(1i.*(r0*obj.kvec')./obj.wav);
        end
        
        function E = Einc(obj,r0)
                E = obj.Einc3(r0);
                E = reshape(E.',[],1);
        end
        
        function E = Einc_flat(obj,r0)
                E = obj.Einc3(r0);
                E = reshape(E,[],1);
        end
        
        % the hack for setting the nearest wavelength easily
        function obj = set.setWav(obj,wav)
            [~,closest] = min(abs(obj.wavelengths-wav));
            obj.i = closest;
        end        
    end
end