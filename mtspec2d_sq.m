function s = mtspec2d_sq(im,p,k,pad)
% This function calculates the spectral information of a square size image using the Multitaper
% Spectral analysis.
%  
% Please see following for a review of Multitaper Spectral Analysis: 
% (1) Mitra, P., & Bokil, H. (2007). Observed Brain Dynamics. https://doi.org/10.1093/acprof:oso/9780195178081.001.0001
% (2) B. Babadi and E. N. Brown, "A Review of Multitaper Spectral Analysis," in IEEE Transactions on Biomedical Engineering, 2014,
% doi: 10.1109/TBME.2014.2311996.
%
% Usage:
%   s = mtspec2d_sq(im,p,k,pad)
% 
% Input:
%       im: 2D array (square size) which contain the pixels belong to an image whose spectral analysis is desired.
%       p: Product of Time and Half-bandwidth
%       k: Number of tapers to be used while estimating the spectral information using the multitaper spectrum method.
%       pad: Padding of the Zeros  
%  
% Output:
%       s: 2D array which contains the magnitude of the multitaper spectral estimate.
%
% Change Log:
% ====================================================
% Version: 2.0
%  - Updated the description of the function and comments for clarity.
% ----------------------------------------------------
% Version: 1.0
% multitaper spectral estimate for a square image tile
%   im = 2d image (assumed square)
% p,k: space bandwidth and tapers kept (see squaredpss)
% pad = padding
% check that one has a square image 
%-----------------------------------------------------

sz=size(im); 
if length(sz)~=2 
    error('Require 2D array'); 
end

if sz(1)~=sz(2) 
    error('Require square array'); 
end

% computing the linear dimension
n=sz(1);    

% remove DC component
im=im-mean(mean(im));

% compute tapers
tap=squaredpss(n,p,k); 
tap=reshape(tap,n,n,k*k);

% compute taperd FTs and spectra
im1=repmat(im,[1,1,k*k]);
im1=im1.*tap;
im2=zeros(pad,pad,k*k);
im2(1:n,1:n,:)=im1;
imft=fftshift(fft2(im2)); 

% Average to obtain spectral estimate
s=mean(abs(imft).^2,3); 

end

