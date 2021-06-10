# 200_advancedDDA

*In the last section we implemented the standard DDA and optimizing the solver to improve the performance by a __factor of two__. In this chapter we utilize the symmetry of the system and hardware acceleration to improve the performance by more than __two orders of magnitude__. In this subchapter we lay the groundwork for that*


## A Simplified System

In order to better visualize symmetries and enhancements, we reduce our Gold-sphere example to 81 dipoles by increasing the spacing to 10&thinsp;nm while leaving the 50-nm diameter untouched. Furthermore, we are just considering the central plane which consist of 21 numbered dipoles as depicted below.

<div align="center"><img src="/003_media/sphere-50nm-10nm_geometry-2D_dipoles-and-numbers.jpg" alt="2D arrangement of 21 dipoles"></div>

The next simplification is to restrict ourselves to fields only in *x* direction as this reduces the matrix elements from *3x3* tensors to scalars. Hence, the matrix for our equation looks like that:

<div align="center"><img style="background: white;" src="..\003_media\QWIBl0NCpP.svg"></div>

Note, as the distance is the same, the action of dipole <!-- $i$ --> <img style="transform: translateY(0.0em)" src="..\003_media\MD4PQk8NSb.svg"> on <!-- $j$ --> <img style="transform: translateY(0.2em)" src="..\003_media\gLutEbSC0j.svg"> is the same as <img style="transform: translateY(0.2em)" src="..\003_media\gLutEbSC0j.svg"> on <img style="transform: translateY(0.0em)" src="..\003_media\MD4PQk8NSb.svg"> and the matrix is symmetric (<!-- $\mathbf{A}_{x,i,j} = \mathbf{A}_{x,j,i}$ --> <img style="transform: translateY(0.35em)" src="..\003_media\AEvAAQA30f.svg">). This property is actually used by the BCG algorithm to reduce the number of performance-critical matrix-vector operation from two to one per iteration. 

When looking at our example again, we see that due to the constant grid there are actually many dipole pairs with the same distance. For example:

<div align="center"><img src="/003_media/sphere-50nm-10nm_geometry-2D_same-distance.jpg" alt="Some dipole pairs with the same distance"></div>

Let's try to use this property.

## Creating a Circulant Matrix

We start at the center dipole and mark the interactions with all the other dipoles (purple and red arrows). Then we move one dipole to the right and add the so far unmarked five new interaction with green arrows.

<div align="center"><img src="/003_media/conv01-03.jpg" alt="Sketch of dipole interactions."></div>

Something to highlight is, that the five red arrows to the right are now not pointing onto dipoles anymore. But instead of removing them, let us create dipoles with zero polarizability instead, i.e. we still consider the interaction mathematically but physically switch it off.

But let us not stop at this point but add further green arrows to the top, right as well as bottom to make the pattern symmetric and then move around to gather all possible interactions as animated below.

<div align="center"><img src="/003_media/conv_animation.gif" width="58%" alt="Animation of the convolution."></div>

This means, when we expand the original grid slightly, we can represent all interactions in one go. This expanded rectangular grid has to be at least *2x* maximum width times *2x* maximum heigh of the structure as well as periodically repeated, i.e. arrows which exceed the boundary of the rectangular grid to the right are simply wrapped around and re-enter from the left.

We can now count all grid points starting with *-40* at the bottom left, *0* in the center and finishing with *40* at the top right. With this, we can now build a vector containing all positions, e.g. <!-- $\color{teal}{p_{0}}$ --> <img style="transform: translateY(0.1em); background: white;" src="..\003_media\hQhUfEroSG.svg"> is the polarization of the dipole in the center, and a vector containing all interactions, e.g. <!-- $\color{purple}{a_{10}}$ --> <img style="transform: translateY(0.1em); background: white;" src="..\003_media\6Kxxy3IMUC.svg"> is the interaction with the dipole placed on to the top-right. Here is spatial representation of the vectors:

<div align="center"><img src="/003_media/conv_numbering.jpg" alt="New numbering of the vector and interactions."></div>

Hence, we can write the original matrix equation down again but in this new notation. Note, to avoid confusions with the original notation, lower-case letters have been used intentionally:

<div align="center"><img style="background: white;" src="..\003_media\cvfTTvXUnR.svg"></div>

Now, one can see that this matrix has a very specific symmetry: all rows have the same elements which are just circled around. Hence, it is called *circulant matrix* and one only needs to know the first row to reconstruct the whole matrix. This means, instead of *21 x 21 = 441* elements, just *40 - (-40) + 1 = 81* have to be stored for our example.

*Circulant* matrices have another very nice property. But in order to stay sane we won't discuss it now and also won't implement the just mentioned matrix "compression" in this subchapter.


## Implementation
