# 100_simpleDDA

*In this chapter we will give an introduction to the Discrete Dipole Approximation (DDA), show how to implement it in a simple way and discuss the results.*
  * [An Introduction to the Discrete Dipole Approximation (DDA)](#an-introduction-to-the-discrete-dipole-approximation--dda-)
  * [Solving the Problem](#solving-the-problem)
  * [The Code](#the-code)
  * [Results](#typical-results)



## An Introduction to the Discrete Dipole Approximation (DDA)

The Discrete Dipole Approximation (DDA) is a method to simulate the interaction of light with arbitrary shaped particles or structures. 

In order to do so the volume of these objects are divided into equally-sized cells that depending on the material (e.g. free electrons in metals or valence electrons in dielectrics)  contains charges. As an example the figure below shows such a discretization of a 50x40x30 rectangular cuboid into 693 unit cells with the center being marked with crosses.

<div align="center"><img src="/003_media/rectangular-cuboid.jpg" alt="A 50x40x30 rectangular cuboid divided into dipoles"></div>

When now an outer electric field <!-- $\mathbf{E}_{\textrm{app},i}$ --> <img style="transform: translateY(0.3em);" src="..\003_media\BoMm4lrha6.svg"> is applied the charges in each cell <!-- $i$ --> <img style="transform: translateY(0.0em);" src="..\003_media\sUC8llATVV.svg"> will move around slightly and, hence, a polarization is created. The key idea of the DDA is to model this by placing a dipole in each cell as it makes it easy to assign a polarization:

<!-- $$
\mathbf{P}_{i}={\alpha}\mathbf{{E}}_{\textrm{app},i} 
$$ --> 

<div align="center"><img src="..\003_media\7l550EKCxe.svg"></div>

with  <!-- $\mathbf{\alpha}$ --> <img style="transform: translateY(0.0em);" src="..\003_media\cBuXoa3TIs.svg"> being the polarizability of the dipole. The polarizability is a "known" material constant such that we get an easy relation between the applied field and the resulting polarization. (As a side note, for more complicated anisotropic inhomogeneous materials the scaler <!-- $\mathbf{\alpha}$ --> <img style="transform: translateY(0.0em);" src="..\003_media\KlQJu7aeVz.svg"> becomes a tensor and location dependent quantity <!-- $\bar{\alpha}_i$ --> <img style="transform: translateY(0.15em);" src="..\003_media\AlyOInu0mL.svg"> but the basic formalism stays the same.) 

Now, when we have an alternating applied field, such as it is the case for light, and assume a frequency <!-- $\omega$ --> <img style="transform: translateY(0.0em);" src="..\003_media\dy0eTxOXn1.svg">, then each dipole also generates an electric field [<img src="../003_media/External.svg" height="14">](https://en.wikipedia.org/wiki/Dipole#Dipole_radiation) in the form of (cgs units [<img src="../003_media/External.svg" height="14">](https://en.wikipedia.org/wiki/Centimetre%E2%80%93gram%E2%80%93second_system_of_units#Various_extensions_of_the_CGS_system_to_electromagnetism)):

<!-- $$
\mathbf{E}_{\textrm{gen},i}(\mathbf{r}) = \left\{
    \frac{\omega^2}{c^2 r} \left( \mathbf{\hat{r}} \times \mathbf{P}_{i} \right) \times \mathbf{\hat{r}} +
    \left( \frac{1}{r^3} - \frac{i\omega}{cr^2} \right)
    \left( 3\mathbf{\hat{r}} \left[\mathbf{\hat{r}} \cdot \mathbf{P}_{i}\right] - \mathbf{P}_{i} \right)
\right\} e^\frac{i\omega r}{c} e^{-i\omega t} 
$$ --> 

<div align="center"><img src="..\003_media\T4KXvt2sbr.svg"></div> 


with <!-- $\mathbf{\hat{r}}$ --> <img style="transform: translateY(0.0em);" src="..\003_media\R89QpqQ5UJ.svg"> being the unit distance vector from the dipole's origin, <!-- $r$ --> <img style="transform: translateY(0.0em);" src="..\003_media\bC1Zxw43cV.svg"> the distance, <!-- $c$ --> <img style="transform: translateY(0.0em);" src="..\003_media\dx2v3eoWaA.svg"> the velocity of light and <!-- $t$ --> <img style="transform: translateY(0.0em);" src="..\003_media\L2DKQFtGsG.svg"> a point in time. This express may seem to be a bit scary for some of the readers, but we will be simplifying it quite a bit further down.

Nevertheless, the main message here is, that the polarization of the dipoles also generates an electric field which impacts its surrounding. Hence, the applied outer electric field for each dipole does not only consist of the excitation field <!-- $\mathbf{{E}}_{\textrm{exci},i}$ --> <img style="transform: translateY(0.35em);" src="..\003_media\LqM0ZF11ax.svg">, e.g. for a plane wave we could simply write  <!-- $\mathbf{E}_{0} \cdot e^{-i\omega t} $ --> <img style="transform: translateY(0.15em);" src="..\003_media\G83ZTU4N2h.svg"> [<img src="../003_media/External.svg" height="14">](https://en.wikipedia.org/wiki/Sinusoidal_plane_wave), but also the generated fields of all other dipoles:

<!-- $$
\mathbf{{E}}_{\textrm{app},i} = \mathbf{{E}}_{\textrm{exci},i} + \sum _{i\neq j} \mathbf{{E}}_{\textrm{gen},j}(\mathbf{r}_j) \,.
$$ --> 

<div align="center"><img src="..\003_media\MEVpSbXGUR.svg"></div> 

Considering that each dipole talks to all other dipoles and the other way around, this gives us a coupled system.

## Solving the Problem

To solve the problem we reformulate it in the frequency domain, i.e. leave out the <!-- $e^{-i\omega t} $ --> <img style="transform: translateY(0.0em);" src="..\003_media\dGvvyTmTbn.svg"> terms and replace <!-- $\omega/c$ --> <img style="transform: translateY(0.25em);" src="..\003_media\uKytIIRT1m.svg"> by the wavevector <!-- $k$ --> <img style="transform: translateY(0.0em);" src="..\003_media\zyAiNITSFv.svg">, as well as define <!-- $\mathbf{r}_{ij}$ --> <img style="transform: translateY(0.3em);" src="..\003_media\ShEZ36Mh3t.svg"> as being the distance vector between the <!-- $i^{th}$ --> <img style="transform: translateY(0.0em);" src="..\003_media\qRHSMhajjc.svg"> and <!-- $j^{th}$ --> <img style="transform: translateY(0.3em);" src="..\003_media\yxl9pCar6O.svg"> cell. This results in a generated field of the <!-- $i^{th}$ --> <img style="transform: translateY(0.0em);" src="..\003_media\rtl2BCu6EG.svg"> dipole at the position of the <!-- $j^{th}$ --> <img style="transform: translateY(0.3em);" src="..\003_media\Bodqv6puQc.svg"> dipole of: 

<!-- $$
\mathbf{E}_{\textrm{gen},ij} = \frac{e^{i k r_{ij}}}{r_{ij}} \left\{
    k^2 \left( \mathbf{\hat{r}}_{ij} \times \mathbf{P}_{i} \right) \times \mathbf{\hat{r}}_{ij} +
    \left( \frac{1}{r^2_{ij}} - \frac{ik}{r_{ij}} \right)
    \left( 3\mathbf{\hat{r}}_{ij} \left[\mathbf{\hat{r}}_{ij} \cdot \mathbf{P}_{i}\right] - \mathbf{P}_{i} \right)
\right\}  
$$ --> 

<div align="center"><img src="..\003_media\h6QigwtGsW.svg"></div> 


This formlula can be simplified by using the Graßmann identity (bac-cab rule [<img src="../003_media/External.svg" height="14">](https://en.wikipedia.org/wiki/Triple_product#Vector_triple_product)) and additionally we already change the sign for more convenience further down:
<!-- $$ 
\mathbf{{E}}_{\textrm{gen},ij} 
= \underbrace{ -
    \frac{e^{i k r_{ij}}}{r_{ij}} k^2 \left[
    \left( \hat{r}_{ij} \hat{r}_{ij} \right) - \mathbf{I}  +
    \left( -\frac{1}{k^2r_{ij}^2} + \frac{i}{kr_{ij}} \right)
    \left( 3\hat{r}_{ij} \hat{r}_{ij} - \mathbf{I} \right)
    \right] }_{\large{\mathbf{A}_{ij}}}
\mathbf{P}_{j} \, .
$$ --> 

<div align="center"><img src="..\003_media\CGY8HRM2CZ.svg"></div> 


Due to the cross-product expansion we were able to extract <!-- $\mathbf{P}_{j}$ --> <img style="transform: translateY(0.3em);" src="..\003_media\pElt6ZhZta.svg"> to the right and, as indicated with the underbrace, define an interaction matrix <!-- $\mathbf{A}$ --> <img style="transform: translateY(0.0em);" src="..\003_media\azPQdhk1g1.svg">. By also defining a second matrix <!-- $\mathbf{B}$ --> <img style="transform: translateY(0.0em);" src="..\003_media\9J2TDIO03N.svg"> with only diagonal values of <!-- $\alpha^{-1}$ --> <img style="transform: translateY(0.0em);" src="..\003_media\IuvjKmSwvX.svg"> we can now write down:

<!-- $$
\mathbf{E}_{\textrm{exci},i} = \mathbf{{E}}_{\textrm{app},i} -  \sum _{i\neq j} \mathbf{{E}}_{\textrm{gen},j} = \mathbf{B}_{ii} \mathbf{P}_{i} + \sum _{i\neq j} \mathbf{A}_{ij} \mathbf{P}_{j}
$$ --> 

<div align="center"><img src="..\003_media\JVxPAf15Yz.svg"></div> 

This can be further reduced by combining <!-- $\mathbf{A}$ --> <img style="transform: translateY(0.0em);" src="..\003_media\g6hoF3MfXJ.svg"> and <!-- $\mathbf{B}$ --> <img style="transform: translateY(0.05em);" src="..\003_media\GYtED7qkN1.svg"> to an extended interaction matrix <!-- $\mathbf{C}$ --> <img style="transform: translateY(0.05em);" src="..\003_media\k3DdFIe8PY.svg"> which results in the simple expression:
<!-- $$
\sum \mathbf{C}_{ij} \mathbf{P}_{j} = \mathbf{{E}}_{\textrm{exci},i} \, .
$$ --> 

<div align="center"><img src="..\003_media\HH1zgyYYXx.svg"></div> 

Now, for the final step it is clearest to write down everything in pure matrix-vector notation
<!-- $$
\mathbf{C} \mathbf{P} = \mathbf{{E}}_{\textrm{exci}}
$$ --> 

<div align="center"><img src="..\003_media\jaSU1ZR94K.svg"></div>

as the solution is now obvious
<!-- $$
\mathbf{P} = \left( \mathbf{C}^{-1} \mathbf{C} \right) \mathbf{P}
= \mathbf{C}^{-1} \left( \mathbf{C} \mathbf{P} \right) 
= \mathbf{C}^{-1} \mathbf{{E}}_{\textrm{exci}} \, .
$$ --> 

<div align="center"><img src="..\003_media\l3Rkqnz2wk.svg"></div>

This means, only the inverse matrix of <!-- $\mathbf{C}$ --> <img style="transform: translateY(0.0em);" src="..\003_media\PUJZU6MhJT.svg"> needs to be calculate and multiplied with the excitation field in order to solve the problem.


## The Code

The Matlab code is annotated to make it easier to follow and here is an overview of the files as they occurrence inside the code.

Filename            | Purpose
:-----              |:--------
simpleDDA.m         | main file
create_Cuboid.m     | geometry definition
create_Sphere.m     | geometry definition
create_Spheroid.m   | geometry definition
n_Gold.m            | load optical properties of Gold (needed for <img style="transform: translateY(0.0em);" src="..\003_media\cBuXoa3TIs.svg">)
alpha_CM.m          | calc polariability after Clausius-Mossoti
create_C_simple.m   | setting up the extended interaction matrix <img style="transform: translateY(0.05em);" src="..\003_media\k3DdFIe8PY.svg">
C_abs               | calc absorption cross section
C_ext               | calc extinction cross section

The setting up of the matrix follows the Notation of [Schmehl et al. <img src="../003_media/External.svg" height="14">](https://www.doi.org/10.1364/JOSAA.14.003026) but in cgs units:

<!-- $$
\mathbf{A}_{ij} = c_{ij} \begin{bmatrix}
\beta_{ij} + \gamma_{ij} \hat{r}^2_{ij,x}  & \gamma_{ij} \hat{r}_{ij,x} \hat{r}_{ij,y}  & \gamma_{ij} \hat{r}_{ij,x} \hat{r}_{ij,z}  \\
\gamma_{ij} \hat{r}_{ij,y} \hat{r}_{ij,x}  & \beta_{ij} + \gamma_{ij} \hat{r}^2_{ij,y}  & \gamma_{ij} \hat{r}_{ij,y} \hat{r}_{ij,z}  \\
\gamma_{ij} \hat{r}_{ij,z} \hat{r}_{ij,x}  & \gamma_{ij} \hat{r}_{ij,z} \hat{r}_{ij,y}  & \beta_{ij} + \gamma_{ij} \hat{r}^2_{ij,z} 
\end{bmatrix}
$$ --> 

<div align="center"><img src="..\003_media\Fl78iKqkxF.svg"></div>

with <!-- $\mathbf{\hat{r}}_{ij}$ --> <img style="transform: translateY(0.3em)" src="..\003_media\yHRlTRR0yr.svg"> being the unit distance vector between the <!-- $i^{th}$ --> <img style="transform: translateY(0.0em);" src="..\003_media\qRHSMhajjc.svg"> and <!-- $j^{th}$ --> <img style="transform: translateY(0.3em);" src="..\003_media\yxl9pCar6O.svg"> dipole as defined above and

<!-- $$
c_{ij} = - \frac{e^{i k r_{ij}}}{r_{ij}} k^2 
$$ --> 
<div align="center"><img  src="..\003_media\loyhG7Xf8s.svg"></div>

<!-- $$
\beta_{ij} = \left[ 1 -  \frac{1}{k^2r_{ij}^2} + \frac{i}{kr_{ij}} \right]
$$ --> 
<div align="center"><img src="..\003_media\wvFcbQQ1uv.svg"></div>

<!-- $$
\gamma_{ij} = - \left[ 1 -  \frac{3}{k^2r_{ij}^2} + \frac{3i}{kr_{ij}} \right]
$$ --> 
<div align="center"><img src="..\003_media\jqCmCliUGz.svg"></div>

with <!-- $k$ --> <img style="transform: translateY(0.0em);" src="..\003_media\zyAiNITSFv.svg"> being the wavevector as well as <!-- $r_{ij}$ --> <img style="transform: translateY(0.3em);" src="..\003_media\szCX86XvnD.svg"> the distance between the <!-- $i^{th}$ --> <img style="transform: translateY(0.0em);" src="..\003_media\qRHSMhajjc.svg"> and <!-- $j^{th}$ --> <img style="transform: translateY(0.3em);" src="..\003_media\yxl9pCar6O.svg"> dipole. At this point it is also worth to mention that in the code all distances are divided by the wavelength of the excitation light to obtain numerical more favourable dimensionless units.


## Typical Results

When using Gold as a material for the above introduced 50nm x 40nm x 30nm rectangular cuboid we can quickly solve the problem. In order to proof a successful implementation we calculate the aborption and extinction cross sections of the cuboid:

<div align="center"><img src="/003_media/rectangular-cuboid_results.jpg" alt="Results for the 50x40x30 rectangular"></div>

They look reasonable and for further shapes and dielectric surroundings they were also calculated and compared to results of full Mie and MMP calculations. 

Finally, it is worth looking at the console output of the calculations:

<div align="center"><img src="/003_media/rectangular-cuboid_timing.jpg" alt="Results for the 50x40x30 rectangular"></div>

It seems that setting up the matrix takes much longer than acually solving it...