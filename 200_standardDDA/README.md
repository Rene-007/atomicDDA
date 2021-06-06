# 200_standardDDA

*In the last section we implemented a simple DDA and optimized the speed of setting up the matrix. In this chapter we will find its limitations and move to a more standard implementation.*

*Table of Contents:*
  * [Limitations of the Current Approach](#Limitations-of-the-Current-Approach)
  * [Iterative Algorithms](#Iterative-Algorithms)
  * [Code Changes](#Code-Changes)
  * [Results](#Results)

## Limitations of the Current Approach

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


## Iterative Algorithms

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

In general this is the limiting factor for all iterative solvers and, hence, their complexity is __*O(N²)*__, which is in principle much better than our old approach.

## Code Changes

Changed Files       | Notes
:-----              |:--------
standardDDA.m       | main file
ccg_Sarkar.m        | CCG solver after Sarkar 1987
ccg_Draine.m        | CCG solver after Draine 1988
ccg_Petravic.m      | CCG solver after Petravic and Kuo-Petravic 1979
bcg_Sarkar.m        | BCG solver after Sarkar 1987
bcg_Press.m         | BCG solver after Press et al. 2007

The standardDDA.m is structured such that it easy to play around with the different solvers.


## Results

Running the above example of a Gold sphere with the 50-nm diameter, 2.5-nm spacing and 4169 dipoles using the Sarkar CCG method give the following results:


    >> standardDDA
    Number of dipole: 4169
    wav = 400nm -- setting up: 3.7s -- solver: 0.008849  14   3.3s 
    wav = 410nm -- setting up: 3.1s -- solver: 0.008636  14   3.4s 
    wav = 420nm -- setting up: 3.2s -- solver: 0.008064  14   3.4s 
    wav = 430nm -- setting up: 3.1s -- solver: 0.007526  14   3.5s 
    wav = 440nm -- setting up: 3.2s -- solver: 0.007089  14   3.4s 
    wav = 450nm -- setting up: 3.2s -- solver: 0.009180  13   3.1s 
    wav = 460nm -- setting up: 3.1s -- solver: 0.007612  13   3.2s 
    wav = 470nm -- setting up: 3.1s -- solver: 0.007909  12   3.0s 
    wav = 480nm -- setting up: 3.1s -- solver: 0.009635  11   2.8s 
    wav = 490nm -- setting up: 3.1s -- solver: 0.007775  12   2.9s 
    wav = 500nm -- setting up: 3.1s -- solver: 0.008593  14   3.4s 
    wav = 510nm -- setting up: 3.1s -- solver: 0.009774  18   4.3s 
    wav = 520nm -- setting up: 3.1s -- solver: 0.009480  25   5.7s 
    wav = 530nm -- setting up: 3.1s -- solver: 0.009765  33   7.5s 
    wav = 540nm -- setting up: 3.1s -- solver: 0.009270  42   9.4s 
    wav = 550nm -- setting up: 3.1s -- solver: 0.009359  52  11.5s 
    wav = 560nm -- setting up: 3.1s -- solver: 0.009581  60  13.2s 
    wav = 570nm -- setting up: 3.1s -- solver: 0.009884  70  15.1s 
    wav = 580nm -- setting up: 3.1s -- solver: 0.009950  82  17.7s 
    wav = 590nm -- setting up: 3.1s -- solver: 0.009825  95  20.5s 
    wav = 600nm -- setting up: 3.1s -- solver: 0.009784 102  22.1s 
    wav = 610nm -- setting up: 3.1s -- solver: 0.009987 121  25.9s 
    wav = 620nm -- setting up: 3.1s -- solver: 0.009952 129  27.4s 
    wav = 630nm -- setting up: 3.1s -- solver: 0.009995 144  30.9s 
    wav = 640nm -- setting up: 3.3s -- solver: 0.009920 155  33.2s 
    wav = 650nm -- setting up: 3.1s -- solver: 0.009984 165  35.3s 
    wav = 660nm -- setting up: 3.1s -- solver: 0.009921 172  36.7s 
    wav = 670nm -- setting up: 3.1s -- solver: 0.009925 194  41.3s
    wav = 680nm -- setting up: 3.2s -- solver: 0.009914 213  45.5s 
    wav = 690nm -- setting up: 3.1s -- solver: 0.009948 231  49.1s 
    wav = 700nm -- setting up: 3.1s -- solver: 0.009957 242  51.7s 
    wav = 710nm -- setting up: 3.1s -- solver: 0.009957 264  56.3s 
    wav = 720nm -- setting up: 3.1s -- solver: 0.009975 287  61.2s 
    wav = 730nm -- setting up: 3.1s -- solver: 0.009969 288  61.5s 
    wav = 740nm -- setting up: 3.3s -- solver: 0.009983 282  60.3s 
    wav = 750nm -- setting up: 3.1s -- solver: 0.009989 325  69.9s 
    wav = 760nm -- setting up: 3.1s -- solver: 0.009960 358  76.2s 
    wav = 770nm -- setting up: 3.3s -- solver: 0.009981 393  84.3s 
    wav = 780nm -- setting up: 3.1s -- solver: 0.009980 390  82.7s 
    wav = 790nm -- setting up: 3.1s -- solver: 0.009969 316  67.6s 
    wav = 800nm -- setting up: 3.1s -- solver: 0.009960 292  62.9s 
    Overall required cpu time: 1351.6s 

One can see that the CCG solver is initially much faster than the inverting-the-matrix method but degrades rapidely for longer wavelength. Alltogether it is still faster (1351.6&thinsp;s vs. 1633.9&thinsp;s) for this small example and the larger the problem the clearer the win (50-nm diameter, 2.0-nm spacing and 8144 dipoles):

    >> standardDDA
    Number of dipole: 8144
    wav = 400nm -- setting up: 14.1s -- solver: 0.007220  14  12.5s 
    .
    .
    .
    wav = 800nm -- setting up: 13.9s -- solver: 0.009982 308 244.0s 

vs. 

    > standardDDA
    Number of dipole: 8144
    wav = 400nm -- setting up: 13.9s -- solver: 0.000000   0 260.5s 

Here even the slowest CCG wavelength at 800&thinsp;nm is faster than the inverting-the-matrix method constant 260&thinsp;s per step. Switching to another iterative solver can also give a little boost: For the smaller example the QMR solver only takes 917.9&thinsp;s and the BCG (Sarkar) 970.8&thinsp;s.

Nevertheless, [further improvements](../210_standardDDA_optimized-solvers) might still be handy... 

