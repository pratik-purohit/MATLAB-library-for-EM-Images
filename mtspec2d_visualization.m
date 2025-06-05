function mt_crop = mtspec2d_visualization(img,window_size,x_crop_start,x_crop_end,y_crop_start,y_crop_end)
% This function crops the rectangle from the given 2D slice, apply the
% multitaper spectral analyisis to obtain the estimated spectral information, create a visualization of the result and
% save the visualization as PNG image.
%
% Usage:
%       mt_crop = Multitaper_Crop_2D(filename,section_no,x_crop_start,x_crop_end,y_crop_start,y_crop_end)
% 
% Input:
%       img: 2D array (Input Image)
%       window_size: Size of the moving window to divide the image into
%       tiles.
%       x_crop_start, x_crop_end: Start and end postion of the cropped image on the x-axis.
%       y_crop_start, y_crop_end: Start and end postion of the cropped image on the y-axis.
% 
% Output:
%       mt_crop: The output of the multitaper spectral analysis on the cropped image from the givne section number.
%


sz=size(img); 
if length(sz)~=2 
    error('Require 2D array'); 
end

% Removing the DC bias
img=img-mean(mean(img));
dim_org=size(img);

% Checking the Range of coordinates to crop from the original image
if x_crop_start > dim_org(2) || x_crop_end > dim_org(2) || y_crop_start > dim_org(1) || y_crop_end > dim_org(1)
    error(['Out of bounds -- Range of coordinates to Crop. Valid Range of x: 1 - ',num2str(dim_org(2)),' and y: 1 - ',num2str(dim_org(1))])
end

% Cropping the slice
img_crop=img(y_crop_start:y_crop_end,x_crop_start:x_crop_end);
dim=size(img_crop);

tiledlayout(2,2) % Dividing the figure window in 2 x 2

% Displaying the original Image
nexttile
title('Original Image');
DisplayOneSectionMRC(img,section_no);
hold on
% Drawing the rectangle on the image which will be cropped
rectangle('Position',[x_crop_start,y_crop_start,x_crop_end-x_crop_start,y_crop_end-y_crop_start],'EdgeColor','b'); 
hold off

% Displaying the cropped image
nexttile
DisplayOneSectionMRC(img_crop,section_no);
title('Cropped Image');

% Calculting the spectral information using the Multitaper Spectral
% Estimation
n=int32(max(x_crop_end-x_crop_start+1,y_crop_end-y_crop_start+1));
pad=int32(2^(1+nextpow2(window_size)));
mt_crop=mtspec2d_tiled(img_crop,window_size,2,3,pad);


% Visualizing the result of the multitaper spectral method
f1=nexttile;
    % 2D Visualization
imagesc(log(fftshift(mt_crop))); 
colormap(f1,'hot')
colorbar
title('Multitaper Spectral Analysis - 2D view')
meani=mean(mean(mt_crop));
sdi=std(std(mt_crop));
xlabel(['mean=',num2str(meani),' and SD=',num2str(sdi)]);

f2=nexttile;
    % 3D Visualization
mesh(log(fftshift(mt_crop)),FaceColor='interp',FaceLighting='gouraud'); 
colormap(f2,'hot')
colorbar
title('Multitaper Spectral Analysis - 3D view')
xlabel(['mean=',num2str(meani),' and SD=',num2str(sdi)]);

% Saving the visualizations as PNG image
image_no_1=((y_crop_end/n)-1)+1;
image_no_2=((x_crop_end/n)-1)+1;
image_no=(image_no_2*100)+image_no_1;

temp=num2str([num2str(image_no),'-',num2str(section_no),'--',num2str(x_crop_start),'_',num2str(x_crop_end),'-',num2str(y_crop_start),'_',num2str(y_crop_end),'.png']);
saveas(gcf,temp);