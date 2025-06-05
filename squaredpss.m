function [ tapers ] = squaredpss(n,p,k)
%   Outer products of Slepians for 2D spectral analysis
%   n = linear dimension of square
%   p = space-bandwidth product
%   k = number of tapers kept (~ 2*p-1)

[v e]=dpss(n,p); 

v=v(:,1:k); 
tapers = zeros(n,n,k,k); 
for i=1:k
    for j=1:k
        tapers(:,:,i,j)=v(:,i)*v(:,j)';
    end
end