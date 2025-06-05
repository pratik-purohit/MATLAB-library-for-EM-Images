function [ s ] = mtspec3D_tiled(vol,n,p,k,pad)
% This function obtains the estimated spectral information of a 3D image by
% dividing the image into the sub-volumes using a moving 3D window and averaging the spectral
% information across the sub-volumes using the Multitaper Spectral Analysis.
%
% Usage:
%       s = mtspec3D_tiled(vol,n,p,k,pad)
%
% Input:
%       vol = 3D array containing the pixels of the 3D image
%         n = Size of the moving 3D window
%         p = time - halfbandwidth produce
%         k = number of tapers kept 
%       pad = padding of the zeros
%
% Output:
%       s = 3D array which contains the magnitude of the multitaper spectral estimate.

% Obtaining the dimension of the image
sz=size(vol); 
if length(sz)~=3 
    error('Need 3D array'); % Throwing error message if input image is not 3D.
end

if (sz(1)<=n)|(sz(2)<=n)|sz(3)<=n 
    error('Moving window larger than the given volume'); % Throwing error message if moving window (n) is larger than image
end

% Obtaining the number of sub-volumes
nx=floor(sz(1)/n); 
ny=floor(sz(2)/n); 
nz=floor(sz(3)/n);
% Initializing the empty array to store the result
s=zeros(pad,pad,pad);

for i=1:nx
    for j=1:ny
        for k=1:nz
            ix=(i-1)*n; 
            jy=(j-1)*n;
            kz=(k-1)*n;
            s = s + mtspec3D_sq(vol(ix+1:ix+n,jy+1:jy+n,kz+1:kz+n),p,k,pad);
        end
    end
end

% Average spectral information across the sub-volumes
s=s/(nx*ny*nz);

end

