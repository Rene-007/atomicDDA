# 200_advancedDDA

*In the last section we bla bla bla*

<img src="/003_media/conv_animation.gif" alt="Animation of the convolution.">

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