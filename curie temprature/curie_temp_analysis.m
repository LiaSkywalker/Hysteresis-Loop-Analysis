%% This code plotting the Hysteresis Loop
%put this script in the same direcory of the data.

%% clear workspace
clc
close all

%% import data of measurements

%% iterate over all the files, and import B,H that measured. add them to struct

resistance=getResistance();
printGraph(resistance);

%% print graphs
function printGraph(obj)
    for m=1:3
        f = figure(obj(m).resistance);
        set(f, "position", [(m-1)*565+40,100, 1100, 750]);
        set(gca,'fontsize',22);
        hold on;
%         title("$ Resistance\ "+obj(m).resistance+"\Omega $", 'interpreter','latex');
        xlabel("$ \propto H $", 'interpreter','latex');
        ylabel("$ \propto B $", 'interpreter','latex');
        clear p;
        cmap = colormap(cool(length(obj(m).data)));
        [~, lookup] = sort([obj(m).data.temp]);
        for k=length(obj(m).data):-3:1
            idx = lookup(k);
            plot(smooth(obj(m).data(idx).ch1,15),smooth(obj(m).data(idx).ch2,15),"lineWidth", 2, 'color', cmap(k, :));
        end
        colorbar('Ticks',[0,1],'TickLabels', "$ {" + [min([obj(m).data.temp]), max([obj(m).data.temp])]+"}^{\circ}C $","TickLabelInterpreter","latex");
%         p2 = plot(materials(m).lineH, materials(m).lineB, 'k');
%         legend(p, "$ "+[obj(m).data.temp]+" k\Omega $", 'Location', 'Best', 'interpreter','latex')
        f = figure(10*obj(m).resistance);
        set(f, "position", [(m-1)*565+150,50, 1100, 750]);
        set(gca,'fontsize',22);
        hold on;
%         title("Material "+m+" permeability ", 'interpreter','latex');
        xlabel("$ Temp \left[{}^{\circ}C\right] $", 'interpreter','latex');
        ylabel("$ \propto M $", 'interpreter','latex');
        plot([obj(m).data.temp], [obj(m).data.m], ".", 'markersize', 20);
%         plot([obj(m).data.temp], [obj(m).data.area], ".");
    end
    
end

%%
function resistance=getResistance()
    resistanceArray = [500,1500,8000];
    for m=3:-1:1 %Backwards for prealocation. (otherwise matlab will realocate data each itaration.)
        resistance(m).data = getResistancelData(resistanceArray(m));
        resistance(m).resistance = resistanceArray(m);
%         resistance(m).M = [resistance(m).data.m];
    end
end

%%


%%
function data=getResistancelData(m)
    files=dir("./" + m + "oh/*.csv");
    for k=length(files):-1:1 %repeat for every file
        data(k) = getMeasurementData(files(k));
    end
end

%%
function measure=getMeasurementData(file)
    [times, ch1, ch2] = importfile(file.folder+"/"+file.name); %import data to tuple vector
    [~,~,idxs] = regexp(file.name,"gadolinum_\d+_OH_([-+]?\d+(\.\d+)?)_C.csv");
    temp = str2double(file.name(idxs{1}(1):idxs{1}(2)));
%         
%             Rmlist = isnan(times); %get rid of NaN in data!
%             T(Rmlist) = [];
%             Y(Rmlist) = [];
%             Y=Y+abs(min(Y));
%             localmax=findpeaks(Y,'MinPeakProminence',0.1);
%             ch1(Rmlist) = [];
%             ch2(Rmlist) = [];
%     ch1=smooth(smooth(ch1));
%     ch2=smooth(smooth(ch2));
    % todo
%    [~,idx] = mink(ch1.^2, max(1,round(length(ch1)/10)));
    [~,idx] = mink(ch1.^2, 400);
    m = abs(ch2(idx));
    area = polyarea(ch1, ch2);
    measure = struct('ch1',ch1, 'Times',times,'ch2',ch2,'fileName',file.name, 'temp', temp, 'm', mean(m), "dm", std(m), "area", area);
end


%% defult import data functions
function [times, ch1, ch2] = importfile(filename, dataLines)
%IMPORTFILE Import data from a text file
%  [TIMES, CH1, CH2] = IMPORTFILE(FILENAME) reads data from text file
%  FILENAME for the default selection.  Returns the data as column
%  vectors.
%
%  [TIMES, CH1, CH2] = IMPORTFILE(FILE, DATALINES) reads data for the
%  specified row interval(s) of text file FILENAME. Specify DATALINES as
%  a positive scalar integer or a N-by-2 array of positive scalar
%  integers for dis-contiguous row intervals.
%
%  Example:
%  [times, ch1, ch2] = importfile("C:\Users\zrobb\Documents\�������\������\����� �\�������\���� 1\material_1_R_0k.csv", [1, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 18-Nov-2021 01:30:12

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [1, Inf];
end

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 11);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Var1", "Var2", "Var3", "times", "ch1", "Var6", "Var7", "Var8", "Var9", "Var10", "ch2"];
opts.SelectedVariableNames = ["times", "ch1", "ch2"];
opts.VariableTypes = ["string", "string", "string", "double", "double", "string", "string", "string", "string", "string", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var6", "Var7", "Var8", "Var9", "Var10"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var6", "Var7", "Var8", "Var9", "Var10"], "EmptyFieldRule", "auto");

% Import the data
tbl = readtable(filename, opts);

%% Convert to output type
times = tbl.times;
ch1 = tbl.ch1;
ch2 = tbl.ch2;
end