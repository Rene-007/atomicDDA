# 200_standardDDA

*In the last section we implemented a simple DDA and optimized the speed of setting up the matrix. In this chapter we will find its limitations and move to a more standard implementation.*

## Limitations

We take again our Gold sphere with the 50-nm diameter and this time tune the dipole spacing. When going from the original 5&thinsp;nm spacing to 4&thinsp;nm and later 2.5&thinsp;nm the number of dipoles first roughly doubles from 515 dipoles to 1018 and than octuplicate to 4169. This improves the quality of the spectra a lot (see below) as the unphysical ripples between 600&thinsp;nm and 750&thinsp;nm disappear. (Note, the spiky shape of the peak disappears when using finer discretizations of the spectrum.)

<div align="center"><img src="/003_media/sphere-50nm_invC_Comparison.jpg" alt="Results for the 50x40x30 rectangular"></div>

The notable point here is that the time for solving the problem increases by ~6x and ~250x, respectively. The reason for this very unfavourable behaviour is that inverting a matrix with _NxN_ elements scales with _O(N<sup>3</sup>)_. 