# 100_simpleDDA_faster-setup

*We found in the last section that setting up the matrix takes roughly 10x longer than actually solving it. In this section we discuss how to easily fix that.*

## Background

In compiled and statically typed languages, such as C/C++ or Rust, the compiler has a lot of time and knowledge to analyze the code and e.g. unroll loops to better utitilize the vector instructions of modern CPUs (x64: MMX, SSE, AVX; arm: Neon, SVE) which is called autovectorization. By doing this, data locality can also be improved, i.e. needed values can be better prefetched into caches such that the CPU does not have to wait for the data to arrive.

As Matlab is an interpreted (nowadays a just-in-time compiled) and dynamically typed language, such automatic optimizations are not so easily possible. So, we have to manually vectorize the critical code by ourselves.

## Code Changes

The basic steps for vectorizing our matrix-setup code are:
* Calculate the <!-- $\mathbf{A}$ --> <img style="transform: translateY(0.0em);" src="..\003_media\g6hoF3MfXJ.svg"> and <!-- $\mathbf{B}$ --> <img style="transform: translateY(0.05em);" src="..\003_media\GYtED7qkN1.svg"> matrices separately 

* For matrix <!-- $\mathbf{A}$ --> <img style="transform: translateY(0.0em);" src="..\003_media\g6hoF3MfXJ.svg"> we:
    * only consider the lower left triangle,
    * divide it into rows that span from the first position up to the diagonal  
      (be aware: each element of the row vector is still a 3x3 tensor),
    * iterate over all rows and calculate the whole row at once by
        * building a vector of distance vectors between the current element and all others  
          (due to symmetry it is only require up to the diagonal),
        * calculating a vector of distances, vector of normalized distance vectors and
        * proceeding more or less as with the sequential code;  
    * fill the upper right triangle of the matrix by mirroring the lower left part. 


* Matrix <!-- $\mathbf{B}$ --> <img style="transform: translateY(0.05em);" src="..\003_media\GYtED7qkN1.svg"> can quickly be calculated by setting all diagonal elements to <!-- $\alpha^{-1}$ --> <img style="transform: translateY(0.0em);" src="..\003_media\IuvjKmSwvX.svg">
* Add <!-- $\mathbf{A}$ --> <img style="transform: translateY(0.0em);" src="..\003_media\g6hoF3MfXJ.svg"> and <!-- $\mathbf{B}$ --> <img style="transform: translateY(0.05em);" src="..\003_media\GYtED7qkN1.svg"> together to <!-- $\mathbf{C}$ --> <img style="transform: translateY(0.05em);" src="..\003_media\k3DdFIe8PY.svg">

Further optimizations are to reuse the memory of the <!-- $\mathbf{C}$ --> <img style="transform: translateY(0.05em);" src="..\003_media\k3DdFIe8PY.svg"> array (less memory allocations) and utilize the symmetry of each 3x3 tensor -- only 6 elements are unique. 

Changed Files       | Notes
:-----              |:--------
simpleDDA.m         | main file
create_C_simple.m   | removed
create_A.m          | setting up the interaction matrix <!-- $\mathbf{A}$ --> <img style="transform: translateY(0.0em);" src="..\003_media\g6hoF3MfXJ.svg">
calc_row_Aj.m       | calc a row of <!-- $\mathbf{A}$ --> <img style="transform: translateY(0.0em);" src="..\003_media\g6hoF3MfXJ.svg"> up to the j<sup>th</sup> position

## Results

This time we simulate a Gold sphere with a diameter of 50&thinsp;nm, 5&thinsp;nm spacing and 515 dipoles. The console output is:

    >> simpleDDA
    Number of dipole: 515
    wav = 400nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 410nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 420nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 430nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 440nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 450nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 460nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 470nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 480nm -- setting up: 0.1s -- solver:   0.2s 
    wav = 490nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 500nm -- setting up: 0.1s -- solver:   0.2s 
    wav = 510nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 520nm -- setting up: 0.1s -- solver:   0.2s 
    wav = 530nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 540nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 550nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 560nm -- setting up: 0.1s -- solver:   0.2s 
    wav = 570nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 580nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 590nm -- setting up: 0.1s -- solver:   0.2s 
    wav = 600nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 610nm -- setting up: 0.1s -- solver:   0.2s 
    wav = 620nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 630nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 640nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 650nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 660nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 670nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 680nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 690nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 700nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 710nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 720nm -- setting up: 0.1s -- solver:   0.2s 
    wav = 730nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 740nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 750nm -- setting up: 0.1s -- solver:   0.2s 
    wav = 760nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 770nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 780nm -- setting up: 0.1s -- solver:   0.1s 
    wav = 790nm -- setting up: 0.1s -- solver:   0.2s 
    wav = 800nm -- setting up: 0.1s -- solver:   0.1s 
    Overall required cpu time: 10.0s

It seems that setting up the matrix is not the main issue any more and we can [proceed to bigger problems...](../200_standardDDA) 