# 320_advancedDDA_FFT-optimized

*In the last section we introduced the FFT/convolution to our code which increased the speed a lot. In this section we will implement two further optimizations.*

## Optimizations

On problem with the code so far was, that the matrix <img src="..\003_media\azPQdhk1g1.svg"> was still pre-allocated even though it was not needed when selecting a FFT solver. Because it requires *NxN* memory, this restricted the maximum size of solvable problems considerable. Therefore, all non-FFT code was removed to allow solving larger problems.

The second optimization comes from the symmetry of the *3x3* tensor elements. As depicted [here](../100_simpleDDA#the-code), only 6 of the 9 elements are unique. Hence, by changing the layout of `A`/`fftA` and adapting the convolution function, a speedup of up to 33% should be possible. 


## Code Changes

Changed Files           | Notes
:-----                  |:--------
advancedDDA.m           | main file
create_fftA             | layout of A/fftA optimized
Conv3D                  | convolution adapted to the new A/fftA layout


## Results

The results of our standard example of a Gold sphere with the 50-nm diameter, 2.5-nm spacing and 4169 dipoles using the Sarkar CCG method give: 

    >> advancedDDA
    Building a 50nm x 50nm spheroid with 68921 grid points and 4169 dipoles
    wav = 400nm -- setting up: 0.0s -- solver: 0.009789   9   0.3s 
    wav = 410nm -- setting up: 0.0s -- solver: 0.009618   2   0.1s 
    wav = 420nm -- setting up: 0.0s -- solver: 0.004915   3   0.1s 
    wav = 430nm -- setting up: 0.0s -- solver: 0.007949   2   0.1s 
    wav = 440nm -- setting up: 0.0s -- solver: 0.009231   2   0.1s 
    wav = 450nm -- setting up: 0.0s -- solver: 0.008389   3   0.1s 
    wav = 460nm -- setting up: 0.0s -- solver: 0.007807   3   0.1s 
    wav = 470nm -- setting up: 0.0s -- solver: 0.007524   3   0.1s 
    wav = 480nm -- setting up: 0.0s -- solver: 0.009954   2   0.1s 
    wav = 490nm -- setting up: 0.0s -- solver: 0.008249   3   0.1s 
    wav = 500nm -- setting up: 0.0s -- solver: 0.006245   4   0.2s 
    wav = 510nm -- setting up: 0.0s -- solver: 0.008486   5   0.2s 
    wav = 520nm -- setting up: 0.0s -- solver: 0.009005   8   0.3s 
    wav = 530nm -- setting up: 0.0s -- solver: 0.009367  11   0.4s 
    wav = 540nm -- setting up: 0.0s -- solver: 0.009306  14   0.4s 
    wav = 550nm -- setting up: 0.0s -- solver: 0.009684  15   0.5s 
    wav = 560nm -- setting up: 0.0s -- solver: 0.009445  16   0.5s 
    wav = 570nm -- setting up: 0.0s -- solver: 0.009952  15   0.5s 
    wav = 580nm -- setting up: 0.0s -- solver: 0.009950  16   0.5s 
    wav = 590nm -- setting up: 0.0s -- solver: 0.009890  17   0.6s 
    wav = 600nm -- setting up: 0.0s -- solver: 0.009754  19   0.6s 
    wav = 610nm -- setting up: 0.0s -- solver: 0.009640  19   0.6s 
    wav = 620nm -- setting up: 0.0s -- solver: 0.009932  17   0.6s 
    wav = 630nm -- setting up: 0.0s -- solver: 0.009775  19   0.6s 
    wav = 640nm -- setting up: 0.0s -- solver: 0.009694  18   0.6s 
    wav = 650nm -- setting up: 0.0s -- solver: 0.009868  20   0.6s 
    wav = 660nm -- setting up: 0.0s -- solver: 0.009896  19   0.6s 
    wav = 670nm -- setting up: 0.0s -- solver: 0.009897  20   0.6s 
    wav = 680nm -- setting up: 0.0s -- solver: 0.009900  20   0.6s 
    wav = 690nm -- setting up: 0.0s -- solver: 0.009806  21   0.7s 
    wav = 700nm -- setting up: 0.0s -- solver: 0.009944  20   0.6s 
    wav = 710nm -- setting up: 0.0s -- solver: 0.009817  22   0.7s 
    wav = 720nm -- setting up: 0.0s -- solver: 0.009868  22   0.7s 
    wav = 730nm -- setting up: 0.0s -- solver: 0.009905  23   0.7s 
    wav = 740nm -- setting up: 0.0s -- solver: 0.009985  23   0.7s 
    wav = 750nm -- setting up: 0.0s -- solver: 0.009915  25   0.8s 
    wav = 760nm -- setting up: 0.0s -- solver: 0.009999  23   0.7s 
    wav = 770nm -- setting up: 0.0s -- solver: 0.009934  27   0.8s 
    wav = 780nm -- setting up: 0.0s -- solver: 0.009978  24   0.8s 
    wav = 790nm -- setting up: 0.0s -- solver: 0.009939  28   0.9s 
    wav = 800nm -- setting up: 0.0s -- solver: 0.009988  23   0.7s 
    Overall required cpu time: 20.4s


As expected, compared to the formerly 31.3&thinsp;s the code is now 33% faster. But thanks to the modern times we are living in, [there is still much more to come...](../330_advancedDDA_GPU)