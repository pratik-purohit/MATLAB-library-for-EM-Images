function slice3d=ReadSubVolumeMRC(filename,Zstart,Zend)
% This function crops the given range of the section (From Zstart upto
% Zend) and store in a 3D array. This functions crops only in Z direction.
%
% Usage
%   slice3d=ReadSubVolumeMRC(filename,Zstart,Zend)
% 
% Input:
%       filename: Name of the MRC file with extension. If the MRC file is situated in the other directory 
%                 in which the script is, then specify the complete path of the file.
%       Zstart and Zend: Range of section number from Zstart upto Zend will
%                        be cropped from the 3D EM Volume. 
%
% Output:
%       slice3d: A 3D array which contains the pixels belong to section
%       from Zstart upto Zend (including both Zstart and Zend).
% 

% For generating error when no input is specified.
if nargin ~= 3
    error("Please Specify the MRC file and range of section number.")
end

% For generating error when the input file's extension is not MRC
[path,name,extension]=fileparts(filename);

if strcmp(extension,".mrc")==false
    error("The function accepts file with mrc extension only. Please check the extension of the input file");
end

% File-open operation for reading the input file
ID = fopen(filename,'r');

% For generating the error if the file-open operation was unsuccessful
if ID==-1
    error('***Error in Reading File***')
end

% Saving the Header Information
Header=fread(ID,256,'*int32');
 
% Reading the individual fields
NX=Header(1); % Number of Columns
NY=Header(2); % Number of Rows
NZ=Header(3); % Number of Sections

MODE=Header(4); % Variable type used for storing the pixel values
STAMP=typecast(Header(54),"int8"); % To identify the endianess of data storage.


switch MODE
    case 0
        size=1;
        datatype='int8';
    case 1
        size=2;
        datatype='int16';
    case 2
        size=4;
        datatype='single';
    case 3
        size=4;
        datatype='int32';
    case 4
        size=8;
        datatype='double';
    case 6
        size=2;
        datatype='uint16';
    case 12
        size=2;
        datatype='float16';
    case 101
        size=0.5;
        datatype='int4';
    otherwise
        error('Unabel to get the mode of saving data')
end

if STAMP(1)==68 && STAMP(2)==65
    endian='l';
elseif STAMP(1)==17 && STAMP(2)==17
    endian='b';
else
    endian='l';
end

% Generating Error if Zstart is greater than total number of sections or
% negative.
if Zstart>NZ || Zstart < 0
    error([num2str(Zstart), ' is beyond allowalbe section range: 0-', num2str(NZ)]);
end

% Generating error if Zend is greater than total number of sections or
% negative.
if Zend>NZ || Zend < 0
    error([num2str(Zend), ' is beyond allowalbe section range: 0-', num2str(NZ)]);
end

% Generating error if Zstart is less than Zend
if Zstart > Zend
    error('Zstart must be less than Zend')
end

section_range=Zend-Zstart;
slice3d=zeros(NY,NX,section_range); % Creating a empty 3D array to store the results.

s=0;
for section_no=Zstart:Zend
    s=s+1;
    fseek(ID,(1024)+((section_no-1)*(NX*NY*size)),'bof'); % To set the address, from where to get the data.
    raw_data=fread(ID,double(NX)*double(NY),datatype,endian); % Obtaining the pixels belong to one section as 1D data.

    for i=1:NY
        row_start=(1+((i-1)*NX));
        row_end=(i*NX);
        slice3d(i,:,s)=raw_data(row_start:row_end); % Converting the 1D data into 2D data, row by row.
    end
end

fclose(ID); % Closing the file.

end


