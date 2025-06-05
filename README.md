# EM Image Analysis MATLAB Library

This MATLAB library consists of a collection of functions for analyzing Electron Microscopy (EM) images in the MRC format. These functions can be used to develop analysis pipelines for processing and extracting spectral information from 3D EM images. 

## Function Descriptions

### 1. **ReadMRCHeader**
   - **Description**: Reads the header of an MRC file and displays its metadata in the output terminal. This function does not return any output.
   - **Usage**: 
     ```matlab
     ReadMRCHeader(filename)
     ```
   - **Inputs**: 
     - `filename`: Name of the MRC file (with extension). If the file is in a different directory, specify the full path.
     
---

### 2. **ReadOneXYSectionMRC**
   - **Description**: Reads one section along the XY plane from an MRC file and stores it as a 2D array for further use.
   - **Usage**: 
     ```matlab
     slice = ReadOneXYSectionMRC(filename, section_no)
     ```
   - **Inputs**: 
     - `filename`: Name of the MRC file (with extension).
     - `section_no`: The section number along the XY plane to extract.
   - **Outputs**: 
     - `slice`: 2D array containing the pixel values of the specified section.

---

### 3. **ReadOneXZSectionMRC**
   - **Description**: Reads one section along the XZ plane from an MRC file and stores it as a 2D array for further use.
   - **Usage**: 
     ```matlab
     slice = ReadOneXZSectionMRC(filename, section_no_Y)
     ```
   - **Inputs**: 
     - `filename`: Name of the MRC file (with extension).
     - `section_no_Y`: The section number along the XZ plane (Y is constant).
   - **Outputs**: 
     - `slice`: 2D array containing the pixel values of the specified section.

---

### 4. **ReadOneYZSectionMRC**
   - **Description**: Reads one section along the YZ plane from an MRC file and stores it as a 2D array for further use.
   - **Usage**: 
     ```matlab
     slice = ReadOneYZSectionMRC(filename, section_no_X)
     ```
   - **Inputs**: 
     - `filename`: Name of the MRC file (with extension).
     - `section_no_X`: The section number along the YZ plane (X is constant).
   - **Outputs**: 
     - `slice`: 2D array containing the pixel values of the specified section.

---

### 5. **ReadSubVolumeMRC**
   - **Description**: Crops a range of sections along the Z-axis from an MRC file and stores the result as a 3D array.
   - **Usage**: 
     ```matlab
     slice3d = ReadSubVolumeMRC(filename, Zstart, Zend)
     ```
   - **Inputs**: 
     - `filename`: Name of the MRC file (with extension).
     - `Zstart`: The starting Z-section.
     - `Zend`: The ending Z-section.
   - **Outputs**: 
     - `slice3d`: 3D array containing the cropped sections from Zstart to Zend.

---

### 6. **DisplayOneSectionMRC**
   - **Description**: Visualizes a 2D image slice from the EM volume in the MATLAB figure window.
   - **Usage**: 
     ```matlab
     DisplayOneSectionMRC(slice, section_no)
     ```
   - **Inputs**: 
     - `slice`: 2D array containing the pixel values of the section to be visualized.
     - `section_no`: The section number for the visualization.
     
---

### 7. **mtspec2d_sq**
   - **Description**: Calculates the spectral information of a square image using Multitaper Spectral Analysis.
   - **Usage**: 
     ```matlab
     s = mtspec2d_sq(im, p, k, pad)
     ```
   - **Inputs**: 
     - `im`: 2D array (square size) containing pixel values of the image.
     - `p`: Product of space and half-bandwidth.
     - `k`: Number of tapers used for spectral estimation.
     - `pad`: Padding of zeros.
   - **Outputs**: 
     - `s`: 2D array containing the magnitude of the multitaper spectral estimate.

---

