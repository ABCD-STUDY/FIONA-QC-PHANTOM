# FIONA-QC-PHANTOM
Online QC operations performed on Phantom MRI data

## Setup

The project contains MATLAB source code that will be running inside a docker environment. In MATLAB use the deploy-tool to create a binary version of the source code. This binary can be run using the MATLAB run-time environment - which does not require a separate MATLAB version.

The entry point to this project is the QC_app_main_fordeployment function which will receive an input directory and an output directory.