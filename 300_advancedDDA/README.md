# 200_advancedDDA

*In the last section we implemented the standard DDA and optimizing the solver to improve the performance by a __factor of two__. In this chapter we utilize the symmetry of the system and hardware acceleration to improve the performance by more than __two orders of magnitude__. In this subchapter we lay the groundwork for that*


## A Simplified System

In order to better visualize symmetries and enhancements, we reduce our Gold-sphere example to 81 dipoles by increasing the spacing to 10&thinsp;nm while leaving the 50-nm diameter untouched. Furthermore, we are just considering the central plane which consist of 21 numbered dipoles as depicted below.

<div align="center"><img src="/003_media/sphere-50nm-10nm_geometry-2D_dipoles-and-numbers.jpg" alt="2D arrangement of 21 dipoles"></div>

The next simplification is to restrict ourselves to fields only in *x* direction as this reduces the matrix elements from *3x3* tensors to scalars. Hence, the matrix for our equation looks like that:

<!-- $$
\begin{bmatrix}
E_{x,1} \\ E_{x,2} \\ E_{x,3} \\ \vdots \\ E_{x,21} \\
\end{bmatrix} =
\begin{bmatrix}
0          & A_{x,1,2}  & A_{x,1,3}  & \cdots & A_{x,1,21} \\ 
A_{x,2,1}  & 0          & A_{x,2,3}  & \cdots & A_{x,2,21} \\ 
A_{x,3,1}  & A_{x,3,2}  & 0          & \cdots & A_{x,3,21} \\ 
\vdots     & \vdots     & \vdots     & \ddots & \vdots \\ 
A_{x,21,1} & A_{x,21,2} & A_{x,21,3} & \cdots & 0 \\ 
\end{bmatrix} =
\times
\begin{bmatrix}
P_{x,1} \\ P_{x,2} \\ P_{x,3} \\ \vdots \\ P_{x,21} \\
\end{bmatrix}
$$ --> 

<div align="center"><img style="background: white;" src="..\003_media\QWIBl0NCpP.svg"></div>

Note, as the distance is the same, the action of dipole <!-- $i$ --> <img style="transform: translateY(0.0em)" src="..\003_media\MD4PQk8NSb.svg"> on <!-- $j$ --> <img style="transform: translateY(0.2em)" src="..\003_media\gLutEbSC0j.svg"> is the same as <img style="transform: translateY(0.2em)" src="..\003_media\gLutEbSC0j.svg"> on <img style="transform: translateY(0.0em)" src="..\003_media\MD4PQk8NSb.svg"> and the matrix is symmetric (<!-- $\mathbf{A}_{x,i,j} = \mathbf{A}_{x,j,i}$ --> <img style="transform: translateY(0.35em)" src="..\003_media\AEvAAQA30f.svg">). This property is actually used by the BCG algorithm to reduce the number of performance-critical matrix-vector operation from two to one per iteration. 

When looking at our example again, we see that due to the constant grid there are actually many dipol pairs with the same distance. For example:

<div align="center"><img src="/003_media/sphere-50nm-10nm_geometry-2D_same-distance.jpg" alt="Some dipole pairs with the same distance"></div>

Let's try to use this property.

## Creating a Circulant Matrix


<!-- <div align="center"><img src="/003_media/conv_animation.gif" alt="Animation of the convolution."></div> -->


