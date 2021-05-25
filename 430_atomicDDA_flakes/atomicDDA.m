%%% advancedDDA -- Aborption/Extinction cross sections of a spherical gold partcle 

%% General stuff
clear
gpu = gpuDevice; reset(gpu);
addpath('../000_data');

wavelengths = 400:05:900;                        % range of wavelengths Start:Step:Stop in nm
phi = 0/180*pi;                                  % Angle of incidence -- zero means normal incidence


%% Create (multiple) particle(s) or import flake
% [r0,r_on,lattice] = create_ParticleSpace();                                       % Definition inside
% [r0,r_on,r_surf,lattice] = create_FlakeSpace( "flake_10001.csv" );
% [r0,r_on,r_surf,lattice] = create_FlakeSpace( "sphere_2334.csv" );
% [r0,r_on,r_surf,lattice] = create_FlakeSpace( "monomer_22713.csv" );
% [r0,r_on,r_surf,lattice] = create_FlakeSpace( "monomer_1000000.csv" );
% [r0,r_on,r_surf,lattice] = create_FlakeSpace( "dimer_48413.csv" );
% [r0,r_on,r_surf,lattice] = create_FlakeSpace( "dimer_750000.csv" );
[r0,r_on,r_surf,lattice] = create_FlakeSpace( "dimer_1000000.csv" );


%% Visualization
% show_3d(r0,r_on); 
show_3d(r0,r_surf); 
% show_2d(r0,r_on,lattice); 
return;
                 

%% Some handy derivations
N = length(r0);                                  % number of all dipoles
R_on = reshape(repmat(r_on,1,3)',[],1);          % R_on ... grid positions with active dipoles


%% Definitions of materials and the plane wave
n_s = 1.00;                                      % refractive index of the surrounding medium
n_m = n_Gold(wavelengths);                       % refractive index of the metal (JnC values)
n_rel = n_m/n_s;                                 % refractive index contrast 

% incident field
exci = Exci_PlaneWave(wavelengths,phi,n_s);      % set excitation field

% calc alpha beforehand
alpha = alpha_CM_vec(lattice.rho(exci.wavelengths),n_rel);  % alpha is a scalar and packed in a vector(wavelengths)
B = 1./alpha;                                    % now B is a scalar for each wavelength


%% Preallocate memory for the results vector and the absorption/extinction cross section lists
P = single(gpuArray(zeros(3*N,1)));              % single precission -> much faster on a GPU
fftA = single(gpuArray(zeros(1*N,6)));           % preallocate memory on the GPU

P_store = single(zeros(sum(R_on),length(wavelengths)));  % preallocate array for the results

C_Abs = zeros(1,length(wavelengths));            % absorption efficiency: Q_abs = C_abs / (Pi*a^2)
C_Ext = zeros(1,length(wavelengths));            % extinction efficiency: Q_ext = C_ext / (Pi*a^2)


%% Setting up the solver
% set requirements for solving
tol = 1e-3;     maxit = 10000;   


%% Loop over all wavelengths
startlooptime = clock;
for i = 1:length(wavelengths)
    
    % wavelength and get incident field 
    exci.i = i;
    fprintf('wav = %gnm -- ',exci.wav);
    Ei = exci.Einc(r0);                                   % direct incident field at dipoles for given wavelength

    %% Setting up the interaction matrix -- full interaction matrix C = A + B
    tic
    fftA = create_fftA_gpu(fftA,exci.k,r0/exci.wav);            % creating a circularized and already transformed column of the
                                                 % interaction matrix A directly on the GPU
                                                 % the first parameter is a memory place holder
    fprintf('setting up: %.1fs -- ',toc); 
    
    %% Solve the matrix using fft on the GPU
    tic  
    [P,relres,iter] = myqmr_GPU(P, fftA, B(i), R_on, Ei, tol, maxit);
    fprintf('solver: %f %3u %5.1fs \n',relres ,iter, toc);
    
    % save essential polarizations
    P_store(:,i) = gather(P(R_on));
             
end
endlooptime = clock;
fprintf('Overall required cpu time: %.1fs\n',etime(endlooptime,startlooptime));

% free some space on the GPU
clear P                                                         


%% Plot Ext/Abs
% calc absorption/extinction efficiencies
for i = 1:length(wavelengths)
    exci.i = i;
    Ei = exci.Einc(r0);                                          % direct incident field at dipoles for given wavelength
    C_Abs(i) = C_abs(exci.k,exci.E0,P_store(:,i),alpha(i));        % absorption efficiency: Q_abs = C_abs / (Pi*a^2)
    C_Ext(i) = C_ext(exci.k,exci.E0,Ei(R_on),P_store(:,i));        % extinction efficiency: Q_ext = C_ext / (Pi*a^2)
end

% and plot
figure
plot(wavelengths, C_Abs.*wavelengths.^2); hold on;
plot(wavelengths, C_Ext.*wavelengths.^2); hold on;
title(['Hex-FFT -- AOI = ' num2str(phi*180/pi) ', Grid Points = ' int2str(N), ', Atoms = ' int2str(sum(r_on)) ]);
legend('C_{abs}','C_{ext}','Location','northeast');
% legend('C_{ext}','Location','northeast');

return;

%% Calc field on a grid and plot it
% --- clear GPU memory first ---
gpu = gpuDevice();
reset(gpu)

% --- Set wavelength by hand ---
% exci.setWav = 640;
 
% --- Or automatically to the main resonance ---
[~,max_index]=max(C_Ext);
exci.i = max_index + 1;

% --- Choose a scaling and dipole masking ---
scale = @log;               % @lin or @log
mask_dipole = 0.5;
% mask_dipole = 1.1548;     % = ceil(2/sqrt(3)) -> crystal masked in xy plane
% mask_dipole = sqrt(2);    % crystal masked for all arbitrary planes

% --- Plotting ---
figure
fprintf('\nPlotting the scene nicely\n');
draw_field( '1nd', r0(r_on,:), P_store(:,exci.i), exci, scale, mask_dipole, "xy", 0.0, [[-200 4 200]; [-80 4 80]] );    % overview: low resolution
draw_field( '2nd', r0(r_on,:), P_store(:,exci.i), exci, scale, mask_dipole, "xy", 0.0, [[-100 2 100]; [-40 2 40]] );    % center: medium resolution
draw_field( '3nd top', r0(r_on,:), P_store(:,exci.i), exci, scale, mask_dipole, "xy", 0.0, [[-65 1/3 67]; [0 1/3 18]] );    % zoom: fine resolution
draw_field( '3nd bottom', r0(r_on,:), P_store(:,exci.i), exci, scale, mask_dipole, "xy", 0.0, [[-65 1/3 67]; [-20 1/3 0]] );   % zoom: fine resolution

% --- Format the plot window ---
title(['Field Plot for ' int2str(exci.wav()) ' nm']);
axis equal; axis tight;
colormap('jet'); colorbar;
% caxis([0 7.5]);
% view([0 0])
% zoom on;

%% --- Uncomment the following 3 lines to also plot the atoms ---
% scatter3(r0(r_on,1),r0(r_on,2),r0(r_on,3),3,'MarkerEdgeColor','k', 'MarkerFaceColor',[1 0.9 0]); 
% % scatter3(r0(r_surf,1),r0(r_surf,2),r0(r_surf,3),30,'MarkerEdgeColor','k', 'MarkerFaceColor',[1 0.9 0]); 
% rotate3d on;
% view(3);

