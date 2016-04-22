function QC_app_main_fordeployment(input,varargin)
%HUMAN_QC_MAIN Summary of this function goes here
%   Detailed explanation goes here
tic

% ============== parse input arguments ============== %

main_success = false;

if nargin <2
    fprintf('Requires input and output directory. Aborting...\n');
    return;
elseif nargin == 2
        output = varargin{1};
elseif nargin == 3
        output = varargin{1};
        code = varargin{2};
end

if ~exist(input, 'dir')
    fprintf('Input directory does not exist. Aborting...\n');
    return;
end

[route, studyFolder] = fileparts(input);
output = fullfile(output,studyFolder);

if ~exist(output, 'dir')
    fprintf('Creating output directory\n');
    [success, message] = mkdir(output);
    if ~success;
        fprintf('%s -- %s.m:    ERROR: Problem making output directory - %s\n', datestr(now), mfilename, message);
        return;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%if isdeployed    
    % write out proc.json for smart routing
    fname_proc = sprintf('%s/proc.json', output);
    s = struct([]);
    s(1).success = 'fail';
    s(1).message = 'Phantom QC application failed.';
    s(2).success = '';
    s(2).message = '';
    opt.FileName = fname_proc;
    opt.ArrayIndent = 0;
    opt.NoRowBracket = 1;
    savejson('',s,opt);
%end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dcmkey = struct([]);
    
dcmkey(1).key = '1';
dcmkey(1).tagname = {'SeriesDescription'};
dcmkey(1).regexp = {'Coil QA'};

dcmkey(2).key = '2';
dcmkey(2).tagname = {'SeriesDescription'};
dcmkey(2).regexp = {'fBIRN QA'};

dcmkey(3).key = '3';
dcmkey(3).tagname = {'SeriesDescription'};
dcmkey(3).regexp = {'Multiband fMRI QA'};

dcmkey(4).key = '4';
dcmkey(4).tagname = {'SeriesDescription'};
dcmkey(4).regexp = {'Multiband Diffusion QA'};


manufactkey = struct([]);

manufactkey(1).key = '1';
manufactkey(1).tagname = {'Manufacturer'};
manufactkey(1).regexp = {'Siemens'};

manufactkey(2).key = '2';
manufactkey(2).tagname = {'Manufacturer'};
manufactkey(2).regexp = {'GE'};

manufactkey(3).key = '3';
manufactkey(3).tagname = {'Manufacturer'};
manufactkey(3).regexp = {'Philips'};

[code, seriesList] = QC_parsing_input(input,dcmkey,manufactkey);

for i=1:length(seriesList)
    
    if (~isempty(seriesList(i).seriesKey))
    
        switch seriesList(i).seriesKey
            case 2
                inputSeries = fullfile(input,seriesList(i).foldername);
                outputSeries = fullfile(output,seriesList(i).foldername);
                [vol,meta] = read_files(inputSeries,code);             
                fBIRN_phantom_ABCD(vol, meta, outputSeries, 0); 
            case 3
                inputSeries = fullfile(input,seriesList(i).foldername);
                outputSeries = fullfile(output,seriesList(i).foldername);
                %[vol,meta] = read_files(inputSeries,code);
                %fBIRN_phantom_ABCD(vol, meta, outputSeries, 1); 
            otherwise
                continue;
        end
    end
    
end

%if isdeployed    
    % write out proc.json for smart routing
    fname_proc = sprintf('%s/../proc.json', output);
    s = struct([]);
    s(1).success = 'success';
    s(1).message = 'Phantom QC application succeeded.';
    s(2).success = '';
    s(2).message = '';
    opt.FileName = fname_proc;
    opt.ArrayIndent = 0;
    opt.NoRowBracket = 1;
    savejson('',s,opt);
%end

main_success = true;

fprintf('Finished\n');

toc


end

