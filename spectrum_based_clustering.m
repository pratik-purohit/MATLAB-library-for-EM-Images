function cluster_img=spectrum_based_clustering(img,section_no,tile_size,moving_window_size,p,k)
% This function divide the input image into tiles, calculates the spectral
% information using Multitaper Spectral Analysis, apply k-mean algorithm to
% cluster image pixels and show the clusters by different colors.
%
% Usage:
%       cluste_img=spectrum_based_clustering(img,tile_size,moving_window_size,p,k)
% Input:
%       img: input image
%       section_no: Section number of the input EM image for visualization
%       purpos only.
%       tile_size: size of a tile, image will be divide into the tiles of
%       given size
%       moving_window_size: Size of a moving window used to calculate the
%       average spectral information using Multitaper Spectral Analysis
%       p: product of the space - halfbandwidth (must be less than half of
%       moving window size)
%       k: number of tapers 
% Output:
%       cluster_img: Output image where the pixel value correspond to the
%       cluster number


img=img-mean(mean(img));
dim=size(img); % Size of the section

% To obtain the number of image tules when dividing the EM section. The
% size of each image patch is tile_size x tile_size
x_i=int32(floor(dim(2)/tile_size)); 
y_i=int32(floor(dim(1)/tile_size));

window_size_padding=2^(1+nextpow2(moving_window_size)); % Moving Window Size after Zero Padding

cluster_img=zeros(dim); % 2D array for storing the results

first=1;

for y=1:y_i
   disp([num2str(y),' out of ',num2str(y_i)]);
   tic
   for x=1:x_i
        % Getting tile
        tile=img((1+(y-1)*tile_size):(tile_size +(y-1)*tile_size),(1+(x-1)*tile_size):(tile_size +(x-1)*tile_size));
        % Obtaining the spectral information of a image patch. 
        % The size of the output: moving window X moving window
        [rad_avg,radial_frequency_range,s]=radially_average_spectrum(tile,moving_window_size,p,k,window_size_padding,4,4);

        % Logarithm of the radially averagespectru
        mt_inv=20*(log10(rad_avg)/log10(rad_avg(1)));
        if first==1
            rm=size(radial_frequency_range);
            mt_kmeans=zeros(rm(1),y_i,x_i);
            first=0;
        end
        % Arranging the reconstructed image for kmeans algorithm
        mt_kmeans(:,y,x)=mt_inv(:); 
    end
    toc
end

tic
% Converting the 2D image into 1D array
mt_kmeans_flat=zeros(rm(1),y_i*x_i); 
temp=1;

for y=1:y_i
    for x=1:x_i
        mt_kmeans_flat(:,temp)=mt_kmeans(:,y,x);
        temp=temp+1;
    end
end

% Test for finding the optimum numbers of the clusters
ssd=zeros(1,9);
silhouette_vals=zeros(1,9);
for no_of_clusters=2:9
    [position,centroid,sumd]=kmeans(mt_kmeans_flat',no_of_clusters,'Options',statset('UseParallel',1),'MaxIter',10000,'Display','final','Replicates',10);
    ssd(1,no_of_clusters)=sum(sumd);
    silhouette_vals(1,no_of_clusters) = mean(silhouette(mt_kmeans_flat', position));
end

% Find the moving average along SSD
ssd_mavg=zeros(size(ssd,1),size(ssd,2));
for qq=1:size(ssd,2)
    ssd_mavg(qq)=sum(ssd(1:qq))/qq;
end

% Applying the kmean algorithm
no_of_clusters=1+max(find(silhouette_vals==max(silhouette_vals)),find(ssd_mavg==max(ssd_mavg))); % Taking the optimum number of the clusters
%no_of_clusters=4; % Manually give the number of clusters
[position,centroid,sumd]=kmeans(mt_kmeans_flat',no_of_clusters,'Options',statset('UseParallel',1),'MaxIter',10000,'Display','final','Replicates',10);

std_i=zeros(y_i,x_i);
temp=1;
for y=1:y_i
    for x=1:x_i
        std_i(y,x)=position(temp); % Converting the 1D positions into 2D array, compatible with image
        temp=temp+1;
    end
end


for y=1:y_i
    for x=1:x_i
        % Replacing the all pixels in an image patch with the cluster
        % number
        cluster_img((1+(y-1)*tile_size):(tile_size +(y-1)*tile_size),(1+(x-1)*tile_size):(tile_size +(x-1)*tile_size))=std_i(y,x);
    end
end

% Visualization
tiledlayout(2,1)
f1=nexttile();
DisplayOneSectionMRC(img,section_no);
colormap(f1,"gray")
f2=nexttile();
DisplayOneSectionMRC(cluster_img,section_no);
title({['Tile size: ',num2str(tile_size),' x ',num2str(tile_size)];['Moving Window Size for Spectrum:',num2str(moving_window_size),' x ',num2str(moving_window_size)]});

% RGB values of 10 contrasting colors
colors = [
    255   0     0;      % Red
    0     255   0;      % Green
    0     0     255;    % Blue
    0   0   0;      % Black
    255   255     255;    % Magenta
    0     255   255;    % Cyan
    255   128   0;      % Orange
    128   0     255;    % Purple
    0     128   255;    % Sky blue
    255   128   128     % Pink
];

map = colors/255;   % Scale the values between 0 and 1
colormap(f2,map(1:no_of_clusters,1:3))

toc
