function [x,flag,relres,iter,resvec] = ccg_Sarkar(A,b,tol,maxit)
%% Complex Conjugate Gradient method after Sarkar 1987 
% for an arbitrary operator A
  
    flag = 0;                      % a valid solution has been obtained
    relres = 0;                    % the relative residual is actually 0/0
    iter = 0;                      % no iterations need be performed
    resvec = 0;                    % resvec(1) = norm(b-A*x) = norm(0)
    
    x = zeros(size(b,1),1);
    r = b - A*x;
    ATr = A'*r;
    p = ATr;
    tolb = tol * norm(b);          % relative tolerance
    
    while iter < maxit && norm(r) > tolb
        
        Ap = A*p;     
        alpha = (ATr'*ATr) / (Ap'*Ap);

        x = x + alpha*p;
        r = r - alpha*Ap;
        ATr_new = A'*r;
      
        beta = (ATr_new'*ATr_new) / (ATr'*ATr);
       
        p = ATr_new + beta*p;
        ATr = ATr_new;
         
        iter = iter + 1;
    end
    
    relres = (norm(r)/norm(b));
    
end

