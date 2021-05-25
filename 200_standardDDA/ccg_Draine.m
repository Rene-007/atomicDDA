function [x,flag,relres,iter,resvec] = ccg_Drain(C,y,tol,maxit)
%% Complex Conjugate Gradient method after Draine 1988

    flag = 0;                      % a valid solution has been obtained
    relres = 0;                    % the relative residual is actually 0/0
    iter = 0;                      % no iterations need be performed
    resvec = 0;                    % resvec(1) = norm(b-A*x) = norm(0)
    
    x = zeros(size(y,1),1);
    z = C'*y;                      % C' computes the complex conjugate transpose of C aka Hermitian conjugate
    w = C*x;
    g = z - C'*w;
    p = g;
    r = y - w;
    stol = tol * norm(y);
    
    while iter < maxit && norm(r) > stol
        
        v = C*p;  
        alpha = (g'*g) / (v'*v);
        
        x = x + alpha*p;
        w = w + alpha*v;
        r = y - w;
%         r = r - alpha*v;
        g_new = z - C'*w;
%         g_new = C'*r;
        
        beta = (g_new'*g_new) / (g'*g);
      
        p = g_new + beta*p;      
        g = g_new;
        
        iter = iter + 1;
    end
%     alpha
    relres = (norm(r)/norm(y));

    
end

