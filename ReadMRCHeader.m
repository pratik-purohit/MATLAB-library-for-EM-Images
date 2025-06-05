function ReadMRCHeader(filename)
% This function reads the header of a MRC file and display in the output
% terminal. The function doesn't return anything.
%
% Usage: 
% ReadMRCHeader(filename)
%
% Input: 
%          filename: Name of the MRC file with extension. If the MRC file is situated in the other directory 
%                    in which the script is, then specify the complete path of the file.
% 

% For generating error when no input is specified.
if nargin ~= 1
    error("Please Specify the MRC file.")
end

% For generating error when the input file's extension is not MRC
[path,name,extension]=fileparts(filename);

if strcmp(extension,".mrc")==false
    error("The function accepts file with mrc extension only. Please check the extension of the input file");
end

% File-open operation for reading the input file
ID = fopen(filename);

% For generating the error if the file-open operation was unsuccessful
if ID==-1
    error('***Error in Reading File***')
end

% Reading the 1024 bytes of the header. ( 256 words x 4 bytes )
Header=fread(ID,256,'*int32');

%---------------------------------------------------
% Extracting the information from the header.
% Based on following MRC format available at:
% https://bio3d.colorado.edu/imod/doc/mrc_format.txt 
% https://www.ccpem.ac.uk/mrc_format/mrc2014.php
%---------------------------------------------------
NX=Header(1); % Number of Columns
NY=Header(2); % Number of Rows
NZ=Header(3); % Number of Sections

MODE=Header(4); % Variable type used for storing the pixel values

NXSTART=Header(5); % Location of first Column
NYSTART=Header(6); % Location of first Row
NZSTART=Header(7); % Locatino of first Section

% Grid size in X, Y and Z
MX=Header(8); 
MY=Header(9);
MZ=Header(10);

% Cell dimensions in X, Y and Z dimension. Unit: Angstrom.
CELLAX=typecast(Header(11),"single"); 
CELLAY=typecast(Header(12),"single");
CELLAZ=typecast(Header(13),"single");

% Cell Angles in X, Y and Z dimension. Unit: Degrees
CELLBX=typecast(Header(14),"single"); %Cell angles in degrees
CELLBY=typecast(Header(15),"single");
CELLBZ=typecast(Header(16),"single");

MAPC=Header(17); % Axis belong to Columns
MAPR=Header(18); % Axis belong to Rows
MAPS=Header(19); % Axis belong to Sections

DMIN=typecast(Header(20),"single"); % Minimum value of pixel. Changing variable type from int32 to single(float32).
DMAX=typecast(Header(21),"single"); % Maximum value of pixel. Changing variable type from int32 to single(float32).
DMEAN=typecast(Header(22),"single"); % Average Value of pixel. Changing variable type from int32 to single(float32).

ISPG=Header(23); % ISPG=0 for Image Stack and ISPG=1 for Volume
NSYMBT=Header(24); % Size of Extended Header

EXTRA=Header(25:49); % Data in the Extended Header

% Origin of images in X, Y and Z dimension. Changing variable type from int32 to single(float32)
ORIGINx=typecast(Header(50),"single"); 
ORIGINy=typecast(Header(51),"single");
ORIGINz=typecast(Header(52),"single");

MAP=typecast(Header(53),"int8"); % Charecter string "MAP" to identify filetype
STAMP=typecast(Header(54),"int8"); % To identify the endianess of data storage.
RMS=typecast(Header(55),"single"); % RMS deviation from the mean 
NLABL=Header(56); % Number of Lables being used

%--------------------------------------
% Displaying the headerfile information
%--------------------------------------
disp(['Number of Columns: ', num2str(NX) ])
disp(['Number of Rows: ', num2str(NY) ])
disp(['Number of Sections: ', num2str(NZ) ])

switch MAPC
    case 1
        disp('Axis corresponding to column: X')
    case 2
        disp('Axis corresponding to column: Y')
    case 3
        disp('Axis corresponding to column: Z')
end

switch MAPR
    case 1
        disp('Axis corresponding to row: X')
    case 2
        disp('Axis corresponding to row: Y')
    case 3
        disp('Axis corresponding to row: Z')
end
        
switch MAPS
    case 1
        disp('Axis corresponding to section: X')
    case 2
        disp('Axis corresponding to section: Y')
    case 3
        disp('Axis corresponding to section: Z')
end

disp(['Origin of the image (x,y,z) --> (', num2str(ORIGINx),',', num2str(ORIGINy),',', num2str(ORIGINz),')'])

switch MODE
    case 0
        disp('Mode of saving data:  8-bit signed integer')
        size=1;
    case 1
        disp('Mode of saving data:  16-bit signed integer')
        size=2;
    case 2
        disp('Mode of saving data:  32-bit float')
        size=4;
    case 3
        disp('Mode of saving data:  Complex 16-bit integers')
        size=4;
    case 4
        disp('Mode of saving data:  Complex 32-bit reals')
        size=8;
    case 6
        disp('Mode of saving data:  16-bit unsigned integer') 
        size=2;
    case 12
        disp('Mode of saving data:  16-bit float (IEEE754')
        size=2;
    case 101
        disp('Mode of saving data:  4-bit data')
        size=0.5;
    otherwise
        disp('Unabel to get the mode of saving data')
end

image_size=(double(NX)*double(NY)*double(NZ)*double(size))/1048576; % Calculating the size of the image in MB
disp(['Total Size occupied: ', num2str(image_size),' MB'])

disp(['Location of first Column, Row and Section :', num2str(NXSTART),',', num2str(NYSTART),' and ', num2str(NZSTART) ])
disp(['Grid Size in X, Y and Z: ', num2str(MX),',',num2str(MY),' and ',num2str(MZ) ])
disp(['Cell dimensions in agnstroms -- X, Y and Z: ',num2str(CELLAX),',', num2str(CELLAY),' and ', num2str(CELLAZ) ])
disp(['Cell angles -- alpha, beta and gamma: ',num2str(CELLBX),',', num2str(CELLBY),' and ', num2str(CELLBZ) ])
disp(['Pixel Values - Minimum, Maximum and Mean: ',num2str(DMIN),', ',num2str(DMAX),' and ',num2str(DMEAN)])

switch ISPG
    case 0
        disp('Type: Image Stack')
    case 1
        disp('Type: Volume')
end

disp(['Size of extended header: ', num2str(NSYMBT) ])


if STAMP(1)==68 & STAMP(2)==65
    disp('Little Endian')
elseif STAMP(1)==17 & STAMP(2)==17
    disp('Big Endian')
else
    disp('Could not determine endianess.')
end

end