function [x,flag,relres,iter,resvec] = ccg(A,b,tol,maxit)
%% Complex Conjugate Gradient method after Petravic and Kuo-Petravic 1979

    recomp = 50;
    
    flag = 0;                      % a valid solution has been obtained
    relres = 0;                    % the relative residual is actually 0/0
    iter = 0;                      % no iterations need be performed
    resvec = 0;                    % resvec(1) = norm(b-A*x) = norm(0)
    
    x = zeros(size(b,1),1);
    r = b - A*x;
    g_old = A'*r;
    p = g_old;
    v = A*p;
    stol = tol * norm(b);          % relative tolerance
    
    while iter < maxit && norm(r) > stol
        
        alpha = (g_old'*g_old) / (v'*v);
        x = x + alpha*p;
        r = r - alpha*v;

        g_new = A'*r;     

        beta = (g_new'*g_new) / (g_old'*g_old);
        p = g_new + beta*p;

        if mod(iter,recomp) == 0
            v = A*p;
        else
            v = A*g_new + beta*v;
        end

        g_old = g_new;        
        iter = iter + 1;
    end

    relres = (r'*r);
    
end

