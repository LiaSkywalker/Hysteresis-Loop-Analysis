function myPlot(images, i1,i2, fsize, format)
%MYPLOT Summary of this function goes here
%   Detailed explanation goes here
    figure(1000);
    set(gcf, "position", [40,100, 1100, 750]);

    initV = [images(1:i1).volt];
    decreaseV = [images(i1:i2).volt];
    increaseV = [images(i2:end).volt];

    initBl = [images(1:i1).boolSum];
    decreaseBl = [images(i1:i2).boolSum];
    increaseBl = [images(i2:end).boolSum];

    plot(initV, initBl, format, decreaseV, decreaseBl, format, increaseV, increaseBl, format,  'LineWidth',2, 'markersize',20);

    xlabel("$ \propto H $", 'interpreter', 'latex');
    ylabel("$ \propto M $", 'interpreter', 'latex');
    set(gca,'fontsize',fsize);
    legend(["initial curve", "voltage decrease", "voltage increase"],  'Location', 'Best');
    
    figure(1001);
    set(gcf, "position", [800,100, 1100, 750]);

    initBl = [images(1:i1).wall_length];
    decreaseBl = [images(i1:i2).wall_length];
    increaseBl = [images(i2:end).wall_length];

    plot(initV, initBl, format, decreaseV, decreaseBl, format, increaseV, increaseBl, format,  'LineWidth',2, 'markersize',20);

    xlabel("$ V \left[ volt \right] \propto H $", 'interpreter', 'latex');
    ylabel("$ \propto $ Domains Perimeter", 'interpreter', 'latex');
    set(gca,'fontsize',fsize);
    legend(["initial curve", "voltage decrease", "voltage increase"],  'Location', 'Best');
    
end

