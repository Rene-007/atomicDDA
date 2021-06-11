# 340_advancedDDA_GPU-optimized

~~*In the last section we implemented the standard DDA and optimizing the solver to improve the performance by a __factor of two__. In this chapter we utilize the symmetry of the system and hardware acceleration to improve the performance by more than __two orders of magnitude__. In this subchapter we lay the groundwork for that*~~

QMR results

    >> advancedDDA
    Building a 50nm x 50nm spheroid with 68921 grid points and 4169 dipoles
    wav = 400nm -- setting up: 0.0s -- solver: 0.007076   6   0.0s 
    wav = 410nm -- setting up: 0.0s -- solver: 0.009151   1   0.0s 
    wav = 420nm -- setting up: 0.0s -- solver: 0.009884   2   0.0s 
    wav = 430nm -- setting up: 0.0s -- solver: 0.005039   3   0.0s 
    wav = 440nm -- setting up: 0.0s -- solver: 0.006953   1   0.0s 
    wav = 450nm -- setting up: 0.0s -- solver: 0.008004   2   0.0s 
    wav = 460nm -- setting up: 0.0s -- solver: 0.009185   2   0.0s 
    wav = 470nm -- setting up: 0.0s -- solver: 0.009860   2   0.0s 
    wav = 480nm -- setting up: 0.0s -- solver: 0.009962   2   0.0s 
    wav = 490nm -- setting up: 0.0s -- solver: 0.005884   3   0.0s 
    wav = 500nm -- setting up: 0.0s -- solver: 0.007659   3   0.0s 
    wav = 510nm -- setting up: 0.0s -- solver: 0.008900   4   0.0s 
    wav = 520nm -- setting up: 0.0s -- solver: 0.008525   6   0.0s 
    wav = 530nm -- setting up: 0.0s -- solver: 0.008895   6   0.0s 
    wav = 540nm -- setting up: 0.0s -- solver: 0.009014   6   0.0s 
    wav = 550nm -- setting up: 0.0s -- solver: 0.009137   6   0.0s 
    wav = 560nm -- setting up: 0.0s -- solver: 0.009910   7   0.0s 
    wav = 570nm -- setting up: 0.0s -- solver: 0.009903   8   0.0s 
    wav = 580nm -- setting up: 0.0s -- solver: 0.008990   9   0.0s 
    wav = 590nm -- setting up: 0.0s -- solver: 0.009855   7   0.0s 
    wav = 600nm -- setting up: 0.0s -- solver: 0.009636   9   0.0s 
    wav = 610nm -- setting up: 0.0s -- solver: 0.009486   9   0.0s 
    wav = 620nm -- setting up: 0.0s -- solver: 0.009938   7   0.0s 
    wav = 630nm -- setting up: 0.0s -- solver: 0.009749   9   0.0s 
    wav = 640nm -- setting up: 0.0s -- solver: 0.009992   6   0.0s 
    wav = 650nm -- setting up: 0.0s -- solver: 0.009784   7   0.0s 
    wav = 660nm -- setting up: 0.0s -- solver: 0.009993   6   0.0s 
    wav = 670nm -- setting up: 0.0s -- solver: 0.009944   8   0.0s 
    wav = 680nm -- setting up: 0.0s -- solver: 0.009932   7   0.0s 
    wav = 690nm -- setting up: 0.0s -- solver: 0.009910   8   0.0s 
    wav = 700nm -- setting up: 0.0s -- solver: 0.009840   7   0.0s 
    wav = 710nm -- setting up: 0.0s -- solver: 0.009351   9   0.0s 
    wav = 720nm -- setting up: 0.0s -- solver: 0.009865   3   0.0s 
    wav = 730nm -- setting up: 0.0s -- solver: 0.009627  10   0.0s 
    wav = 740nm -- setting up: 0.0s -- solver: 0.009840   7   0.0s 
    wav = 750nm -- setting up: 0.0s -- solver: 0.009962  10   0.0s 
    wav = 760nm -- setting up: 0.0s -- solver: 0.009839  10   0.0s 
    wav = 770nm -- setting up: 0.0s -- solver: 0.009948  10   0.0s 
    wav = 780nm -- setting up: 0.0s -- solver: 0.009689  11   0.0s 
    wav = 790nm -- setting up: 0.0s -- solver: 0.009979   6   0.0s 
    wav = 800nm -- setting up: 0.0s -- solver: 0.009945  10   0.0s 
    Overall required cpu time: 1.1s                            


QMR 1-nm spacing # 1-nm pitch # tol 1e-2 -> 1e-3

    >> advancedDDA
    Building a 50nm x 50nm spheroid with 1030301 grid points and 65267 dipoles
    wav = 400nm -- setting up: 0.0s -- solver: 0.000738  11   0.1s 
    wav = 401nm -- setting up: 0.0s -- solver: 0.000862   1   0.0s 
    wav = 402nm -- setting up: 0.0s -- solver: 0.000934   2   0.0s 
    wav = 403nm -- setting up: 0.0s -- solver: 0.000457   3   0.0s 
    wav = 404nm -- setting up: 0.0s -- solver: 0.000670   1   0.0s 
    wav = 405nm -- setting up: 0.0s -- solver: 0.000816   2   0.0s 
    wav = 406nm -- setting up: 0.0s -- solver: 0.000878   2   0.0s 
    wav = 407nm -- setting up: 0.0s -- solver: 0.000880   2   0.0s 
    wav = 408nm -- setting up: 0.0s -- solver: 0.000954   1   0.0s 
    wav = 409nm -- setting up: 0.0s -- solver: 0.000916   2   0.0s 
    wav = 410nm -- setting up: 0.0s -- solver: 0.000997   1   0.0s 
     .
     .
     . 
    wav = 790nm -- setting up: 0.0s -- solver: 0.000997  20   0.1s 
    wav = 791nm -- setting up: 0.0s -- solver: 0.000999  20   0.1s 
    wav = 792nm -- setting up: 0.0s -- solver: 0.001000  20   0.1s 
    wav = 793nm -- setting up: 0.0s -- solver: 0.000995  21   0.1s 
    wav = 794nm -- setting up: 0.0s -- solver: 0.000996  20   0.1s 
    wav = 795nm -- setting up: 0.0s -- solver: 0.000996  20   0.1s 
    wav = 796nm -- setting up: 0.0s -- solver: 0.000995  20   0.1s 
    wav = 797nm -- setting up: 0.0s -- solver: 0.000995  20   0.1s 
    wav = 798nm -- setting up: 0.0s -- solver: 0.001000  19   0.1s 
    wav = 799nm -- setting up: 0.0s -- solver: 0.000998  20   0.1s 
    wav = 800nm -- setting up: 0.0s -- solver: 0.000997  20   0.1s 
    Overall required cpu time: 67.2s