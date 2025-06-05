function DisplayOneSectionMRC(slice,section_no)
% This function visualise the 2D image slice of the EM volume in MATLAB
% Figure window.
%
% Usage:
%   DisplayOneSectionMRC(slice,section_no)
%
% Input:
%       slice: 2D array which contain the pixel values of section to be
%              visualied.
%       section_no: The section number to which the 2D array data (slice)
%       belongs to. The function put the section number in the
%       visualization.

imagesc(slice);
axis equal; % to set the aspec ratio equal in each direction
axis tight; % to fit the axis tightly around the data
set(gca, 'ydir', 'normal'); % Changing the direction of Y axis in normal direction
title(['Section Number: ',num2str(section_no)]); % Setting the title of the figure
xlabel('X'); % labeling the X axis
ylabel('Y'); % labeling the Y axis
colormap(gray); % Choosing grayscale colormap 
colorbar % for showing the colorbar in the figure

end
