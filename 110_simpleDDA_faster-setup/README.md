# 100_simpleDDA_faster-setup

We found in the last section that setting up the matrix takes roughly 10x longer than actually solving it. In this section we discuss how to easily fix that.

## Background

In compiled and statically typed languages, such as C/C++ or Rust, the compiler has a lot of time and knowledge to analyze the code and e.g. unroll loops to better utitilize the vector instructions of modern cpus (x64: MMX, SSE, AVX; arm: Neon, SVE) which is called autovectorization. By doing this, it can also improve data locality, i.e. needed values can be better prefetched into caches such that the cpu does not has to wait for the data to arrive.

Matlab is an interpreted (nowadays a just-in-time compiled) and dynamically typed language where such optimizations are not so easily possible. So, we have to vectorize the critical code by ourselves.

## Code changes

The Basic steps for vectorizing the code are:
* Calculate the <!-- $\mathbf{A}$ --> <img style="transform: translateY(0.0em);" src="..\003_media\g6hoF3MfXJ.svg"> and <!-- $\mathbf{B}$ --> <img style="transform: translateY(0.05em);" src="..\003_media\GYtED7qkN1.svg"> matrices separately 

* For matrix <!-- $\mathbf{A}$ --> <img style="transform: translateY(0.0em);" src="..\003_media\g6hoF3MfXJ.svg"> we:
    * only consider the lower left triangle,
    * divide it into rows that spans from the first position up to the diagonal  
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

## Results

This time we simulate a Gold sphere with a diameter of 50nm, 5nm spacing and 515 dipoles. The console output is:

<div align="center"><img src="/003_media/sphere_timing.jpg" alt="Results for the 50x40x30 rectangular"></div>

It seems that setting up the matrix is not the main issue any more and we can proceed to bigger problems...