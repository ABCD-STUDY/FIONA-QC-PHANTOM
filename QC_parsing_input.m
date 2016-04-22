function [code, seriesList] = QC_parsing_input(input,dcmkey,manufactkey)
%QC_PARSING_INPUT Summary of this function goes here
%   Detailed explanation goes here


%Obtain content of input folder
code=0;
inputFolderList = dir(input);
inputFolderList=inputFolderList(~ismember({inputFolderList.name},{'.','..'}));

if mod(length(inputFolderList),2)
    fprintf('Each folder requires a json file. Aborting...');
end
seriesList = struct([]);
jsonindex=1;
for i=1:length(inputFolderList)
   [route, name, ext] = fileparts(inputFolderList(i).name);
   if (strcmp(ext,'.json'))
       seriesList(jsonindex).foldername = name;
       seriesList(jsonindex).seriesKey ='';
       fname = fullfile(input,inputFolderList(i).name);
       jsonFile = loadjson(fname);
       seriesList(jsonindex).jsondata = jsonFile;
       jsonindex = jsonindex + 1;
   end
   
end

for i=1:length(manufactkey)
    if(findstr(seriesList(1).jsondata.Manufacturer, cell2mat(manufactkey(i).regexp)));
        code = str2double(manufactkey(i).key);        
    end
end

for i=1:length(seriesList)
    for j=1:length(dcmkey)
        if(strcmp(seriesList(i).jsondata.SeriesDescription, cell2mat(dcmkey(j).regexp)));
            seriesList(i).seriesKey = str2double(dcmkey(j).key);
        end
    end
end


end

