%% This code plotting the Hysteresis Loop
%put this script in the same direcory of the data.

%% clear workspace
clc
close all

%% import data of measurements
images = readImages();
% analizeImages(images);

%% iterate over all the files, and import B,H that measured. add them to struct

function [images]=readImages()
    files=dir("./domain measure/*.bmp");
    for k=length(files):-1:1 %repeat for every file
        images(k) = getImage(files(k));
        
%        Resistance = files(k).name(14:end-4);
%         Material =str2double(files(k).name(10));

% 
%             update the outer struct with the new data
%         currentStruct = struct('ch1',ch1,...
%             'Times',times,'ch2',ch2,'fileName',files(k).name, 'Resistance',...
%             Resistance,'Material',Material);
%         OuterStruct(m,k).currentData = currentStruct;

    end
end

function [data]= getImage(file)
    data.image = imread(file.folder+"/"+file.name);
    data.gray = rgb2gray(data.image);
    data.rescale = rescale(data.gray);
    data.boolIm = data.rescale>0.4;
    data.fileName= file.name;
    data.idx = str2double(file.name(1:3));
    %change the sign of voltage
    data.volt = (1-2*((40<data.idx) & (data.idx<81)))*str2double(file.name(5:7));
    data.current = str2double(file.name(10:12));
    
end


function []=analizeImages(images)
    for k=1:length(images)
        images(k).image = histeq(double(rgb2gray(images(k).image))/255);
    end
end