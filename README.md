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
