function [ tapers ] = squaredpss_3D(n,p,k)
% This function calcultes the 3D tapers by outer product of the Slepians.
% 
% Usage
%       tapers = squaredpss_3d(n,p,k)
%
% Input
%      n = linear dimension of 3D image
%      p = space-bandwidth product
%      k = number of tapers kept (~ 2*p-1)
% Output
%      tapers = 3D Tapers

[v e]=dpss(n,p); 
v=v(:,1:k); 
tapers = zeros(n,n,n,k,k,k); 

for i=1:k
    for j=1:k
        for m=1:k
            taper_2D=v(:,i)*v(:,j)';
            taper_3D=zeros(n,n,n);
            taper_1D=v(:,m);
            for q=1:n
                taper_3D(:,:,q)=taper_2D*taper_1D(q);
            end
            tapers(:,:,:,i,j,m)=taper_3D;
        end
    end
end

