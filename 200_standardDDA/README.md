# 200_standardDDA

*In the last section we implemented a simple DDA and optimized the speed of setting up the matrix. In this chapter we will find its limitations and move to a more standard implementation.*

## Limitations

We take again our Gold sphere with the 50-nm diameter and this time tune the dipole spacing. When going from the original 5&thinsp;nm spacing to 4&thinsp;nm and later 2.5&thinsp;nm the number of dipoles first roughly doubles from 515 dipoles to 1018 and than octuplicate to 4169. This improves the quality of the spectra a lot (see below) as the unphysical ripples between 600&thinsp;nm and 750&thinsp;nm disappear. (Note, the spiky shape of the peak disappears when using finer discretizations of the spectrum.)

<div align="center"><img src="/003_media/sphere-50nm_invC_Comparison.jpg" alt="Results for the 50x40x30 rectangular"></div>

A notable point here is that the time for solving the problem increases by ~6x and ~250x, respectively. The reason for this very bad scaling is that inverting a matrix with _NxN_ elements scales with _O(N<sup>3</sup>)_. So, when further doubling the number of dipole (spacing 2.0&thinsp;nm) we obtain:

    > standardDDA
    Number of dipole: 8144
    wav = 400nm -- setting up: 13.9s -- solver: 0.000000   0 260.5s 

This means, calculating the whole spectrum (41 wavelengths) would take around 3 hours and a 100-nm sphere (8x the dipoles) probably one month! This is hardly acceptable -- the computer I am using is already a *AMD Ryzen 9 5950X* with 16 cores and 32 threads. 

One big benefit of our current approach with inverting the matrix is that because of

<!-- $$
\mathbf{P} = \mathbf{C}^{-1} \mathbf{{E}}_{\textrm{exci}} \, .
$$ --> 

<div align="center"><img style="background: white;" src="..\003_media\hNj6OWj9xJ.svg"></div> 

we only have to invert <!-- $\mathbf{C}$ --> <img style="transform: translateY(0.05em);" src="..\003_media\k3DdFIe8PY.svg"> once and can use that for simulating all different kinds of excitations, e.g. different angles of incidence & polarization, focused beams, dipole excitations and so on. This sounds very appealing. However, the _O(N<sup>3</sup>)_ scaling does not only mean that inverting the matrix is very slow but also that the result might be numerically wrong. The reason is that we are dealing with floating point numbers which show small round-off errors [<img src="../003_media/External.svg" height="14">](https://en.wikipedia.org/wiki/Round-off_error) with nearly every arithmetic operation and, hence, when we have _O(N<sup>3</sup>)_ compuational steps that take days this can easily happen.

So, it is worth to look for a better overall approach.

## Solution

