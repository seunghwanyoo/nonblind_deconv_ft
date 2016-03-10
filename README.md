# Non-blind image deconvolution in FT domain
 This is a demo script for simple non-blind image deconvolution using Fourier transform (FT). Matrix-vector operation based on lexicographic notation is inefficient in terms of memory usage and speed. If the size of 2D image is NxN, and that of blur kernel is MxM, then the vectorized image will be of N^2x1, and the matrix H of N^2xN^2. Inverse of the matrix will take forever for any normal size images. Fortunately, convolution operation of image data and blur kernel is equivalent to the multiplication of the matrix and the vector in lexicographic manner. The convolution operation doesn't require large memory space (only N^2, much less than N^4) and faster (since M<<N). However, convolution operation in spatial domain is still slow since it requires O(N^2xM^2) operations. However, there is a faster way based on convolution theorem. Convolution operations can be achieved in Fourier transform domain, and it's much faster (O(N^2)). So here, simple image deconvolutions are implemented in FT domain. Note that it is assumed that there is no noise.

# Description of files
- demo_deconv_ft.m: test script for nonblind image deconvolution in FT domain

# Image degradation and deconvolution
- Degradation model: </br>
   y = h*x (spatial domain)  <=>  Y = HX (FT domain) 
- Deconvolution: </br>
  (1) LS:  min_x 0.5||y-Hx||2 </br>
      =>  X = Y ./ H </br>
  (2) CLS: min_x 0.5||y-Hx||2 + 0.5*lambda*||Cx||2 </br>
     =>  X = H'Y ./ (H'H + lambda*C'C) </br>

# Contact
Seunghwan Yoo (seunghwanyoo2013@u.northwestern.edu)
