# 200_standardDDA

*In the last section we implemented a simple DDA and optimized the speed of setting up the matrix. In this chapter we will find its limitations and move to a more standard implementation.*

## Limitations

This time we simulate a Gold sphere with a diameter of 50nm, 5nm spacing and 515 dipoles. The console output is:

<div align="center"><img src="/003_media/sphere-50nm_invC_Comparison.jpg" alt="Results for the 50x40x30 rectangular"></div>

It seems that setting up the matrix is not the main issue any more and we can proceed to bigger problems...