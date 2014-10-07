function ValidateC()

%----------------------------- POSSIBILITIES -----------------------------%
% READ THE ACCELEROMETER DATA FILES
folder = 'Results\';
files = dir([folder,'*.txt']);
numFiles = length(files);
dataFiles = zeros(1,numFiles);
for i=1:1:numFiles
    dataFiles(i) = fopen([folder files(i).name],'r');
    Cpossibilities = fscanf(dataFiles(i),'%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n',[8,inf]);
    Cpossibilities = Cpossibilities';
    % plot the possibilities curves for the models
    % Cpossibilities = cat(1, Cpossibilities, zeros(349,8));
    x = 1:1:size(Cpossibilities,1);
    figure,
        plot(x,Cpossibilities(:,1), 'r');
        hold on;
        plot(x,Cpossibilities(:,2), 'g');
        hold on;
        plot(x,Cpossibilities(:,3), 'b');
        hold on;
        plot(x,Cpossibilities(:,4), 'm');
        hold on;
        plot(x,Cpossibilities(:,5), 'y');
        hold on;
        plot(x,Cpossibilities(:,6), 'c');
        hold on;
        plot(x,Cpossibilities(:,7), 'k');
        hold on;
        plot(x,Cpossibilities(:,8), '--r');
        hold on;
%         % for long_test only: ground truth reference
%         plot(1:1:405,ones(405), 'r','LineWidth',2);
%         hold on;
%         plot(406:1:810,ones(810-405), 'c','LineWidth',2);
%         hold on;
%         plot(811:1:1614,ones(1614-810), 'y','LineWidth',2);
%         hold on;
%         plot(1615:1:2176,ones(2176-1614), 'g','LineWidth',2);
%         hold on;
%         plot(2177:1:2580,ones(2580-2176), 'k','LineWidth',2);
%         hold on;
%         plot(2581:1:3717,ones(3717-2580), '--r','LineWidth',2);
%         hold on;

        % for stand_takePC_etc only: ground truth reference
        plot(70:1:100,ones(100-69),'k','LineWidth',3);
        hold on;
        plot(160:1:260,ones(260-159),'sc');
        hold on;
        plot(260:1:360,ones(360-259),'--r','LineWidth',3);
        hold on;
        plot(400:1:540,ones(540-399),'sg');
        hold on;
        plot(620:1:820,ones(820-619),'--r','LineWidth',3);
        hold on;
        plot(980:1:1010,ones(1010-979),'c','LineWidth',3);
        hold on;
        plot(1160:1:1325,ones(1325-1159),'y','LineWidth',3);
        hold on;
        plot(1540:1:1720,ones(1720-1539),'y','LineWidth',3);
        hold on;
        plot(1940:1:1965,ones(1965-1939),'k','LineWidth',3);
        hold on;
        plot(2030:1:2110,ones(2110-2029),'sc');
        hold on;
        plot(2125:1:2350,ones(2350-2124),'--r','LineWidth',3);
        hold on;
        plot(2580:1:2750,ones(2750-2579),'--r','LineWidth',3);
        hold on;
        plot(2770:1:2880,ones(2880-2769),'sb');
        hold on;
        plot(2965:1:2995,ones(2995-2964),'c','LineWidth',3);
        hold on;

        h = legend('climb','drink','eat','get up','pour','sit','stand','walk',8);
        set(h,'Interpreter','none');
        axis tight;
end

% %--------------------------------- TIMES ---------------------------------%
% % READ THE ACCELEROMETER DATA FILES
% files = dir([folder,'*.txt']);
% numFiles = length(files);
% dataFiles = zeros(1,numFiles);
% Ctimes = 0;
% for i=1:1:numFiles
%     dataFiles(i) = fopen([folder files(i).name],'r');
%     thisC = fscanf(dataFiles(i),'%d\n',[1,inf]);
%     Ctimes = cat(2, Ctimes, thisC);
%     % plot the execution times for the models
%     figure,
%         plot(thisC);
% end
% % plot the whole set of execution times
% figure,
%     plot(Ctimes(2:1:end));