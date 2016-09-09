function [vol4D, meta] = read_files_phantom(input)
%PHANTOM_FMRI Summary of this function goes here
%
%   Reads dicoms from fMRI phantom QC
%
%   Detailed explanation goes here


filelist = dir(input);
filelist = filelist(~[filelist.isdir] & ~strncmpi('.', {filelist.name}, 1));
fullfilename = fullfile(input,filelist(1).name);
if file_is_dicom(fullfilename)

info=dicominfo(fullfilename);
    s_date = info.StudyDate;
    s_time = info.StudyTime;
    si_UID = info.StudyInstanceUID;
    manufact = info.Manufacturer;
    model = info.ManufacturerModelName;
else
    fprintf('Only dicoms should be included in this folder. Aborting...\n');
    return;
end


if (strfind(info.Manufacturer, 'GE')) %GE never assumes mosaic
    [vol4D, meta] = read_ge_phantom(input,filelist);
elseif  (strfind(info.Manufacturer, 'SIEMENS')) %SIEMENS assumes mosaic
    [vol4D, meta] = read_siemens_phantom(input,filelist);
elseif (strfind(info.Manufacturer, 'Philips')) %Philips never assumes mosaic
    [vol4D, meta] = read_philips_phantom(input,filelist);
    return;
end

end    

function [vol4D, meta]=read_siemens_phantom(input,filelist)

fullfilename = fullfile(input,filelist(1).name);
if file_is_dicom(fullfilename)
    info=dicominfo(fullfilename);
    nVx = double(info.AcquisitionMatrix(1));
    nVy = double(info.AcquisitionMatrix(4));
    nSlices = double(info.Private_0019_100a);
    nFrames = length(filelist);
    
    imageFreq = info.ImagingFrequency;
    transmitGain = 0;
    aRecGain = 0;
    
    sx = info.PixelSpacing(1);
    sy = info.PixelSpacing(2);
    sz = info.SliceThickness;
    
    TR = info.RepetitionTime;
    
    
    s_date = info.StudyDate;
    s_time = info.StudyTime;
    si_UID = info.StudyInstanceUID;
    manufact = info.Manufacturer;
    model = info.ManufacturerModelName;
else
    fprintf('Only dicoms should be included in this folder. Aborting...');
    return;
end

meta = struct('TR',TR, 'imageFreq', imageFreq, 'transmitGain', transmitGain, 'aRecGain', aRecGain, 'sx', sx, 'sy', sy, 'sz', sz,...,
    's_date', s_date, 's_time', s_time, 'si_UID', si_UID, 'manufact', manufact, 'model', model);
vol4D = zeros(nVx, nVy, nSlices, nFrames);

%Get Slice coordinates from Mosaic

mosaicShape = ceil(sqrt(double(nSlices)));

for a=1:length(filelist)
    fullfilename = fullfile(input,filelist(a).name);
    if(file_is_dicom(fullfilename))   
        info = dicominfo(fullfilename);   
        instanceNumber = info.InstanceNumber;
        fullMosaic = dicomread(fullfilename);
            for j=1:nSlices
                mRow = 1+fix(j/mosaicShape);
                mColumn = mod(j,mosaicShape);
                if mColumn==0
                    mColumn=mosaicShape;
                    mRow = mRow-1;
                end
                x1 = 1 + (mColumn-1)*nVx;
                x2 = x1 + nVx - 1;
                y1 = 1 + (mRow-1)*nVy;
                y2 = y1 + nVy - 1;
                vol4D(:,:,j,instanceNumber) = fullMosaic(y1:y2,x1:x2);
            end
    else
        fprintf('Only dicoms should be included in this folder. Aborting...');
        return;
    end
end

end


function [vol4D, meta]=read_ge_phantom(input,filelist)

fullfilename = fullfile(input,filelist(1).name);
if(file_is_dicom(fullfilename))
    info=dicominfo(fullfilename);
    nVy = info.Rows;
    nVx = info.Columns;
    nImages = info.ImagesInAcquisition;
    nFrames = info.NumberOfTemporalPositions;
    
    sx = info.PixelSpacing(1);
    sy = info.PixelSpacing(2);
    sz = info.SliceThickness;
    
    imageFreq = info.Private_0019_1093;
    transmitGain = info.Private_0019_1094;
    aRecGain = info.Private_0019_1095;
    if (nImages > nFrames)
        while(mod(nImages,nFrames)~=0)
            nFrames = nFrames-1; 
        end
        nSlices = nImages/nFrames;
    else
        nSlices = nImages;
    end
    TR = info.RepetitionTime;
    
    
    s_date = info.StudyDate;
    s_time = info.StudyTime;
    si_UID = info.StudyInstanceUID;
    manufact = info.Manufacturer;
    model = info.ManufacturerModelName;
    
