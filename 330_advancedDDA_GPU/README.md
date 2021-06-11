# 330_advancedDDA_GPU

*In the last two section we introduced and optimized the FFT/convolution in our code. Now we will utilized the power of GPUs to optain significant perfomance improvements*

## Matlab and GPUs

Utilizing the compute capabilities of GPUs is not easy. Fortunately, Matlab implemented an easy but still powerful abstraction for using it. 

The main thing to do is to wrap data `x_cpu` in a data structure on the GPU via `x_gpu = gpuArray(x_cpu)`. This sends the data to the GPU and, if done for all essential data structures, the evaluation will already take place directly on the GPU. At the end, the data can be transfered back via `x_cpu = gather(x_gpu)`. But be aware, that profiling computations on the GPU using Matlab can be quite misleading as the profiler runs on the CPU.


## Code Changes

Changed Files           | Notes
:-----                  |:--------
advancedDDA.m           | main file
ccg_Sarkar_GPU.m        | CCG method using the GPU
myqmr_GPU.m             | QMR method using the GPU

The advancedDDA.m is structured such that it easy to switch between the standard FFT solvers and the solvers utilizing the GPU.


## Results


The results of our standard example of a Gold sphere with the 50-nm diameter, 2.5-nm spacing and 4169 dipoles using the Sarkar CCG method and a NVidia RTX 3090 are:

    >> advancedDDA
    Building a 50nm x 50nm spheroid with 68921 grid points and 4169 dipoles
    wav = 400nm -- setting up: 0.0s -- solver: 0.009789   9   0.0s 
    wav = 410nm -- setting up: 0.0s -- solver: 0.009618   2   0.0s 
    wav = 420nm -- setting up: 0.0s -- solver: 0.004915   3   0.0s 
    wav = 430nm -- setting up: 0.0s -- solver: 0.007949   2   0.0s 
    wav = 440nm -- setting up: 0.0s -- solver: 0.009231   2   0.0s 
    wav = 450nm -- setting up: 0.0s -- solver: 0.008389   3   0.0s 
    wav = 460nm -- setting up: 0.0s -- solver: 0.007807   3   0.0s 
    wav = 470nm -- setting up: 0.0s -- solver: 0.007524   3   0.0s 
    wav = 480nm -- setting up: 0.0s -- solver: 0.009954   2   0.0s 
    wav = 490nm -- setting up: 0.0s -- solver: 0.008249   3   0.0s 
    wav = 500nm -- setting up: 0.0s -- solver: 0.006245   4   0.0s 
    wav = 510nm -- setting up: 0.0s -- solver: 0.008486   5   0.0s 
    wav = 520nm -- setting up: 0.0s -- solver: 0.009005   8   0.0s 
    wav = 530nm -- setting up: 0.0s -- solver: 0.009367  11   0.0s 
    wav = 540nm -- setting up: 0.0s -- solver: 0.009306  14   0.0s 
    wav = 550nm -- setting up: 0.0s -- solver: 0.009684  15   0.0s 
    wav = 560nm -- setting up: 0.0s -- solver: 0.009445  16   0.0s 
    wav = 570nm -- setting up: 0.0s -- solver: 0.009952  15   0.1s 
    wav = 580nm -- setting up: 0.0s -- solver: 0.009950  16   0.1s 
    wav = 590nm -- setting up: 0.0s -- solver: 0.009890  17   0.0s 
    wav = 600nm -- setting up: 0.0s -- solver: 0.009754  19   0.1s 
    wav = 610nm -- setting up: 0.0s -- solver: 0.009640  19   0.1s 
    wav = 620nm -- setting up: 0.0s -- solver: 0.009932  17   0.0s 
    wav = 630nm -- setting up: 0.0s -- solver: 0.009775  19   0.1s 
    wav = 640nm -- setting up: 0.0s -- solver: 0.009694  18   0.0s 
    wav = 650nm -- setting up: 0.0s -- solver: 0.009868  20   0.1s 
    wav = 660nm -- setting up: 0.0s -- solver: 0.009896  19   0.1s 
    wav = 670nm -- setting up: 0.0s -- solver: 0.009897  20   0.1s 
    wav = 680nm -- setting up: 0.0s -- solver: 0.009900  20   0.1s 
    wav = 690nm -- setting up: 0.0s -- solver: 0.009806  21   0.1s 
    wav = 700nm -- setting up: 0.0s -- solver: 0.009944  20   0.1s 
    wav = 710nm -- setting up: 0.0s -- solver: 0.009817  22   0.1s 
    wav = 720nm -- setting up: 0.0s -- solver: 0.009868  22   0.1s 
    wav = 730nm -- setting up: 0.0s -- solver: 0.009906  23   0.1s 
    wav = 740nm -- setting up: 0.0s -- solver: 0.009989  23   0.1s 
    wav = 750nm -- setting up: 0.0s -- solver: 0.009920  25   0.1s 
    wav = 760nm -- setting up: 0.0s -- solver: 0.009999  23   0.1s 
    wav = 770nm -- setting up: 0.0s -- solver: 0.009925  27   0.1s 
    wav = 780nm -- setting up: 0.0s -- solver: 0.009969  24   0.1s 
    wav = 790nm -- setting up: 0.0s -- solver: 0.009945  28   0.1s 
    wav = 800nm -- setting up: 0.0s -- solver: 0.009932  24   0.1s 
    Overall required cpu time: 2.8s


Besides the first run being somewhat slower due to the initialization of the GPU, the results shown here are very encouraging. Switching from a AMD Ryzen 5950X CPU to a Nvidia RTX 3090 GPU resulted in nearly another *10x* speed up. But, [more improvements are yet to come.](../340_advancedDDA_GPU-optimized)