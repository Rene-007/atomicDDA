function [x,flag,relres,iter] = bcg(A,b,tol,maxit)
%%   BiConjugate Gradients Method after Press et al. 2007

    flag = 0;                      % a valid solution has been obtained
    relres = 0;                    % the relative residual is actuallb 0/0
    iter = 0;                      % no iterations need be performed
    resvec = 0;                    % resvec(1) = norm(b-A*x) = norm(0)
 
    x = zeros(size(A,1),1);
%     r = b;
    r = b - A*x;
    rt = r;                        % shadow residual
    p = r;
    pt = rt;    
    rho = rt' * r;
    tolb = tol * norm(b);          % relative tolerance

    while iter < maxit && norm(r) > tolb
        
        Ap = A * p;                % expensive matrix multiplication 1
        ATpt = A' * pt;            % expensive matrix multiplication 2

        alpha = rho / (pt'*Ap); 
        x = x + alpha * p;             
        r = r - alpha * Ap;
        rt = rt - conj(alpha) * ATpt;
        
        rho_old = rho;
        rho = rt' * r;
        
        beta = rho / rho_old;
        p = r + beta * p;
        pt = rt + conj(beta) * pt;

        iter = iter + 1;
    end                                

%     r = b - A * x;
    relres = (norm(r)/norm(b));
end


