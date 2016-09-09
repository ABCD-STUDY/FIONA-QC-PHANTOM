# FIONA-QC-PHANTOM
Online QC operations performed on Phantom MRI data

## Version history

### 0.0.1 (latest stable)

- Works for GE, SIEMENS and Philips acquisitions

## Setup

The project contains MATLAB source code that will be running inside a docker environment. In MATLAB use the deploy-tool to create a binary version of the source code. This binary can be run using the MATLAB run-time environment - which does not require a separate MATLAB version.

The entry point to this project is the fBIRN_QA_app_main.m function for non-multiband series and the MB_fBIRN_QA_app_main.m function for multiband series. These functions will receive an input directory and an output directory.

## Requirements

This project will produce output files including json files. When using the code or compiling it make sure you have the function savejson from jsonlab [a link](https://www.mathworks.com/matlabcentral/fileexchange/33381-jsonlab--a-toolbox-to-encode-decode-json-files) within your path or modify the code to save the output json files in your preferred way.