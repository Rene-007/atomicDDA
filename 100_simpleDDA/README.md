# 100 simple DDA

## An Introduction to the Discrete Dipole Approximation (DDA)

The idea behind the the discrete dipole method is to take a volume, e.g. a 50x40x30 rectangular cuboid, divide it into equally-sized cells and put a dipole in the center of each cell.

![A 50x40x30 rectangular cuboid divided into dipoles](/003_media/rectangular-cuboid.jpg "A 50x40x30 rectangular cuboid divided into dipoles")

Each dipole __i__ has a polarization __P<sub>i</sub>__ which is determined by the local electric field __E<sub>loc,i</sub>__ via:

>__P<sub>i</sub>__ = __&alpha;<sub>i</sub> E<sub>loc,i</sub>__

with __&alpha;<sub>i</sub>__ being the polarizability of the dipole.

* General picture
    * Graphics: Cube -> divided into dipoles
    * each dipole has a polarization and, hence, generates an electric field  (P<sub>i</sub> = &alpha;<sub>i</sub> E(r<sub>i</sub>))
    * which acts on all the other dipoles
    * (trivial solution: all dipoles are zero)
    * but not possible with excitation, e.g. plane wave
    * goal: find the amplitude and orientation of all dipoles

* More formal
    * matrix fields and so on

