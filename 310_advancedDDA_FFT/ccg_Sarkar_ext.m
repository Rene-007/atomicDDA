function [x,relres,iter] = ccg_Sarkar_ext(P,A,B,R_on,b,tol,maxit)
%% Complex Conjugate Gradient method after Sarkar 1987 
%  for an arbitrary operator A
   
    x = P;            
    Ax = A*x;
    r = R_on.*(b - (Ax + B.*x));

    ATr = A'*r;
    CTr = R_on.*(ATr + conj(B).*r);
    p = CTr;
    
    tolb = tol * norm(b);          % relative tolerance
    
    iter = 0;
    while iter < maxit && norm(r) > tolb
        
        Ap = A*p;
        Cp = R_on.*((Ap + B.*p));
        
        alpha = (CTr'*CTr) / (Cp'*Cp);

        x = x + alpha.*p;
        r = r - alpha.*Cp;
        
        ATr = A'*r;
        CTr_new = R_on.*(ATr + conj(B).*r);
      
        beta = (CTr_new'*CTr_new) / (CTr'*CTr);
       
        p = CTr_new + beta.*p;
        CTr = CTr_new;
         
        iter = iter + 1;
    end
    
    relres = (norm(r)/norm(b));
    
end

