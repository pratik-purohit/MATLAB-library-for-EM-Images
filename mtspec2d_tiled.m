function s = mtspec2d_tiled(im,n,p,k,pad)
% This function obtains the estimated spectral information of an image by
% dividing the image into the tiles using a moving window and averaging the spectral
% information of the tiles using the Multitaper Spectral Analysis.
%   
% Usage:
%   s = mtspec2d_tiled(im,n,p,k,pad)
% 
% Input:
%       im: 2D array, which contains the pixels that belong to an image whose spectral analysis is desired.
%       n: Size of the moving window
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
%  - Modified the code to remove the bug related to covering the whole image. 
%  - Updated the description of the function and comments for clarity.
% --------------------------------------------------------------------------
% Version 1.0
%   mtspec2d_tiled Computed 2d multitaper spectral estimate of spectrum
%   with a moving nxn tile. p,k: space-bandwidth product, and number of
%   tapers kept; pad: padded length (use power of 2 for speed)

% Obtaining the dimension of the image
sz=size(im); 
if length(sz)~=2 
    error('Need 2D array'); % Throwing error message if input image is not 2D.
end

if (sz(1)<=n)||(sz(2)<=n) 
    error('Moving window is larger than image'); % Throwing error message if moving window (n) is larger than image (Error Message modified in Version 2.0)
end 

% Obtainign the number of tiles
nx=floor(sz(1)/n); 
ny=floor(sz(2)/n); 

% Initializing the empty array to store the result
s=zeros(pad,pad);

for i=1:nx
    for j=1:ny
        ix=(i-1)*n; % Removed the "+ 1" in version 2.0
        jy=(j-1)*n; % Removed the "+ 1" in version 2.0
        s = s + mtspec2d_sq(im(ix+1:ix+n,jy+1:jy+n),p,k,pad); % Added the "+ 1" with ix and iy in version 2.0
    end
end

% Average spectral information across the tiles
s=s/(nx*ny);

end

