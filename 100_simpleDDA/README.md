# 100 simple DDA

## An Introduction to the Discrete Dipole Approximation (DDA)

The idea behind the the discrete dipole method is in order to calculate the optical response of an object, e.g. a 50x40x30 rectangular cuboid as depicted below, its volume is divided into equally-sized cells and a dipole is put in the center of each cell.

<img src="/003_media/rectangular-cuboid.jpg" alt="A 50x40x30 rectangular cuboid divided into dipoles">
  
The charges of each cell $i$ will move around slightly when an outer electric field $\mathbf{{E}}_{\textrm{app},i}$ is applied, i.e. a polarization is created. The easiest way to model this is via the polarization of the dipole:

$$
\mathbf{P}_{i}={\alpha}\mathbf{{E}}_{\textrm{app},i} 
$$

where $\mathbf{\alpha}$ being the polarizability of the dipole which is a material constant. (More general for anisotropic inhomogeneous materials the scaler qunatity $\mathbf{\alpha}$ becomes a tensor and location dependent, i.e. $\hat{\alpha}_i$.) 

Now, when the applied field is not static but alternating with a frequency $\omega$, each dipole also generates a radiating electric field: [<img src="../003_media/External.svg" height="14">](https://en.wikipedia.org/wiki/Dipole#Dipole_radiation)

$$
\mathbf{E}_{\textrm{gen},i}(\mathbf{r}) = \frac{1}{4\pi\varepsilon_0} \left\{
    \frac{\omega^2}{c^2 r} \left( \mathbf{r} \times \mathbf{P}_{i} \right) \times \mathbf{r} +
    \left( \frac{1}{r^3} - \frac{i\omega}{cr^2} \right)
    \left( 3\mathbf{r} \left[\mathbf{r} \cdot \mathbf{P}_{i}\right] - \mathbf{P}_{i} \right)
\right\} e^\frac{i\omega r}{c} e^{-i\omega t} 
$$ 

with $\mathbf{r}$ being the distance vector, $c$ the velocity of light and $t$ a point in time.


This means, the applied outer electric field for each dipole does not only consist of the excitation field $\mathbf{{E}}_{\textrm{exci}}$, e.g. a plane wave, but also the generated fields of all other dipoles:

$$
\mathbf{{E}}_{\textrm{app},i} = \mathbf{{E}}_{\textrm{exci}} + \sum _{i\neq j} \mathbf{{E}}_{\textrm{gen},j}
$$ 

which results in a coupled system.

* General picture
    * Graphics: Cube -> divided into dipoles
    * each dipole has a polarization and, hence, generates an electric field  (P<sub>i</sub> = &alpha;<sub>i</sub> E(r<sub>i</sub>))
    * which acts on all the other dipoles
    * (trivial solution: all dipoles are zero)
    * but not possible with excitation, e.g. plane wave
    * goal: find the amplitude and orientation of all dipoles

* More formal
    * matrix fields and so on



