%% This code plotting the Hysteresis Loop
%put this script in the same direcory of the data.

%% clear workspace
clc
close all

%% import data of measurements
images = readImages();
% plotHisteresis(images);
myPlot(images, 21,59, 17, ".-")


%% iterate over all the files, and import B,H that measured. add them to struct

function [images]=readImages()
    files=dir("./domain measure/*.bmp");
    for k=length(files):-1:1 %repeat for every file
        clc
        fprintf("%2d",k);
        images(k) = getImage(files(k));
    end
%     images = getImage(files(18));
end

function [data]= getImage(file)
    image = imread(file.folder+"/"+file.name);
    data.gray = rgb2gray(image);
    [thresh,metric] = multithresh(data.gray);
    if metric>0.85
        data.boolIm = imquantize(data.gray,thresh,[false,true]);
    else
        data.boolIm = rescale(data.gray)>0.4;
        bright = data.gray(data.boolIm);
        dark = data.gray(~data.boolIm);
        bright_mean=mean(bright,'all');
        dark_mean=mean(dark,'all'); 
        tmp=[500,500];
        m=501;
        k=0;
    %     for k=1:5
        while all((tmp-m).^2 > 0.1)&&k<20
            k=k+1;
            brightStd = std(double(bright));
            darkStd = std(double(dark));
            tmp(1)=tmp(2);
            tmp(2) = m;
            m=(brightStd*bright_mean+darkStd*dark_mean)/(darkStd+brightStd);
            data.boolIm = data.gray>m;
            bright = data.gray(data.boolIm);
            dark = data.gray(~data.boolIm);
            bright_mean=mean(bright,'all');
            dark_mean=mean(dark,'all'); 
        end
    end
%     tmp = 128;
%     while (threshold-tmp)^2>1e-1
% %     for k=1:8
%         bright_mean=mean(data.gray(data.boolIm), 'all');
%         dark_mean=mean(data.gray(~data.boolIm), 'all');
%         tmp = threshold;
%         threshold = mean([bright_mean, dark_mean], 'all');
%         data.boolIm = data.gray>threshold;
%     end
    data.boolSum = mean((2 * data.boolIm) - 1, 'all');
    data.fileName= file.name;
    data.idx = str2double(file.name(1:3));
    %setting the sign of the voltage
    sign = 1-2*((40<data.idx) & (data.idx<81));
    data.volt = sign*str2double(file.name(5:7));
    data.current = str2double(file.name(10:12));
    [data.mag, ~] = imgradient(data.boolIm);
    m=mean(data.mag,'all');
    s=std(data.mag,[],'all');
    data.wall = data.mag>(m+2*s);
    data.wall_length = mean(data.wall,'all');
end


% function []=analizeImages(images)
%     for k=1:length(images)
%         images(k).image = histeq(double(rgb2gray(images(k).image))/255);
%     end
% end