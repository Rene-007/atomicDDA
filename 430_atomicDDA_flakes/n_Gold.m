function m = n_Gold(lambda_range)
%% Read optical data of gold
%  Source: Olmon et al. Physical Review B 86, 235147 (2012).

    % epsData =  dlmread( 'epsAu_Olmon-EV.dat','\t',1,0);     % evaporated gold
    epsData =  dlmread( 'epsAu_Olmon-SC.dat','\t',1,0);     % single crystal
    % epsData =  dlmread( 'epsAu_Olmon-TS.dat','\t',1,0);     % template striped gold

    lambda = epsData(:,2).*1e9;
    n = epsData(:,5);
    k = epsData(:,6);

    Re_m = interp1(lambda,n,lambda_range,'spline');
    Im_m = interp1(lambda,k,lambda_range,'spline');
    m = Re_m + 1i*Im_m;

end