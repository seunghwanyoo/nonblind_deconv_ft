% This is a demo script for simple non-blind image deconvolution using 
% Fourier transform (FT). Matrix-vector operation based on lexicographic 
% notation is too slow to handle 2D images. We can still use 2D convolution
% in spatial domain, but there is faster way based on convolution theorem.
% Convolution operations can be achieved much faster in FT domain. So here, 
% simple image deconvolutions are implemented in FT domain. Note that it is
% assumed that there is no noise.
%
% Degradation model: 
%   y = h*x (spatial domain)  <=>  Y = HX (FT domain)
% Deconvolution:
%   (1) LS:  min_x 0.5||y-Hx||2
%       =>  X = Y ./ H
%   (2) CLS: min_x 0.5||y-Hx||2 + 0.5*lambda*||Cx||2
%       =>  X = H'Y ./ (H'H + lambda*C'C)
%
% Author: Seunghwan Yoo (seunghwanyoo2013@u.northwestern.edu)

clear; close all;
addpath(genpath('.'));

param.blur = 1; % 1:Gaussian kernel, 2:User defined

%% original image
x0_whole = im2double(imread('peppers.png'));%'greens.jpg';
if ndims(x0_whole) > 1
    x0_whole = rgb2gray(x0_whole);
end
x_2d = x0_whole; % original image
x = x_2d(:); % vectorized

%% blur kernel & laplacian kernel
switch (param.blur)
    case 1
        h0_2d = fspecial('gaussian',[11,11],2);
    case 2
        h0_2d = [1 1 1; 1 1 1; 1 0 0];%h0 = ones(5,5);
        h0_2d = h0_2d/sum(sum(h0_2d)); % blur kernel
end
c0_2d = [0 0.25 0; 0.25 -1 0.25; 0 0.25 0]; % 2D Laplacian for CLS
h_2d = create_h2d(x_2d,h0_2d);
c_2d = create_h2d(x_2d,c0_2d);

%% degradation
fprintf('\n== Degradation\n');
y_2d = ifft2(fft2(x_2d).*fft2(h_2d)); % blurred image - circular conv
figure, imshow(x_2d); title('original');
figure, imshow(y_2d); title('degraded');


%% non-blind deconv without noise (known y,h, get x)
%%% 1. least squares (LS) method
fprintf('== LS in FT domain\n');
H = fft2(h_2d); 
Y = fft2(y_2d); 
tic; x_ls_ft = ifft2(Y./H); toc;
psnr_ls_ft = psnr(x_2d,x_ls_ft,1);
figure, imshow(x_ls_ft); title(sprintf('restored w/ LS in FT, psnr:%.2f',psnr_ls_ft));

%%% 2. constrained least squares (CLS) method
fprintf('== CLS in FT domain\n');
lambda = 0.01; %save('lambda.mat','lambda');
C = fft2(c_2d);
tic; x_cls_ft = ifft2(conj(H).*Y./(conj(H).*H+lambda*conj(C).*C)); toc;
psnr_cls_ft = psnr(x_2d,x_cls_ft,1);
figure, imshow(x_cls_ft); title(sprintf('restored w/ CLS in FT, psnr:%.2f',psnr_cls_ft));

%%% 3. Wiener filter (built-in func)
fprintf('== Wiener filter (deconvwnr)\n');
tic; x_wn = deconvwnr(y_2d,h0_2d,0); toc; % restored with wiener filter
psnr_wn = psnr(x_2d,x_wn,1);
figure, imshow(x_wn); title(sprintf('restored w/ wiener filter, psnr:%.2f',psnr_wn));

