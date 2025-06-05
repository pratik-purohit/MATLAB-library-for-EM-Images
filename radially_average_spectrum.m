function [rad_avg,radial_frequency_range]=radially_average_spectrum(img,n,p,k,pad,x_pixel_size,y_pixel_size)
% This function calculates the radially average spectrum of an image.
% 
% Usage:
%       rad_avg=radially_average_spectrum(img,x_pixel_size,y_pixel_size)
%
% Input:
%       img: Input Image
%       n: Size of the moving window
%       p: space - half bandwidth produce
%       k: number of tapers to be used
%       pad: padding of zeros (power of 2 for efficiency)
%       x_pixel_size: Physical Size of the pixel in x-dimension (in meters)
%       y_pixel_size: Physical Size of the pixel in y-dimension (in meters)
%
% Output:
%       rad_avg: Radially average spectrum of the input image
%       radial_frequency_range: 1D array which consist of the
%       radial frequencies

% Obtaining the spectrum of the input image
s = mtspec2d_tiled(img,n,p,k,pad);

% Getting the spatial frequency scale
[dim_y,dim_x]=size(s);
kx = (-dim_x/2 : (dim_x/2)-1) / (dim_x * x_pixel_size);
ky = (-dim_y/2 : (dim_y/2)-1) / (dim_y * y_pixel_size);
[KX,KY]=meshgrid(kx,ky);

% Getting the radial frequencies
radial_frequency=sqrt(KX.^2 + KY.^2);
radial_frequency_range=unique(sort(radial_frequency(:)));
elements=size(radial_frequency_range);

rad_avg=zeros(1,elements(1));

for i=1:elements(1)
    disp(i)
    temp=radial_frequency==radial_frequency_range(i);
    temp1=temp.*s;
    temp2=temp1(temp1~=0);
    rad_avg(i)=mean(temp2);
end



