function fBIRN_QA_app_main(input,output)
%fBIRN_QA_APP_MAIN Summary of this function goes here
%   Detailed explanation goes here


%================Check inputs===========% 
tic

if nargin <2
    fprintf('Requires input and output directory. Exiting...\n');
    return;
end
%Check output directory and creates it if does not exist
if ~exist(output, 'dir')
    fprintf('Creating output directory\n');
    [success, message] = mkdir(output);
    if ~success;
        fprintf('%s -- %s.m:    ERROR: Problem making output directory - %s\n', datestr(now), mfilename, message);
        return;
    end
end

%================Read dicom files====================%

[vol,meta] = read_files_phantom(input);

%==============Calls fBIRN QA routine=================%


fBIRN_phantom_ABCD(vol, meta, output); 


%====================================


fprintf('Finished\n');
toc
end

