function img_pca=pca_image(img,k)
% This function calculates the PCA of the given image and reconstructs the image using the first k principal components.
%
% Usage:
%       img_pca=pca_image(img,k)
% 
% Input:
%       img: Input Image
%       k: Number of the principle components used for reconstructing
%       image
% 
% Output:
%       img_pca: Reconstructed Image


img=double(img);
img_scaled=zeros(size(img,1),size(img,2));

% Column wise normalization
for i=1:size(img,2)
    img_scaled(:,i)=img(:,i)/mean(img(:,i));
end

% convariance between the coloumns
cov_mat=cov(img_scaled);

% Calculating the eigen vector and eigen values of the covariance matrix
[evec,eval]=eig(cov_mat);
evec_sorted=fliplr(evec);
evec_sorted_selected=evec_sorted(:,1:k); % Selecting the first k components

r=evec_sorted_selected'*img_scaled';  
img_pca=(evec_sorted_selected*r)';  % Reconstructing the image