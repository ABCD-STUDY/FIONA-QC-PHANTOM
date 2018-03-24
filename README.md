# FIONA-QC-PHANTOM

QC operations performed on Phantom MRI data

## Version history

### 0.0.12 (lastest stable)

- Complete QA process as for 05/30/2017

### 0.0.2

- Calculates FWHM
- Saves nifti volume
- Provides coil information

### 0.0.1

- Works for GE, SIEMENS and Philips acquisitions

## Requirements

-This project will produce output files including json files. When using the code or compiling it make sure you have the function savejson from jsonlab [a link](https://www.mathworks.com/matlabcentral/fileexchange/33381-jsonlab--a-toolbox-to-encode-decode-json-files) within your path or modify the code to save the output json files in your preferred way.

-mri_convert is required.

-afni is required.

-Tools for NIfTI and ANALYZE image (https://www.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image) is required.

This code is tested in Matlab under Linux, It should work for other platform but no test has done yet.

### Usage
To start with this tool, please follow steps below:
1. create two directories, one is for data input and the other one is for data output (You can use one directory for both though).
2. unpack ABCD dicom data into a subdirectory in the input directory. For example, if you have data ABCD_Phantom001.tgz, then your input directory structure will look like:
 /path/to/input
   |___ABCD_Phantom001
         |____1.3.12.2.1107.5.2.43.67078.201803190805526056999102609.0.0.0.json
         |____1.3.12.2.1107.5.2.43.67078.201803190805526056999102609.0.0.0
                |____1.3.12.2.1107.5.2.43.67078.2019999190811435233081052
                |____1.3.12.2.1107.5.2.43.67078.2019999190811435233081053
                |____..._
3. in matlab, execute PQA('/path/to/input','/path/to/output')
4. expect result in /path/to/output

### Current maintainer:
Feng Xue @ DAIC
