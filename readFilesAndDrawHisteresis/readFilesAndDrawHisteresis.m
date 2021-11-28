%% This code plotting the Hysteresis Loop
%put this script in the same direcory of the data.

%% clear workspace
clc
close all

%% import data of measurements
OuterStruct = struct;

%% iterate over all the files, and import B,H that measured. add them to struct

for m=1:5
    files=dir("material_" + m + "*.csv");
    clear currentStruct
    for k=1:length(files) %repeat for every file
        [times, ch1, ch2] = importfile(files(k).name); %import data to tuple vector
        Resistance = string(files(k).name(14:end-4));
        Material =str2double(files(k).name(10));
%         
%             Rmlist = isnan(times); %get rid of NaN in data!
%             T(Rmlist) = [];
%             Y(Rmlist) = [];
%             Y=Y+abs(min(Y));
%             localmax=findpeaks(Y,'MinPeakProminence',0.1);
%             ch1(Rmlist) = [];
%             ch2(Rmlist) = [];
            ch1=smooth(smooth(ch1));
            ch2=smooth(smooth(ch2));
            [~, maxIdx] = max(ch1);
            
%     update the outer struct with the new data
        currentStruct(k) = struct('ch1',ch1, 'Times',times,'ch2',ch2,'fileName',files(k).name, 'Resistance', Resistance,'Material',Material, 'ch1point', ch1(maxIdx), 'ch2point', ch2(maxIdx));
    end
    OuterStruct(m).data = currentStruct;
end

%% print graphs

for m=1:5
    figure(m);
    set(gca,'fontsize',12);
    hold on;
    title("Material "+m);
    xlabel("$ \propto H \left[V\right] $", 'interpreter','latex');
    ylabel("$ \propto B \left[V\right] $", 'interpreter','latex');
    for k=1:length(OuterStruct(m).data)
        OuterStruct(m).data(k).p = plot(OuterStruct(m).data(k).ch1,OuterStruct(m).data(k).ch2,'markersize',12);
    end
    p = plot([OuterStruct(m).data.ch1point], [OuterStruct(m).data.ch2point], 'k');
    legend([OuterStruct(m).data.p, p], [OuterStruct(m).data.Resistance, "edge line"], 'Location', 'Best')
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