### 8. **mtspec2d_tiled**
   - **Description**: Computes the spectral information by dividing the image into tiles using a moving window and averaging the spectral information using Multitaper Spectral Analysis.
   - **Usage**: 
     ```matlab
     s = mtspec2d_tiled(im, n, p, k, pad)
     ```
   - **Inputs**: 
     - `im`: 2D array containing the pixels of the image.
     - `n`: Size of the moving window.
     - `p`: Product of space and half-bandwidth.
     - `k`: Number of tapers used for spectral estimation.
     - `pad`: Padding of zeros.
   - **Outputs**: 
     - `s`: 2D array containing the magnitude of the multitaper spectral estimate.

---

### 9. **mtspec2d_visualization**
   - **Description**: Crops a rectangle from a 2D slice, applies multitaper spectral analysis, and saves the visualization as a PNG image.
   - **Usage**: 
     ```matlab
     mt_crop = Multitaper_Crop_2D(filename, section_no, x_crop_start, x_crop_end, y_crop_start, y_crop_end)
     ```
   - **Inputs**: 
     - `filename`: Name of the MRC file (with extension).
     - `section_no`: Section number of the input EM image for visualization.
     - `x_crop_start, x_crop_end`: Start and end positions of the crop on the x-axis.
     - `y_crop_start, y_crop_end`: Start and end positions of the crop on the y-axis.
   - **Outputs**: 
     - `mt_crop`: Output of the multitaper spectral analysis on the cropped image.

---

### 10. **squaredpss_3D**
   - **Description**: Calculates 3D tapers by the outer product of Slepians.
   - **Usage**: 
     ```matlab
     tapers = squaredpss_3D(n, p, k)
     ```
   - **Inputs**: 
     - `n`: Linear dimension of the 3D image.
     - `p`: Space-half bandwidth product.
     - `k`: Number of tapers kept (~2*p-1).
   - **Outputs**: 
     - `tapers`: 3D tapers.

---

### 11. **mtspec3D_sq**
   - **Description**: Calculates spectral information of a cube-shaped 3D volume using Multitaper Spectral Analysis.
   - **Usage**: 
     ```matlab
     s = mtspec3D_sq(vol, p, k, pad)
     ```
   - **Inputs**: 
     - `vol`: 3D volume (cube).
     - `p`: Space-half bandwidth product.
     - `k`: Number of tapers used for spectral estimation.
     - `pad`: Padding of zeros.
   - **Outputs**: 
     - `s`: Estimated spectral information.

---

### 12. **mtspec3D_tiled**
   - **Description**: Computes spectral information for a 3D image by dividing it into sub-volumes and averaging spectral information using Multitaper Spectral Analysis.
   - **Usage**: 
     ```matlab
     s = mtspec3D_tiled(vol, n, p, k, pad)
     ```
   - **Inputs**: 
     - `vol`: 3D volume containing pixel values.
     - `n`: Size of the moving 3D window.
     - `p`: Space-half bandwidth product.
     - `k`: Number of tapers.
     - `pad`: Padding of zeros.
   - **Outputs**: 
     - `s`: 3D array containing the magnitude of the multitaper spectral estimate.

---

### 13. **img_pca**
   - **Description**: Calculates the Principal Component Analysis (PCA) of the given image and reconstructs it using the first `k` principal components.
   - **Usage**: 
     ```matlab
     img_pca = pca_image(img, k)
     ```
   - **Inputs**: 
     - `img`: Input image.
     - `k`: Number of principal components used for reconstruction.
   - **Outputs**: 
     - `img_pca`: Reconstructed image.

---

### 14. **radially_average_spectrum**
   - **Description**: Calculates the radially averaged spectrum of an image.
   - **Usage**: 
     ```matlab
     rad_avg = radially_average_spectrum(img, x_pixel_size, y_pixel_size)
     ```
   - **Inputs**: 
     - `img`: Input image.
     - `x_pixel_size`: Physical size of the pixel in the x-dimension (nanometers).
     - `y_pixel_size`: Physical size of the pixel in the y-dimension (nanometers).
   - **Outputs**: 
     - `rad_avg`: Radially averaged spectrum.
    
     
### Contributors
*Pratik Purohit, Partha Mitra (CSHL) , Harald Hess (Janelia Research Campus, HHMI)*
