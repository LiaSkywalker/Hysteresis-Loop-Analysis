function myPlot(images, i1,i2, fsize, format)
%MYPLOT Summary of this function goes here
%   Detailed explanation goes here
    figure(1000);

    initV = [images(1:i1).volt];
    decreaseV = [images(i1:i2).volt];
    increaseV = [images(i2:end).volt];

    initBl = [images(1:21).boolSum];
    decreaseBl = [images(21:59).boolSum];
    increaseBl = [images(59:99).boolSum];

    plot(initV, initBl, format, decreaseV, decreaseBl, format, increaseV, increaseBl, format,  'LineWidth',3, 'markersize',20);

    xlabel("$ \propto H $", 'interpreter', 'latex');
    ylabel("$ \propto B $", 'interpreter', 'latex');
    set(gca,'fontsize',fsize);
    legend(["initial curve", "voltage decrease", "voltage increase"],  'Location', 'Best');
end

