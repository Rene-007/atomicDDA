# 200_standardDDA_optimized-solvers

*In the last section we introduced standard DDA algorithms for solving the matrix equations. Here, we implement our own QMR code and introduce a very simple way for quicker finding solutions.* 

## A Simple Idea

So far we used starting vectors *x* filled with zeros and then iteratively work down to a local minimum. This took quite some time and we recorded up to 393 iterations in our few tests. Imagine, how much of these cycles and time could be saved if we would not always start at zero but already a bit further down closer to the minimum. 

But where is further down? Starting with random numbers would probably only help by accident. We need to find a systematic way for guessing.

One characteristics of our calculations is that we are solving a whole spectrum wavelength by wavenlength. So, an idea would be to solve the problem for one wavelength *n* and use this result *x<sub>results</sub>(n)* as a starting value *x<sub>start</sub>(n+1)* for the next wavelength. As the principle physical characteristics of the system does not change too much as long as the wavelength step is small enough, this means the polarizations of the dipoles should also not change too much and we might get some speedups. 

## Code Changes

So, we implemented our own version of the QMR algorithm, added the polarization to the parameter list it as well as the CCG/BCG Sarkar solvers and adapted the main file.

Changed Files       | Notes
:-----              |:--------
standardDDA.m       | main file
ccg_Sarkar.m        | outer starting value
bcg_Sarkar.m        | outer starting value
myqmr.m             | QMR solver after after Freud & Nachtigal 1991

The standardDDA.m is structured such that it easy to play around with the different solvers.


## Resuls

Running our standard example of a Gold sphere with the 50-nm diameter, 2.5-nm spacing and 4169 dipoles using the Sarkar CCG method give us now:

    >> standardDDA
    Number of dipole: 4169
    wav = 400nm -- setting up: 3.7s -- solver: 0.008849  14   3.3s 
    wav = 410nm -- setting up: 3.3s -- solver: 0.007831   6   1.5s 
    wav = 420nm -- setting up: 3.1s -- solver: 0.009993   6   1.7s 
    wav = 430nm -- setting up: 3.1s -- solver: 0.007282   7   1.9s 
    wav = 440nm -- setting up: 3.1s -- solver: 0.008893   6   1.7s 
    wav = 450nm -- setting up: 3.1s -- solver: 0.009102   6   1.7s 
    wav = 460nm -- setting up: 3.1s -- solver: 0.008895   6   1.7s 
    wav = 470nm -- setting up: 3.2s -- solver: 0.007853   6   1.5s 
    wav = 480nm -- setting up: 3.1s -- solver: 0.009088   5   1.5s 
    wav = 490nm -- setting up: 3.1s -- solver: 0.009182   5   1.5s 
    wav = 500nm -- setting up: 3.2s -- solver: 0.008281   7   1.7s 
    wav = 510nm -- setting up: 3.2s -- solver: 0.008355  11   2.6s 
    wav = 520nm -- setting up: 3.1s -- solver: 0.008678  16   3.8s 
    wav = 530nm -- setting up: 3.1s -- solver: 0.009916  21   4.9s 
    wav = 540nm -- setting up: 3.1s -- solver: 0.009777  27   6.1s 
    wav = 550nm -- setting up: 3.1s -- solver: 0.009802  32   7.2s 
    wav = 560nm -- setting up: 3.1s -- solver: 0.009870  37   8.2s 
    wav = 570nm -- setting up: 3.1s -- solver: 0.009860  42   9.4s 
    wav = 580nm -- setting up: 3.3s -- solver: 0.009715  51  10.9s 
    wav = 590nm -- setting up: 3.1s -- solver: 0.009950  56  12.3s 
    wav = 600nm -- setting up: 3.1s -- solver: 0.009899  56  12.1s 
    wav = 610nm -- setting up: 3.1s -- solver: 0.009960  61  13.4s 
    wav = 620nm -- setting up: 3.1s -- solver: 0.009987  75  16.3s 
    wav = 630nm -- setting up: 3.1s -- solver: 0.009932  75  16.1s 
    wav = 640nm -- setting up: 3.1s -- solver: 0.009975  79  17.0s 
    wav = 650nm -- setting up: 3.1s -- solver: 0.009904  84  18.1s 
    wav = 660nm -- setting up: 3.1s -- solver: 0.009971  84  18.2s 
    wav = 670nm -- setting up: 3.1s -- solver: 0.009932  86  18.6s 
    wav = 680nm -- setting up: 3.1s -- solver: 0.009947 106  22.6s 
    wav = 690nm -- setting up: 3.1s -- solver: 0.009962 112  23.9s 
    wav = 700nm -- setting up: 3.1s -- solver: 0.009988 124  26.4s 
    wav = 710nm -- setting up: 3.1s -- solver: 0.009939 130  27.7s 
    wav = 720nm -- setting up: 3.1s -- solver: 0.009994 142  30.5s 
    wav = 730nm -- setting up: 3.1s -- solver: 0.009947 146  31.5s 
    wav = 740nm -- setting up: 3.1s -- solver: 0.009942 136  28.9s 
    wav = 750nm -- setting up: 3.1s -- solver: 0.009995 147  31.6s 
    wav = 760nm -- setting up: 3.1s -- solver: 0.009996 203  43.5s 
    wav = 770nm -- setting up: 3.1s -- solver: 0.009959 196  41.5s 
    wav = 780nm -- setting up: 3.1s -- solver: 0.009973 220  46.6s 
    wav = 790nm -- setting up: 3.1s -- solver: 0.009993 184  39.0s 
    wav = 800nm -- setting up: 3.1s -- solver: 0.009994 134  28.5s 
    Overall required cpu time: 766.3s

One can see that for 400&thinsp;nm the result is exactly the same as in our [old code](../200_standardDDA/README.md#Results) but from the next wavelength on the number of iterations roughly halves and, hence, the solving time, too. The overall required cpu time is a bit longer than half of the original value due to a constant offset from the setting up time. The same is also true for QMR solver with 415.1&thinsp;s and the BCG solver with 551.9&thinsp;s.

Note, this relative speed improvement will accelarate when reducing the step size, e.g. to 5&thinsp;nm, 2&thinsp;nm or even 1&thinsp;nm. However, the overall computation time will become longer and one has to find the best trade off between speed and spectral accuracy.

[In the next section](../300_advancedDDA) we will show how another property of our simulation can help to dramatically speedup the calculations.