else
    fprintf('Only dicoms should be included in this folder. Aborting...');
    return;
end

vol4D = zeros(nVx, nVy, nSlices, nFrames);

for a=1:length(filelist)
    tic
    fullfilename = fullfile(input,filelist(a).name);
    if(file_is_dicom(fullfilename))   
        
        if isdeployed
            % 1. Assumed order is correct
            instanceNumber = a;
        else
            % 2. Double checking order is correct       
            info = dicominfo(fullfilename);   
            instanceNumber = info.InstanceNumber;
        end        
        
        % 3. Getting order from name extension
        
        %[route name ext] = fileparts(fullfilename);
        %instanceNumber = str2double(ext(2:end));
        
        slice = mod(instanceNumber,nSlices);
        if slice==0, slice=nSlices; end
        frame = ceil(instanceNumber/nSlices);
        [vol4D(:,:,slice,frame)]= dicomread(fullfilename); 
        toc
    else
        fprintf('Only dicoms should be included in this folder. Aborting...');
        return;
    end
end

meta = struct('TR',TR, 'imageFreq', imageFreq, 'transmitGain', transmitGain, 'aRecGain', aRecGain, 'sx', sx, 'sy', sy, 'sz', sz,...,
    's_date', s_date, 's_time', s_time, 'si_UID', si_UID, 'manufact', manufact, 'model', model);

end


function [vol4D, meta]=read_philips_phantom(input,filelist)

fullfilename = fullfile(input,filelist(1).name);
if(file_is_dicom(fullfilename))
    info=dicominfo(fullfilename);
    nVy = info.Rows;
    nVx = info.Columns;
    nImages = length(filelist);
    nFrames = double(info.NumberOfTemporalPositions);
    
    sx = info.PixelSpacing(1);
    sy = info.PixelSpacing(2);
    sz = info.SliceThickness;
    
    imageFreq = info.ImagingFrequency;
    transmitGain = 0;
    aRecGain = 0;
    
    nSlices = nImages/nFrames;
    TR = info.RepetitionTime;
    
    
    s_date = info.StudyDate;
    s_time = info.StudyTime;
    si_UID = info.StudyInstanceUID;
    manufact = info.Manufacturer;
    model = info.ManufacturerModelName;
    
else
    fprintf('Only dicoms should be included in this folder. Aborting...');
    return;
end

vol4D = zeros(nVx, nVy, nSlices, nFrames);

for a=1:length(filelist)
    tic
    fullfilename = fullfile(input,filelist(a).name);
    if(file_is_dicom(fullfilename))   
        
        if isdeployed
            % 1. Assumed order is correct
            instanceNumber = a;
        else
            % 2. Double checking order is correct       
            info = dicominfo(fullfilename);   
            instanceNumber = double(info.InstanceNumber);
            itemp = info.TemporalPositionIdentifier; 
        end        
        
        % 3. Getting order from name extension
        
        %[route name ext] = fileparts(fullfilename);
        %instanceNumber = str2double(ext(2:end));
        
        tmp_slice = ceil(instanceNumber/nFrames);
        %slice = mod(tmp_slice,nSlices);
        %if slice==0, slice=nSlices; end
        [vol4D(:,:,tmp_slice,itemp)]= dicomread(fullfilename); 
        toc
    else
        fprintf('Only dicoms should be included in this folder. Aborting...');
        return;
    end
end
meta = struct('TR',TR, 'imageFreq', imageFreq, 'transmitGain', transmitGain, 'aRecGain', aRecGain, 'sx', sx, 'sy', sy, 'sz', sz,...,
    's_date', s_date, 's_time', s_time, 'si_UID', si_UID, 'manufact', manufact, 'model', model);

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function isdicom=file_is_dicom(filename)
isdicom=false;
try
    fid = fopen(filename, 'r');
    status=fseek(fid,128,-1);  
    if(status==0)
        tag = fread(fid, 4, 'uint8=>char')';
        isdicom=strcmpi(tag,'DICM');
    end
    fclose(fid);
catch me
end

end