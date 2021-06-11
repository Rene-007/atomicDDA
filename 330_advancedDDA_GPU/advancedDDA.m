%%% advancedDDA -- Aborption/Extinction cross sections of a spherical gold partcle 

%% General stuff
clear
addpath('../000_data');

wavelengths = 400:10:800;                        % range of wavelengths Start:Step:Stop in nm
phi = 0/180*pi;                                  % Angle of incidence -- zero means normal incidence


%% Definition of the particle
spacing = 2.5;                                   % dipole spacing in nm
[r0,r_on] = create_Spheroid_ext(50,50,spacing);  % create_Spheroid(long_axis, short_axis, spacing) with an extended grid
R_on = reshape(repmat(r_on,1,3)',[],1);          % R_on ... positions where there is an active dipole
N = length(r0);                                  % number of all dipoles


%% visualization
figure;
% scatter3(r0(:,1),r0(:,2),r0(:,3),30*r_on+0.1,'MarkerEdgeColor','k', 'MarkerFaceColor',[1 0.9 0]); 
scatter3(r0(r_on,1),r0(r_on,2),r0(r_on,3),30,'MarkerEdgeColor','k', 'MarkerFaceColor',[1 0.9 0]); 
axis equal; 
% return;


%% Definitions of materials and the plane wave
n_s = 1.0;                                       % refractive index of the surrounding medium
n_m = n_Gold(wavelengths);                       % refractive index of the metal (JnC values)
k = 2*pi*n_s;                                    % wave number

E0 = [cos(phi) 0 sin(phi)];                      % amplitude of incomming plane wave
kvec = k*[sin(phi) 0 -cos(phi)];                 % wave vector


%% Preallocate memory for the results vector and the absorption/extinction cross section lists
P = zeros(3*N,1);

C_Abs = zeros(1,length(wavelengths));            % absorption efficiency: Q_abs = C_abs / (Pi*a^2)
C_Ext = zeros(1,length(wavelengths));            % extinction efficiency: Q_ext = C_ext / (Pi*a^2)


%% Loop over all wavelengths
startlooptime = clock;
for i = 1:length(wavelengths)
    
    % obtain and display the wavelength
    wav = wavelengths(i);
    fprintf('wav = %gnm -- ',wav);

    % helpers
    n_rel = n_m(i)/n_s*ones(N,1);                % refractive index contrast (matrix)
    rho = (wav/spacing)^3;                       % number of dipoles per unit volume
    r = r0/wav;                                  % (dimensionless) position vector to each dipole           
    
    % incident plane wave and alpha
    Ei = reshape((E0.*exp(1i*(r*kvec')))',[],1); % direct incident field at dipoles
    alpha = alpha_CM(rho,n_rel);                 % polarizability of the dipoles
    B = 1./alpha(1);                             % all dipoles are made of the same material
    
    %% Setting up the solver
    % set requirements for solving
    tol = 1e-2;     maxit = 10000;     
    relres = 0;     iter = 0;       
 
    % choose a solver
    solver = 3; 
    
    %% Solve dipole moments
    switch solver        
        % FFTW solutions on the CPU
        case 1
          % creating a circularized and already transformed column of the
          % interaction matrix A as usual on the CPU
          tic
          fftA = create_fftA(k,r);                
          fprintf('setting up: %.1fs -- ',toc);   
          % solving the matrix using FFTW on the CPU
          tic            
          [P,relres,iter] = ccg_Sarkar_FFT(P, fftA, B, R_on, Ei, tol, maxit);  
        case 2
          % creating a circularized and already transformed column of the
          % interaction matrix A as usual on the CPU
          tic
          fftA = create_fftA(k,r);                
          fprintf('setting up: %.1fs -- ',toc);   
          % solving the matrix using FFTW on the CPU
          tic  
          [P,relres,iter] = myqmr_FFT(P, fftA, B, R_on, Ei, tol, maxit);
        
        % FFT solutions utilizing the GPU
        case 3
          % creating a circularized and already transformed column of the
          % interaction matrix A directly on the GPU
          tic
          fftA = create_fftA_gpu(k,r);                
          fprintf('setting up: %.1fs -- ',toc);   
          % solving the matrix using fft directly on the GPU
          tic  
          [P,relres,iter] = ccg_Sarkar_GPU(P, fftA, B, R_on, Ei, tol, maxit);
        case 4
          % creating a circularized and already transformed column of the
          % interaction matrix A directly on the GPU
          tic
          fftA = create_fftA_gpu(k,r);                
          fprintf('setting up: %.1fs -- ',toc);   
          % solving the matrix using fft directly on the GPU
          tic  
          [P,relres,iter] = myqmr_GPU(P, fftA, B, R_on, Ei, tol, maxit);
    end 
    
    fprintf('solver: %f %3u %5.1fs \n',relres ,iter, toc);
         
    %% Calc cross sections
    C_Abs(i) = C_abs(k,E0,R_on.*P,alpha);
    C_Ext(i) = C_ext(k,E0,Ei,P);            
    
end
endlooptime = clock;
fprintf('Overall required cpu time: %.1fs\n',etime(endlooptime,startlooptime));


%% Plot Ext/Abs
figure
plot(wavelengths, C_Abs.*wavelengths.^2); hold on;
plot(wavelengths, C_Ext.*wavelengths.^2); hold on;
title(['advancedDDA -- AOI = ' num2str(phi*180/pi) ', Dipoles = ' int2str(N) ', Spacing = ' num2str(spacing,2)]);
legend('C_{abs}','C_{ext}','Location','northeast');
xlabel('Wavelength (nm)')
ylabel('Cross Section (nm^2)')

