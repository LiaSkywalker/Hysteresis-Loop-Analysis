%% This code plotting the Hysteresis Loop
%put this script in the same direcory of the data.

%% clear workspace
clc
close all

%% import data of measurements
images = readImages();
% plotHisteresis(images);
myPlot(images, 21,59, 17, ".-")

%%
function grad=imGrad(image)
    dx=conv2([-1 0 1], [1], image.boolIm, 'same');
    dy=conv2([1], [-1 0 1], image.boolIm,'same');
    grad=sqrt(dx.^2+dy.^2);
end

%%
function plotHisteresisAlt(images)
    figure(1000);

    initV = [images(1:21).volt];
    decreaseV = [images(21:59).volt];
    increaseV = [images(59:99).volt];

    initB = [images(1:21).bright];
    decreaseB = [images(21:59).bright];
    increaseB = [images(59:99).bright];

    plot(initV, initB, decreaseV, decreaseB, increaseV, increaseB);

    title("Histeresis loop");
    xlabel("applied voltage $ \left[V\right] \propto H $", 'interpreter', 'latex');
    ylabel("average brightness in the braight domains $ \propto B $", 'interpreter', 'latex'); 
    set(gca,'fontsize',20);
    legend(["initial curve", "voltage decrease", "voltage increase"],  'Location', 'Best');
end

%%
function plotHisteresis(images)
    figure(1000);

    initV = [images(1:21).volt];
    decreaseV = [images(21:59).volt];
    increaseV = [images(59:99).volt];

    initBl = [images(1:21).boolSum];
    decreaseBl = [images(21:59).boolSum];
    increaseBl = [images(59:99).boolSum];

    plot(initV, initBl, decreaseV, decreaseBl, increaseV, increaseBl);

    title("Histeresis loop");
    xlabel("applied voltage $ \left[V\right] \propto H $", 'interpreter', 'latex');
    ylabel("$ ( \#bright - \#dark) \propto B $", 'interpreter', 'latex');
    set(gca,'fontsize',20);
    legend(["initial curve", "voltage decrease", "voltage increase"],  'Location', 'Best');
end

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
%     threshold = 1;
    data.boolIm = data.rescale>0.4;
    bright = data.gray(data.boolIm);
    dark = data.gray(~data.boolIm);
    data.bright=mean(bright,'all');
    data.dark=mean(dark,'all'); 
    for k=1:5
        brightStd = std(double(bright));
        darkStd = std(double(dark));
        m=(brightStd*data.bright+darkStd*data.dark)/(darkStd+brightStd);
        data.boolIm = data.gray>m;
        bright = data.gray(data.boolIm);
        dark = data.gray(~data.boolIm);
        data.bright=mean(bright,'all');
        data.dark=mean(dark,'all'); 
    end
%     tmp = 128;
%     while (threshold-tmp)^2>1e-1
% %     for k=1:8
%         data.bright=mean(data.gray(data.boolIm), 'all');
%         data.dark=mean(data.gray(~data.boolIm), 'all');
%         tmp = threshold;
%         threshold = mean([data.bright, data.dark], 'all');
%         data.boolIm = data.gray>threshold;
%     end
    data.boolSum = mean((2 * data.boolIm) - 1, 'all');
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