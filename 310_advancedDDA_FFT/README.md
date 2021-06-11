# 310_advancedDDA_FFT

*In the last section we layed the ground work for a lot of memory and speed improvements. In this section we can reap the first fruit of this labour.*

*Table of Contents:*
  * [Background on Circulant Matrices](#Background-on-Circulant-Matrices)
  * [Implementation](#Implementation)
  * [Code Changes](#Code-Changes)
  * [Results](#Results)
 

## Background on Circulant Matrices

Let's start with the circulant matrix from the last section.

<br/>
<div align="center"><img style="background: white;" src="..\003_media\cvfTTvXUnR.svg"></div>
<br/>

As the rows are circulating, we can simply multiply the *p* vector with the first row of the matrix, circular shift the elements to the right, multiply the two vectors again, shift again, and so on.

<br/>
<!-- $$
\begin{matrix}
\begin{bmatrix}
\color{gray}{p_{-40}} & \color{gray}{p_{-39}} & \color{gray}{p_{-38}} & \color{gray}{p_{-37}} &  \ldots & \color{teal}{p_{-2}} & \color{teal}{p_{-1}} & \color{teal}{p_{0}} & \color{teal}{p_{1}} & \color{teal}{p_{2}} & \ldots & \color{gray}{p_{37}} & \color{gray}{p_{38}} & \color{gray}{p_{39}} & \color{gray}{p_{40}} & 0 
\end{bmatrix} \\ 
\, \\
\Longleftrightarrow \\
\, \\
\begin{bmatrix}
\color{gray}{a_{-40}} & \color{gray}{a_{-39}} & \color{blue}{a_{-38}} & \color{orange}{a_{-37}} &  \cdots & \color{red}{a_{-2}} & \color{purple}{a_{-1}} & a_{0} & \color{purple}{a_{1}} & \color{red}{a_{2}} & \cdots & \color{orange}{a_{37}} & \color{blue}{a_{38}} & \color{gray}{a_{39}} & \color{gray}{a_{40}} & 0 \\
\end{bmatrix}
\end{matrix}
$$ --> 

<div align="center"><img style="background: white;" src="..\003_media\6Vc4ryt8GM.svg"></div> 
<br/>

This is a circular convolution which is one of the main features of circulant matrices [<img src="../003_media/External.svg" height="14">](https://en.wikipedia.org/wiki/Circulant_matrix#Analytic_interpretation) and can be made very performant. Given that <!-- $\mathbf{a}$ --> <img src="..\003_media\L1AubYq1sQ.svg"> is a row in the circulant matrix <img src="..\003_media\azPQdhk1g1.svg"> and <!-- $\mathbf{p}$ --> <img style="transform: translateY(0.1em)" src="..\003_media\rCRApphzIv.svg"> as well as <!-- $\mathbf{e}$ --> <img src="..\003_media\8lcVRpOlYT.svg"> the two vectors, we can now rewrite

<!-- $$
\mathbf{e} = \mathbf{Ap}
$$ --> 

<div align="center"><img style="background: white;" src="..\003_media\osyRXfOlaT.svg"></div>

as 

<!-- $$
\mathbf{e} = \mathcal{F}^{-1} 
\left ( \mathcal{F}_n(\mathbf{a}) \cdot \mathcal{F}_n(\mathbf{p})) 
\right )
$$ --> 

<div align="center"><img style="background: white;" src="..\003_media\7ylMMTbYrp.svg"></div>
<br/>

with $\mathcal{F}$ being the Fast Fourier Transform (FFT) and $\mathcal{F}^{-1}$ its inverse. The main advantage of utilizing the FFT is that it scales with __*O(N log(N))*__ instead of __*O(N²)*__. This means it needs much less steps than the matrix-vector multiplication and, therefore, reduces round-off error and improves speed a lot.


## Implementation

The main crux of the implementation is to get the convolution right as we are dealing with *3x3* tensors. Sticking to the above notation a simplified Matlab code would look like:

    e(:,1) = ifft( fft(a(:,1)) .* fft(p(:,1))  +  fft(a(:,2)) .* fft(p(:,2))  +  fft(a(:,3)) .* fft(p(:,3)) );
    e(:,2) = ifft( fft(a(:,2)) .* fft(p(:,1))  +  fft(a(:,5)) .* fft(p(:,2))  +  fft(a(:,6)) .* fft(p(:,3)) );
    e(:,3) = ifft( fft(a(:,3)) .* fft(p(:,1))  +  fft(a(:,6)) .* fft(p(:,2))  +  fft(a(:,9)) .* fft(p(:,3)) );

with `e(:,1)`, `e(:,2)` & `e(:,3)` being the vectors of all *x*, *y* & *z* component of *e*, respectively, and `p(:,1)`, `p(:,2)` & `p(:,3)` the same for *p*. `a(:,1)` to `a(:,9)` correspond to the vectors of the nine elements of the *3x3* tensor discussed [here](../100_simpleDDA#the-code).

In the real code some reshaping is needed to translate between the different memory layouts of the vectors. Furthermore, `fft(a(:,:))` is precomputed and saved as `fftA` during setting up `a`, because it is constant.

Adapting the solvers is the easy part here, as the matrix-vector multiplications such as

    Ap = A*p;

just need to be replaced with the corresponding convolution

    Ap = Conv3D(fftA,p);

with `Conv3D` being the convolution function.


## Code Changes


Changed Files           | Notes
:-----                  |:--------
advancedDDA.m           | main file
create_fftA             | create row of A and already fast-Fouriertransfom it
Conv3D                  | convolution algorithm
ccg_Sarkar_FFT.m        | CCG method with FFT
myqmr_FFT.m             | QMR method with FFT

The advancedDDA.m is structured such that it easy to switch between the standard and FFT solvers.



## Results

The results of our standard example of a Gold sphere with the 50-nm diameter, 2.5-nm spacing and 4169 dipoles using the Sarkar CCG method give us now: 

    >> advancedDDA
    Building a 50nm x 50nm spheroid with 68921 grid points and 4169 dipoles
    wav = 400nm -- setting up: 0.0s -- solver: 0.009789   9   0.5s 
    wav = 410nm -- setting up: 0.0s -- solver: 0.009618   2   0.1s 
    wav = 420nm -- setting up: 0.0s -- solver: 0.004915   3   0.2s 
    wav = 430nm -- setting up: 0.0s -- solver: 0.007949   2   0.1s 
    wav = 440nm -- setting up: 0.0s -- solver: 0.009231   2   0.2s 
    wav = 450nm -- setting up: 0.0s -- solver: 0.008389   3   0.2s 
    wav = 460nm -- setting up: 0.0s -- solver: 0.007807   3   0.2s 
    wav = 470nm -- setting up: 0.0s -- solver: 0.007524   3   0.2s 
    wav = 480nm -- setting up: 0.0s -- solver: 0.009954   2   0.1s 
    wav = 490nm -- setting up: 0.0s -- solver: 0.008249   3   0.2s 
    wav = 500nm -- setting up: 0.0s -- solver: 0.006245   4   0.2s 
    wav = 510nm -- setting up: 0.0s -- solver: 0.008486   5   0.3s 
    wav = 520nm -- setting up: 0.0s -- solver: 0.009005   8   0.4s 
    wav = 530nm -- setting up: 0.0s -- solver: 0.009367  11   0.6s 
    wav = 540nm -- setting up: 0.0s -- solver: 0.009306  14   0.7s 
    wav = 550nm -- setting up: 0.0s -- solver: 0.009684  15   0.7s 
    wav = 560nm -- setting up: 0.0s -- solver: 0.009445  16   0.8s 
    wav = 570nm -- setting up: 0.0s -- solver: 0.009952  15   0.7s 
    wav = 580nm -- setting up: 0.0s -- solver: 0.009950  16   0.8s 
    wav = 590nm -- setting up: 0.0s -- solver: 0.009890  17   0.8s 
    wav = 600nm -- setting up: 0.0s -- solver: 0.009754  19   0.9s 
    wav = 610nm -- setting up: 0.0s -- solver: 0.009640  19   0.9s 
    wav = 620nm -- setting up: 0.0s -- solver: 0.009932  17   0.8s 
    wav = 630nm -- setting up: 0.0s -- solver: 0.009775  19   0.9s 
    wav = 640nm -- setting up: 0.0s -- solver: 0.009694  18   0.9s 
    wav = 650nm -- setting up: 0.0s -- solver: 0.009868  20   1.0s 
    wav = 660nm -- setting up: 0.0s -- solver: 0.009896  19   0.9s 
    wav = 670nm -- setting up: 0.0s -- solver: 0.009897  20   1.0s 
    wav = 680nm -- setting up: 0.0s -- solver: 0.009900  20   1.0s 
    wav = 690nm -- setting up: 0.0s -- solver: 0.009806  21   1.0s 
    wav = 700nm -- setting up: 0.0s -- solver: 0.009944  20   1.0s 
    wav = 710nm -- setting up: 0.0s -- solver: 0.009817  22   1.1s 
    wav = 720nm -- setting up: 0.0s -- solver: 0.009868  22   1.1s 
    wav = 730nm -- setting up: 0.0s -- solver: 0.009905  23   1.1s 
    wav = 740nm -- setting up: 0.0s -- solver: 0.009985  23   1.1s 
    wav = 750nm -- setting up: 0.0s -- solver: 0.009915  25   1.2s 
    wav = 760nm -- setting up: 0.0s -- solver: 0.009999  23   1.1s 
    wav = 770nm -- setting up: 0.0s -- solver: 0.009934  27   1.3s 
    wav = 780nm -- setting up: 0.0s -- solver: 0.009978  24   1.1s 
    wav = 790nm -- setting up: 0.0s -- solver: 0.009939  28   1.3s 
    wav = 800nm -- setting up: 0.0s -- solver: 0.009988  23   1.1s 
    Overall required cpu time: 31.3s

This is a *20x* improvement from the 766.3&thinsp;s we had before! 

Note, due to the much larger grid, the observed accuracy in the spectra actually got a bit worse. However, when compensating it by reducing the tolerance from `1e-2` to `0.5e-2` the requirde cpu time was with 75.7&thinsp;s still *10x* faster. 

Additionally, in the [next section](../320_advancedDDA_FFT-optimized) we will introduce further optimizations.