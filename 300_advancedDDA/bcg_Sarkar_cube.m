function [x,relres,iter] = bcg_Sarkar_cube(A,B,R_on,b,tol,maxit)
%%  BiConjugate Gradients Method after Sarkar 1987
%   for symmetric operators

    N = size(b,1);
    x = zeros(N,1);
    r = R_on.*(b - (A*x - B.*x));
    
    p = r;
    rho = conj(r)'*r;
    tolb = tol * norm(b);          % relative tolerance
    
    iter = 0;
    while iter < maxit && norm(r) > tolb
        
        % Cp = (A+B)*p             % but here, B is just a vector
        Cp = A*p + B.*p;           % only one expensive matrix multiplication needed
        
        alpha = rho / (conj(Cp)'*p); 

        x = x + alpha * (R_on.*p);             
        r = r - alpha * (R_on.*Cp);
        
        rho_old = rho;
        rho = conj(r)'*r;
        
        beta = rho / rho_old;     
        p = r + beta * p;

        iter = iter + 1;
    end                                

    relres = (norm(r)/norm(b));
    
end

