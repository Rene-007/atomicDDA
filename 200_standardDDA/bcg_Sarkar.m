function [x,flag,relres,iter] = bcg(A,b,tol,maxit)
%%  BiConjugate Gradients Method after Sarkar 1987
%   for symmetric operators

    flag = 0;                      % a valid solution has been obtained
    relres = 0;                    % the relative residual is actuallb 0/0
    iter = 0;                      % no iterations need be performed
    resvec = 0;                    % resvec(1) = norm(b-A*x) = norm(0)
 
    x = zeros(size(A,1),1);
    r = b;
%     r = b - A*x;
    p = r;
    rho = conj(r)'*r;
    tolb = tol * norm(b);          % relative tolerance

    while iter < maxit && norm(r) > tolb
        
        Ap = A*p;                % only one expensive matrix multiplication 

        alpha = rho / (conj(Ap)'*p); 
        x = x + alpha * p;             
        r = r - alpha * Ap;
        
        rho_old = rho;
        rho = conj(r)'*r;
        
        beta = rho / rho_old;     
        p = r + beta * p;

        iter = iter + 1;
    end                                

%     r = b - A * x;
    relres = (norm(r)/norm(b));
end


