function slice=ReadOneXZSectionMRC(filename,section_no_Y)
% This function reads specified one section from a MRC file and store in a 2D array for further usage. 
%
% Usage:
%   slice=ReadOneSectionMRC(filename,section_no)
%
% Input:
%       filename: Name of the MRC file with extension. If the MRC file is situated in the other directory 
%                 in which the script is, then specify the complete path of the file.
%       section_no_Y: Specify the Section Number along the XZ plane (Y=constant) to extract from the 3D EM
%                   Scan.
% Output:
%       slice: A 2D array which contains the pixel values correspond to
%       specified section_no.
%

% For generating error when no input is specified.
if nargin ~= 2
    error("Please Specify the MRC file as well as section number.")
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

% Reading the 1024 bytes of the header. ( 256 words x 4 bytes )
Header=fread(ID,256,'*int32');

% Reading the individual fields 
NX=Header(1);
NY=Header(2);
NZ=Header(3);
MODE=Header(4);
STAMP=typecast(Header(54),"int8");

% Getting the variable type used for storing pixels
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

% For getting the endianess used to store the pixels in the memory
if STAMP(1)==68 && STAMP(2)==65
    endian='l';
elseif STAMP(1)==17 && STAMP(2)==17
    endian='b';
else
    endian='l';
end

% For generating error if the given section number along the XZ plane is more than the total
% number of available sections (i.e. maximum number of rows)
if section_no_Y > NY
    error([num2str(section_no_Y), ' is beyond the total number of sections(', num2str(NY),').']);
end

slice=zeros(NZ,NX); % Initializing a zero matrix for storing the data of given section.
NX=double(NX);
NY=double(NY);
size=double(size);
section_no_Y=double(section_no_Y);
% Converting the 1D data into 2D data. Row by Row.
for i=1:NZ
    i=double(i);
    %disp(double(((section_no_Y-1)*NX*size)+(NX*NY*size*(i-1))));
    fseek(ID,(1024)+double(((section_no_Y-1)*NX*size)+(NX*NY*size*(i-1))),'bof'); % To set the address from the data about given section-number starts
    raw_data=fread(ID,NX,datatype,endian); % Reading data about the given section-number in 1D array.
    slice(i,:)=raw_data';
end

fclose(ID); % Closing the file after getting the data.

end
