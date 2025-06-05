function [ s ] = mtspec3D_sq(vol,p,k,pad)
% This function calculates the spectral information of cube shaped
% volumetric image using the multitaper spectral analysis
% 
% Usage:
%       s = mtspec3D_sq(vol,p,k,pad)
% 
% Input:
%       vol = 3D Volume (assumed cube)
%       p = time - half bandwidth product
%       k = number of tapers used for estimation of the spectral
%       information
%       pad = padding of zeros
% 
% Output:
%       s = estimated spectral information

% Getting the dimension of the 3D image
sz=size(vol); 

if length(sz)~=3 
    error('Require 3D array'); 
end

if sz(1)~=sz(2)||sz(2)~=sz(3)||sz(1)~=sz(3)
    error('Require cube Shaped volume'); 
end

% compute linear dimension
n=sz(1);    

% remove DC
vol=vol-mean(mean(mean(vol)));

% compute tapers
tap=squaredpss_3D(n,p,k); 
tap=reshape(tap,n,n,n,k*k*k);

% compute taperd FTs and spectra
vol1=repmat(vol,[1,1,k*k*k]);
vol1=vol1.*tap;
vol2=zeros(pad,pad,pad,k*k*k);
vol2(1:n,1:n,1:n)=vol1;
imft=fftshift(fftn(vol2)); 

% Average to obtain spectral estimate
s=mean(abs(imft).^2,4); 

end

