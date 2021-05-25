function [x,flag,relres,iter,resvec] = ccg(A,y,tol,maxit)
%% Complex Conjugate Gradient method after Petravic and Kuo-Petravic 1979

    recomp = 50;
    
    flag = 0;                      % a valid solution has been obtained
    relres = 0;                    % the relative residual is actually 0/0
    iter = 0;                      % no iterations need be performed
    resvec = 0;                    % resvec(1) = norm(b-A*x) = norm(0)
    
    x = zeros(size(y,1),1);
    r = y - A*x;
    g_old = A'*r;
    p = g_old;
    v = A*p;
    stol = tol * norm(y);
    
    while iter < maxit && norm(r) > stol
%         tic      
        alpha = (g_old'*g_old) / (v'*v);

        x = x + alpha*p;
        r = r - alpha*v;
%         v1 = toc;
        
%         if mod(iter,recomp) == 0
%             r = y - A*x;
%         else
%             r = r - alpha*v;
%         end
        
%         tic
        g_new = A'*r;     
% %         v2 = toc; 
        
%         tic
        beta = (g_new'*g_new) / (g_old'*g_old);
        p = g_new + beta*p;
%         v3 = toc;
        
%         tic
        if mod(iter,recomp) == 0
            v = A*p;
        else
            v = A*g_new + beta*v;
        end
%         v4 = toc;
        
%         tic;
        g_old = g_new;
%         v5 = toc;
        
        iter = iter + 1;
    end

    relres = (r'*r);
%     fprintf('v1: %.5fs -- v2: %.5fs -- v3: %.5fs -- v4: %.5fs -- v5: %.5fs ',v1,v2,v3,v4,v5);
    
end

