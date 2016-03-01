# Non-blind image deconvolution in FT domain
 This is a demo script for simple non-blind image deconvolution using Fourier transform (FT). Matrix-vector operation based on lexicographic notation is too slow to handle 2D images. Convolution operation in spatial domain is fast enough, but there is a faster way based on convolution theorem. Convolution operations can be achieved much faster in FT domain. So here, simple image deconvolutions are implemented in FT domain. Note that it is assumed that there is no noise.

# Description of files
- demo_deconv_ft.m: test script for nonblind image deconvolution in FT domain

# Image degradation and deconvolution
- Degradation model: <\br>
   y = h*x (spatial domain)  <=>  Y = HX (FT domain) 
- Deconvolution: <\br>
  (1) LS:  min_x 0.5||y-Hx||2 <\br>
      =>  X = Y ./ H <\br>
  (2) CLS: min_x 0.5||y-Hx||2 + 0.5*lambda*||Cx||2 <\br>
     =>  X = H'Y ./ (H'H + lambda*C'C) <\br>

# Contact
Seunghwan Yoo (seunghwanyoo2013@u.northwestern.edu)
