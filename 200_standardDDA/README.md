# 200_standardDDA

*In the last section we implemented a simple DDA and optimized the speed of setting up the matrix. In this chapter we will find its limitations and move to a more standard implementation.*

## Limitations

We take again our Gold sphere with the 50-nm diameter and this time tune the dipole spacing. When going from the original 5&thinsp;nm spacing to 4&thinsp;nm and later 2.5&thinsp;nm the number of dipoles first roughly doubles from 515 dipoles to 1018 and than octuplicate to 4169. This improves the quality of the spectra a lot (see below) as the unphysical ripples between 600&thinsp;nm and 750&thinsp;nm disappear. (Note, the spiky shape of the peak disappears when using finer discretizations of the spectrum.)

<div align="center"><img src="/003_media/sphere-50nm_invC_Comparison.jpg" alt="Results for the 50x40x30 rectangular"></div>

A notable point here is that the time for solving the problem increases by ~6x and ~250x, respectively. The reason for this very bad scaling is that inverting a matrix with _NxN_ elements scales with _O(N<sup>3</sup>)_. So, when further doubling the number of dipole (spacing 2.0&thinsp;nm) and solving for the first wavelength we obtain:

    > standardDDA
    Number of dipole: 8144
    wav = 400nm -- setting up: 13.9s -- solver: 0.000000   0 260.5s 

This means, calculating the whole spectrum (41 wavelengths) would take around 3 hours and a 100-nm sphere (8x the dipoles) probably one month! This is hardly acceptable -- the computer I am using is already a *AMD Ryzen 9 5950X* with 16 cores and 32 threads. 

One big benefit of our current approach with inverting the matrix is that because of

<!-- $$
\mathbf{P} = \mathbf{C}^{-1} \mathbf{{E}}_{\textrm{exci}} \, .
$$ --> 

<div align="center"><img style="background: white;" src="..\003_media\hNj6OWj9xJ.svg"></div> 

we only have to invert <!-- $\mathbf{C}$ --> <img style="transform: translateY(0.05em);" src="..\003_media\k3DdFIe8PY.svg"> once and can use that for simulating all different kinds of excitations, e.g. different angles of incidence & polarization, focused beams, dipole excitations and so on. This sounds very appealing. However, the _O(N<sup>3</sup>)_ scaling does not only mean that inverting the matrix is very slow but also that the result might be numerically wrong. The reason is that we are dealing with floating point numbers which show small round-off errors [<img src="../003_media/External.svg" height="14">](https://en.wikipedia.org/wiki/Round-off_error) with nearly every arithmetic operation and, hence, when we have _O(N<sup>3</sup>)_ compuational steps that take days this can easily happen.

So, it is worth to look for a better overall approach.


## Solution

The solution is to use iterative algorithms.  

There are many different iterative solvers around. Matlab provides amongst others the Conjugate Gradients Squared (CGS) as well as the Quasi-Minimal Residual (QMR) method and I implemented the Complex Conjugate Gradient (CCG) as well as the BiConjugate Gradients (BCG) methods in several variants. In detail they are all very different from each other and have their own strengths and weaknesses, but from a bird's eye view the basic idea behind them is quite similar. I will try to give a superficial explanation to grasp the principle.

Consider an equation of the form
    
        A*x = b

where __*A*__ is a *NxN* matrix and __*x*__ as well as __*b*__ are column vector of length *N*. Then one can define a residual

        r = b - A*x .

When the norm of *r* is or becomes zero then we are at a (local) minimum and have an exact solution. If not, we try to minimize the residual to come closer to the solution. For doing that, we

* calculate some "form of gradient" inside our *N*-dimensional hyperspace to find a way downhill
* estimate a step width and move a step down towards the (local) minimum
* calculate the residual again. 

The residual should now be smaller and, hence, repeating these steps iteratively leads us to a (local) minimum. As we probably never exactly arrive there (e.g. due to round-off errors), we can define a number of maximum iterations and/or a threshold (relaive "error") where we stop the iterations. Nevertheless, now we have with *x* a good approximation for the solution.

It is worth looking into one method more in detail to better understand its computational complexity. Here we go with the CCG method after [Sarkar 1987 <img src="../003_media/External.svg" height="14">](https://www.doi.org/10.1163/156939387X00036) which uses a second, "conjugated" vector for finding a faster way downhill. But still, it is comprehensible enough to follow the computational steps:

    function [x] = ccg_Sarkar(A,b,tol,maxit)
    %% Complex Conjugate Gradient method after Sarkar 1987 for an arbitrary operator A
    
        % --- initialization ---
        x = zeros(size(b,1),1);                         % solution vector      (dim: Nx1)
        r = b - A*x;                                    % residual vector      (dim: Nx1)
        ATr = A'*r;                                     % r buffer             (dim: Nx1)
        p = ATr;                                        % "conjugated" vector  (dim: Nx1)
        tolb = tol * norm(b);                           % relative tolerance   (scalar)
        
        % --- main loop ---
        while iter < maxit && norm(r) > tolb
            
            Ap = A*p;                                   % update p buffer      (dim: Nx1)
            alpha = (ATr'*ATr) / (Ap'*Ap);              % step width           (scalar)

            x = x + alpha*p;                            % correct solution
            r = r - alpha*Ap;                           % correct residual
            
            ATr_new = A'*r;                             % update r buffer
            beta = (ATr_new'*ATr_new) / (ATr'*ATr);     % second step width    (scalar)
        
            p = ATr_new + beta*p;                       % correct "conjugated" vector

            ATr = ATr_new;                              % copy r buffer             
            iter = iter + 1;                            % next iteration
        end
                
    end


Within the main loop we see several vector additions, scalar products and scalar-vector multiplications which are all of the complexity *O(N)*. However, the __*A\*p*__ and __*A'\*r*__ matrix multiplications are both of the order *O(N²)* as __*A*__ is a *NxN* matrix. 

This is in general the limiting factor for all iterative solvers and, hence, their complexity is __*O(N²)*__. This is in principle much better than our old approach.


## Evaluation