<!-- $$
\begin{bmatrix}
\color{gray}{e_{-40}} \\ \color{gray}{e_{-39}} \\ \color{gray}{e_{-38}} \\  \vdots \\ \color{teal}{e_{-2}} \\ \color{teal}{e_{-1}} \\ \color{teal}{e_{0}} \\ \color{teal}{e_{1}} \\ \color{teal}{e_{2}} \\ \vdots \\ \color{gray}{e_{39}} \\ \color{gray}{e_{40}} \\ 0 \\
\end{bmatrix} = 
\begin{bmatrix}
\color{gray}{a_{-40}} & \color{gray}{a_{-39}} & \color{blue}{a_{-38}} & \color{orange}{a_{-37}} &  \cdots & \color{red}{a_{-2}} & \color{purple}{a_{-1}} & a_{0} & \color{purple}{a_{1}} & \color{red}{a_{2}} & \cdots & \color{orange}{a_{37}} & \color{blue}{a_{38}} & \color{gray}{a_{39}} & \color{gray}{a_{40}} & 0 \\
0 & \color{gray}{a_{-40}} & \color{gray}{a_{-39}} & \color{blue}{a_{-38}} & \color{orange}{a_{-37}} & \cdots & \color{red}{a_{-2}} & \color{purple}{a_{-1}} & a_{0} & \color{purple}{a_{1}} & \color{red}{a_{2}}&  \cdots & \color{orange}{a_{37}} & \color{blue}{a_{38}} & \color{gray}{a_{39}} & \color{gray}{a_{40}} \\
\color{gray}{a_{40}} & 0 & \color{gray}{a_{-40}} & \color{gray}{a_{-39}} & \color{blue}{a_{-38}} & \color{orange}{a_{-37}} & \cdots & \color{red}{a_{-2}} & \color{purple}{a_{-1}} & a_{0} & \color{purple}{a_{1}} & \color{red}{a_{2}} & \cdots & \color{orange}{a_{37}} & \color{blue}{a_{38}} & \color{gray}{a_{39}} \\
\vdots & & & & \ddots & & & & & \ddots & & & & & & \vdots \\
\color{red}{a_{2}} & \cdots & \color{orange}{a_{37}} & \color{blue}{a_{38}} & \color{gray}{a_{39}} & \color{gray}{a_{40}} & 0 & \color{gray}{a_{-40}} & \color{gray}{a_{-39}} & \color{blue}{a_{-38}} & \color{orange}{a_{-37}} & \cdots & \color{red}{a_{-2}} & \color{purple}{a_{-1}} & a_{0} & \color{purple}{a_{1}} \\
\color{purple}{a_{1}} & \color{red}{a_{2}} & \cdots & \color{orange}{a_{37}} & \color{blue}{a_{38}} & \color{gray}{a_{39}} & \color{gray}{a_{40}} & 0 & \color{gray}{a_{-40}} & \color{gray}{a_{-39}} & \color{blue}{a_{-38}} & \color{orange}{a_{-37}} & \cdots & \color{red}{a_{-2}} & \color{purple}{a_{-1}} & a_{0} \\
a_{0} & \color{purple}{a_{1}} & \color{red}{a_{2}} & \cdots & \color{orange}{a_{37}} & \color{blue}{a_{38}} & \color{gray}{a_{39}} & \color{gray}{a_{40}} & 0 & \color{gray}{a_{-40}} & \color{gray}{a_{-39}} & \color{blue}{a_{-38}} & \color{orange}{a_{-37}} & \cdots & \color{red}{a_{-2}} & \color{purple}{a_{-1}} \\
\color{purple}{a_{-1}} & a_{0} & \color{purple}{a_{1}} & \color{red}{a_{2}} & \cdots & \color{orange}{a_{37}} & \color{blue}{a_{38}} & \color{gray}{a_{39}} & \color{gray}{a_{40}} & 0 & \color{gray}{a_{-40}} & \color{gray}{a_{-39}} & \color{blue}{a_{-38}} & \color{orange}{a_{-37}} & \cdots & \color{red}{a_{-2}} \\
\color{red}{a_{-2}} & \color{purple}{a_{-1}} & a_{0} & \color{purple}{a_{1}} & \color{red}{a_{2}} & \cdots & \color{orange}{a_{37}} & \color{blue}{a_{38}} & \color{gray}{a_{39}} & \color{gray}{a_{40}} & 0 & \color{gray}{a_{-40}} & \color{gray}{a_{-39}} & \color{blue}{a_{-38}} & \color{orange}{a_{-37}} & \cdots   \\
\vdots & & & & \ddots & & & & & \ddots & & & & & & \vdots \\
\color{orange}{a_{-37}} &  \cdots & \color{red}{a_{-2}} & \color{purple}{a_{-1}} & a_{0} & \color{purple}{a_{1}} & \color{red}{a_{2}} & \cdots & \color{orange}{a_{37}} & \color{blue}{a_{38}} & \color{gray}{a_{39}} & \color{gray}{a_{40}} & 0 & \color{gray}{a_{-40}} & \color{gray}{a_{-39}} & \color{blue}{a_{-38}} \\
\color{blue}{a_{-38}} & \color{orange}{a_{-37}} &  \cdots & \color{red}{a_{-2}} & \color{purple}{a_{-1}} & a_{0} & \color{purple}{a_{1}} & \color{red}{a_{2}} & \cdots & \color{orange}{a_{37}} & \color{blue}{a_{38}} & \color{gray}{a_{39}} & \color{gray}{a_{40}} & 0 & \color{gray}{a_{-40}} & \color{gray}{a_{-39}}\\
\color{gray}{a_{-39}} & \color{blue}{a_{-38}} & \color{orange}{a_{-37}} &  \cdots & \color{red}{a_{-2}} & \color{purple}{a_{-1}} & a_{0} & \color{purple}{a_{1}} & \color{red}{a_{2}} & \cdots & \color{orange}{a_{37}} & \color{blue}{a_{38}} & \color{gray}{a_{39}} & \color{gray}{a_{40}} & 0 & \color{gray}{a_{-40}}  \\
\end{bmatrix}
\times
\begin{bmatrix}
\color{gray}{p_{-40}} \\ \color{gray}{p_{-39}} \\ \color{gray}{p_{-38}} \\  \vdots \\ \color{teal}{p_{-2}} \\ \color{teal}{p_{-1}} \\ \color{teal}{p_{0}} \\ \color{teal}{p_{1}} \\ \color{teal}{p_{2}} \\ \vdots \\ \color{gray}{p_{39}} \\ \color{gray}{p_{40}} \\ 0 \\
\end{bmatrix}
$$ --> 

circulant matrix

<div align="center"><img style="background: white;" src="..\003_media\cvfTTvXUnR.svg"></div>