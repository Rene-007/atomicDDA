# atomicDDA

Simulating the optical properties of metal nanostructure is a well-established field with methods such as FDTD, FEM or BEM beeing commonly used. However, when reaching out for the ultimate precission like atomic-scale gaps in nanoparticle dimers, these methods facing problems: Besides numerical difficulties in the gap region (discretization/stability) they simply do not reflect the underlying atomic arrangement of the geometry properly.

![A gold dimer ready to be simulated](/003_media/regrown-dimer_1-000-000-atoms.jpg "A gold dimer ready to be simulated")

Here we present the atomic Discrete Dipole Approximation (atomicDDA) which solves these problems. As its name implies it is based on the Discrete Dipole Approximation (DDA), uses the known convolution method to improve on computation time as well as memory usage and implements atomic lattices with stacking faults to mimic typical arrangements of e.g. atoms in gold flakes and structures thereof. It is implemented to also run on modern GPUs, making it possible to solve the problem over a full spectrum (400-900nm, pitch 5nm) for a 1,000,000 atom dimer in 25 minutes.

# Outline

This repository aims on the one hand to be a step-by-step introduction to DDA as well as some of its optimizations to make it productive enough, and on the other hand shows how atomic lattices with stacking faults can be implemented to make the simulation of the above mentioned atomic-gap dimers feasible.

The code was originally developed with [Matlab](https://www.mathworks.com/products/matlab.html "Link to Matlab product page from MathWorks") but implementation in [Julia](https://julialang.org/ "Link to the Julia programming language homepage") and [Rust](https://www.rust-lang.org/ "Linkt to the Rust programming language homepage") are intended. It is divided in four main chapters and several subsections:

__I. A simple introduction to the Discrete Dipole Approximation__
  * [100_simpleDDA](100_simpleDDA/)  
    _The basic outline of the theory and an easy to follow simple implementation._
  * [110_simpleDDA_faster-setup](110_simpleDDA_faster-setup)  
    _Some optimizations to the matrix setup._
    
__II. The standard way of solving__
  * [200_standardDDA]()    
    _Introduction to solvers and how to implement own ones._
  * [210_standardDDA_optimized-solvers]()    
    _A simple way for pre-conditioning the matrix._

__III. Advanced features to drastically improve the performance__
  * [300_advancedDDA]()  
    _Introduction of and preparations for the convolution method._    
  * [310_advancedDDA_FFT]()  
    _Implementation of the convolution method._
  * [320_advancedDDA_FFT-optimized]()  
    _Optimization of the solving algorithm._
  * [330_advancedDDA_GPU]()  
    _Solving the problem much faster on the GPU._
  * [340_advancedDDA_GPU-optimized]()  
    _Final GPU optimizations._

__IV. The atomicDDA__
  * [400_atomicDDA]()  
    _Introducing face-centered cubic packaging._    
  * [410_atomicDDA_lattices]()  
    _Generalization of the code for different lattices._
  * [420_atomicDDA_stacking-faults]()  
    _Adding a lattice with stacking faults._
  * [430_atomicDDA_flakes]()  
    _Importing and solving arbitrary structures based on flakes._
  * [440_atomicDDA_flatten]()  
    _Bonus. A different memory layout._

The chapters and subsection encode the first and second numbers of the subreporitories, resepectively, and the third number indicate the programming language (0 = Matlab, 1 = Julia, 2 = Rust). The subreporitories are self contained and only [000_data]() is needed for optical / flake data.


## Credits
The discrete dipole approximation is a well-estabished method and I like to mention a few publications this code is based on:
* bla
* bli
* blub update


## License
This project is licensed under the [GNU General Public License v2.0](LICENSE "Link to the GPL") and if you publish scientific work which is based on this code I would be grateful if you include a reference to this Github source page. If you have any issues with that feel free to contact me.


## Contributions
Contributions such as bug fixes or enhancements are welcome -- especially extensions such as [incorporating a substrate]().