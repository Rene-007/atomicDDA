# 200_standardDDA

*In the last section we implemented a simple DDA and optimized the speed of setting up the matrix. In this chapter we will find its limitations and move to a more standard implementation.*

## Limitations

We take again our Gold sphere with a diameter of 50&thinsp;nm and this time tune the dipole spacing. When going from the original 5nm spacing to 4nm and later 2.5&thinsp;nm the number of dipoles first roughly doubles from 515 dipoles to 1018 and than octuplicate to 4169. This improves the physicality of the spectra a lot -- the ripples between 600&thinsp;nm and 750&thinsp;nm disappear as can be seen below. (The )

<div align="center"><img src="/003_media/sphere-50nm_invC_Comparison.jpg" alt="Results for the 50x40x30 rectangular"></div>

It seems that setting up the matrix is not the main issue any more and we can proceed to bigger problems...