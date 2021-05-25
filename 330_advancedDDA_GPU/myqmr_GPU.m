function [x,relres,iter] = myqmr_GPU(P,fftA,B,R_on,b,tol,maxit)
%% minimal Quasi-Minimal Residual Method after Freud & Nachtigal 1991 and the Matlab QMR implementation


    % --- Init the arrays on the GPU ---
    x = gpuArray(P);
    fftA = gpuArray(fftA);
    B = gpuArray(B);
    R_on = gpuArray(R_on);
    b = gpuArray(b);
    
    % --- Init the vectors ---
    % r = b - C*x;
    % r = b - (A*x + B.*x);
    % r = R_on.*(b - (A*x + B.*x);
    % r = R_on.*(b - (Conv3D(fftA,x) + B.*x));
    r = gpuArray(R_on.*(b - (Conv3D(fftA,x) + B.*x)));
    vt = r;
    wt = r;
    p = vt;
    q = wt;
   
    % pt = C*p;
    % pt = A*p + B.*p;
    % pt = R_on.(A*p + B.*p);
    pt = R_on.*(Conv3D(fftA,p) + B.*p);

    % --- Init the coefficients ---
    epsilon = q' * pt;
    delta = wt' * vt;
    beta = epsilon / delta;
    
    rho = norm(vt);
    xi = norm(wt);
    gamma = 1;
    theta = rho / (gamma * abs(beta));
    eta = -1;
 
    % --- Init deltas ---
    d = eta * p;
    s = eta * pt;

    % Relative tolerance
    tolb = tol * norm(b);                  
   
    iter = 0;
    while iter < maxit && norm(r) > tolb
        
        % --- Update Lanczos vectors ---
        v = vt / rho;
        w = wt / xi;
        delta = w' * v;

        pde = xi * delta/epsilon;
        rde = rho * conj(delta/epsilon);

        p = v - pde * p;
        q = w - rde * q;
 
        % pt = C*p;
        % pt = A*p + B.*p;
        % pt = R_on.(A*p + B.*p);
        pt = R_on.*(Conv3D(fftA,p) + B.*p);   
        
        % wt = C'*q;        
        % wt = A'*q + conj(B).*q;        
        % wt = R_on.*(A'*q + conj(B).*q);      
        wt = R_on.*(Conv3D(conj(fftA),q) + conj(B).*q);      
        
        epsilon = q' * pt;       
        beta = epsilon / delta;
        
        vt = pt - beta * v;
        wt = wt - conj(beta) * w;
        
        % --- Save coefficients of last iteration... ---      
        rho_old = rho;
        gamma_old = gamma;
        theta_old = theta;

        % --- ...and update them ---        
        rho = norm(vt);
        xi = norm(wt);
        theta = rho / (gamma * abs(beta));
        gamma = 1 / sqrt(1 + theta^2);
        eta = - eta * rho_old * gamma^2 / (beta * gamma_old^2);

        
        % --- Calc new solution and residual ---
        d = eta * p + (theta_old * gamma)^2 * d;
        s = eta * pt + (theta_old * gamma)^2 * s;

        x = x + d;                                  
        r = r - s;                                 

        iter = iter + 1;
    end                                

    relres = gather(norm(r) / norm(b));
    x = gather(x);
end
