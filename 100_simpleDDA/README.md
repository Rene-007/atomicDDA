# 100 simple DDA

## An Introduction to the Discrete Dipole Approximation (DDA)

The idea behind the the discrete dipole method is to calculate the optical response of an object, e.g. a 50x40x30 rectangular cuboid as depicted below, by dividing its volume into equally-sized cells and placing a dipole in the center of each cell.

<img src="/003_media/rectangular-cuboid.jpg" alt="A 50x40x30 rectangular cuboid divided into dipoles">

Each cell $i$ contains charges (e.g. free electrons in metals or valence electrons in dielectrics) that will move around slightly when an outer electric field $\mathbf{{E}}_{\textrm{app},i}$ is applied. This leads to a polarization which can be expressed in our dipole model by

$$
\mathbf{P}_{i}={\alpha}\mathbf{{E}}_{\textrm{app},i} 
$$

where $\mathbf{\alpha}$ being the polarizability of the dipole -- a material constant. (More generally the scaler $\mathbf{\alpha}$ becomes a tensor and location dependent quantity $\bar{\alpha}_i$ for anisotropic inhomogeneous materials.) 

Now, when the applied field is not static but alternating with a frequency $\omega$, such as for the case of light, each dipole also generates an electric field [<img src="../003_media/External.svg" height="14">](https://en.wikipedia.org/wiki/Dipole#Dipole_radiation)

$$
\mathbf{E}_{\textrm{gen},i}(\mathbf{r}) = \frac{1}{4\pi\varepsilon_0} \left\{
    \frac{\omega^2}{c^2 r} \left( \mathbf{\hat{r}} \times \mathbf{P}_{i} \right) \times \mathbf{\hat{r}} +
    \left( \frac{1}{r^3} - \frac{i\omega}{cr^2} \right)
    \left( 3\mathbf{\hat{r}} \left[\mathbf{\hat{r}} \cdot \mathbf{P}_{i}\right] - \mathbf{P}_{i} \right)
\right\} e^\frac{i\omega r}{c} e^{-i\omega t} 
$$ 

with $\mathbf{\hat{r}}$ being the unit distance vector from the dipole's origin, $r$ the distance, $c$ the velocity of light and $t$ a point in time.

This means, the applied outer electric field for each dipole does not only consist of the excitation field $\mathbf{{E}}_{\textrm{exci},i}$, e.g. for plane wave  $\mathbf{E}_{0} \cdot e^{-i\omega t} $, but also the generated fields of all other dipoles:

$$
\mathbf{{E}}_{\textrm{app},i} = \mathbf{{E}}_{\textrm{exci},i} + \sum _{i\neq j} \mathbf{{E}}_{\textrm{gen},j}(\mathbf{r}_j) \,.
$$ 

Considering that each dipole talks to all other dipoles and the other way around this gives us a coupled system.

## Solving the Problem

To solve the problem we reformulate it in the frequency domain, i.e. leave out the $e^{-i\omega t} $ terms and replace $\omega/c$ by the free-space wavevector $k$, as well as define $\mathbf{r}_{ij}$ as being the distance vector between the $i^{th}$ and $j^{th}$ cell. This results in a generated field of the $i^{th}$ dipole at the position of the $j^{th}$ dipole of: 

$$
\mathbf{E}_{\textrm{gen},ij} = \frac{1}{4\pi\varepsilon_0} \frac{e^{i k r_{ij}}}{r_{ij}} \left\{
    k^2 \left( \mathbf{\hat{r}}_{ij} \times \mathbf{P}_{i} \right) \times \mathbf{\hat{r}}_{ij} +
    \left( \frac{1}{r^2_{ij}} - \frac{ik}{r_{ij}} \right)
    \left( 3\mathbf{\hat{r}}_{ij} \left[\mathbf{\hat{r}}_{ij} \cdot \mathbf{P}_{i}\right] - \mathbf{P}_{i} \right)
\right\}  
$$ 

This formlula can be simplified by using the Graßmann identity (bac-cab rule) and additionally we change the sign for convenience further down:
$$ 
\mathbf{{E}}_{\textrm{gen},ij} 
= - \underbrace{
    \frac{k^2}{4\pi\varepsilon_0} \frac{e^{i k r_{ij}}}{r_{ij}} \left[
    \left( \hat{r}_{ij} \hat{r}_{ij} \right) - \mathbf{I}  +
    \left( \frac{1}{k^2r_{ij}^2} - \frac{i}{kr_{ij}} \right)
    \left( 3\hat{r}_{ij} \hat{r}_{ij} - \mathbf{I} \right)
    \right] }_{\normalsize{\mathbf{A}_{ij}}}
\mathbf{P}_{j} \, .
$$ 

As noted with the underbrace, because $\mathbf{P}_{j}$ became linearly independent and could be extrated to the right, we were able to define an interaction matrix $\mathbf{A}$. By defining a second matrix $\mathbf{B}$ with only diagonal values of $\alpha^{-1}$ we can now write down:

$$
\mathbf{{E}}_{\textrm{app},i} -  \sum _{i\neq j} \mathbf{{E}}_{\textrm{gen},j} = \mathbf{B}_{ii} \mathbf{P}_{i} + \sum _{i\neq j} \mathbf{A}_{ij} \mathbf{P}_{j}
= \mathbf{{E}}_{\textrm{exci},i} 
$$

and even further combine $\mathbf{A}$ and $\mathbf{B}$ to an extented interaction matrix $\mathbf{C}$ which results in a simple form:
$$
\sum \mathbf{C}_{ij} \mathbf{P}_{j} = \mathbf{{E}}_{\textrm{exci},i} \, .
$$ 

For the final step it is clearest to write down everything in pure matrix-vector notation:
$$
\mathbf{C} \mathbf{P} = \mathbf{{E}}_{\textrm{exci}}
$$

as the solution is now obvious
$$
\mathbf{P} = \left( \mathbf{C}^{-1} \mathbf{C} \right) \mathbf{P}
= \mathbf{C}^{-1} \left( \mathbf{C} \mathbf{P} \right) 
= \mathbf{C}^{-1} \mathbf{{E}}_{\textrm{exci}} \, .
$$

This means, only the inverse matrix of $\mathbf{C}$ needs to be calculate and multiplied with the excitation field in order to solve the problem.