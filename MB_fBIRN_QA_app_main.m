function MB_fBIRN_QA_app_main(input,output)
%fBIRN_QA_APP_MAIN Summary of this function goes here
%   Detailed explanation goes here


%================Check inputs===========% 
tic

if nargin <2
    fprintf('Requires input and output directory. Exiting...\n');
    return;
end

%================Read dicom files====================%

[vol,meta,fwhm] = read_files_phantom(input,output);
  
%==============Calls fBIRN QA routine=================%


MB_fBIRN_phantom_ABCD(vol, meta, output,fwhm); 


%====================================


fprintf('Finished\n');
toc
end

