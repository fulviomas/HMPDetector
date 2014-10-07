% -------------------------------------------------------------------------
% Author: Barbara Bruno (dept. DIBRIS, University of Genova, ITALY)
%
% This code is the implementation of the algorithms described in the
% paper "Analysis of human behavior recognition algorithms based on
% acceleration data".
%
% I would be grateful if you refer to the paper in any academic
% publication that uses this code or part of it.
% Here is the BibTeX reference:
% @inproceedings{Bruno13,
% author = "B. Bruno and F. Mastrogiovanni and A. Sgorbissa and T. Vernazza and R. Zaccaria",
% title = "Analysis of human behavior recognition algorithms based on acceleration data",
% booktitle = "Proceedings of the IEEE International Conference on Robotics and Automation (ICRA 2013)",
% address = "Karlsruhe, Germany",
% month = "May",
% year = "2013"
% }
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% This function is associated to the public dataset HMPdataset.
% (free download at: https://github.com/fulviomas/HOOD)
% The HMPdataset and its rationale are described in the paper "A Public
% Domain Dataset for ADL Recognition Using Wrist-placed Accelerometers".
%
% I would be grateful if you refer to the paper in any academic
% publication that uses this code or the HMPdataset.
% Here is the BibTeX reference:
% @inproceedings{Bruno14c,
% author = "B. Bruno and F. Mastrogiovanni and A. Sgorbissa",
% title = "A Public Domain Dataset for {ADL} Recognition Using Wrist-placed Accelerometers",
% booktitle = "Proceedings of the 23rd {IEEE} International Symposium on Robot and Human Interactive Communication ({RO-MAN} 2014)",
% address = "Edinburgh, UK",
% month = "August",
% year = "2014"
% }
% -------------------------------------------------------------------------
%
% ValidateHMPDataset allows to test the models built by the function
% BuildHMPDataset with the validation trials associated to the same
% dataset. It feeds the Classifier with the samples recorded in one
% validation trial one-by-one, waiting for the completion of the previous
% classification before feeding the Classifier_Module with a new sample.

% LOAD THE MODELS OF THE HMP IN HMPDATASET
% (models of the known activities and classification thresholds)
load models_and_thresholds.mat

% DEFINE THE VALIDATION FOLDER TO BE USED
folder = 'Data folder\VALIDATION\';

% COMPUTE THE SIZE OF THE SLIDING WINDOW
% (size of the largest model + 64 samples)
models_size(1) = size(CLIMB_STAIRSbP,2);
models_size(2) = size(DRINK_GLASSbP,2);
models_size(3) = size(GETUP_BEDbP,2);
models_size(4) = size(POUR_WATERbP,2);
models_size(5) = size(SITDOWN_CHAIRbP,2);
models_size(6) = size(STANDUP_CHAIRbP,2);
models_size(7) = size(WALKbP,2);
% compute the required window size
window_size = max(models_size);

% ANALYZE THE VALIDATION TRIALS ONE BY ONE, SAMPLE BY SAMPLE
thresholds(1) = CLIMB_STAIRS_threshold;
thresholds(2) = DRINK_GLASS_threshold;
thresholds(3) = EAT_MEAT_threshold;
thresholds(4) = GETUP_BED_threshold;
thresholds(5) = POUR_WATER_threshold;
thresholds(6) = SITDOWN_CHAIR_threshold;
thresholds(7) = STANDUP_CHAIR_threshold;
thresholds(8) = WALK_threshold;
files = dir([folder,'*.txt']);
numFiles = length(files);
for i=1:1:numFiles
    % transform the trial into a stream of samples
    currentFile = fopen([folder files(i).name],'r');
    currentData = fscanf(currentFile,'%d\t%d\t%d\n',[3,inf]);
    numSamples = length(currentData(1,:));
    % initialize the window of data to be used by the classifier
    window = zeros(window_size,3);
    numWritten = 0;
    for j=1:1:numSamples
        current_sample = currentData(:,j);
        % update the sliding window with the current sample
        [window numWritten] = CreateWindow(current_sample,window,window_size,numWritten);
        % analysis is meaningful only when we have enough samples
        if (numWritten >= window_size)
            % compute the acceleration components of the current window of samples
            [gravity body] = AnalyzeActualWindow(window,window_size);
            % compute the difference between the actual data and each model
            like(1) = CompareWithModels(gravity(1:models_size(1),:),body(1:models_size(1),:),CLIMB_STAIRSgP,CLIMB_STAIRSgS,CLIMB_STAIRSbP,CLIMB_STAIRSbS);
            like(2) = CompareWithModels(gravity(1:models_size(2),:),body(1:models_size(2),:),DRINK_GLASSgP,DRINK_GLASSgS,DRINK_GLASSbP,DRINK_GLASSbS);
            like(3) = CompareWithModels(gravity(1:models_size(3),:),body(1:models_size(3),:),EAT_MEATgP,EAT_MEATgS,EAT_MEATbP,EAT_MEATbS);
            like(4) = CompareWithModels(gravity(1:models_size(4),:),body(1:models_size(4),:),GETUP_BEDgP,GETUP_BEDgS,GETUP_BEDbP,GETUP_BEDbS);
            like(5) = CompareWithModels(gravity(1:models_size(5),:),body(1:models_size(5),:),POUR_WATERgP,POUR_WATERgS,POUR_WATERbP,POUR_WATERbS);
            like(6) = CompareWithModels(gravity(1:models_size(6),:),body(1:models_size(6),:),SITDOWN_CHAIRgP,SITDOWN_CHAIRgS,SITDOWN_CHAIRbP,SITDOWN_CHAIRbS);
            like(7) = CompareWithModels(gravity(1:models_size(7),:),body(1:models_size(7),:),STANDUP_CHAIRgP,STANDUP_CHAIRgS,STANDUP_CHAIRbP,STANDUP_CHAIRbS);
            like(8) = CompareWithModels(gravity(1:models_size(8),:),body(1:models_size(8),:),WALKgP,WALKgS,WALKbP,WALKbS);
            % classify the current data
            possibilities(j,:) = Classify(like,thresholds);
        else
            possibilities(j,:) = zeros(1,8);
        end
%         % store the classification results in a .txt file
%         label = [num2str(possibilities(j,1)),' ',num2str(possibilities(j,2)),' ',num2str(possibilities(j,3)),' ',...
%                  num2str(possibilities(j,4)),' ',num2str(possibilities(j,5)),' ',num2str(possibilities(j,6)),' ',...
%                  num2str(possibilities(j,7)),' ',num2str(possibilities(j,8)),' ','\n'];
%         resultFile = fopen('RESULTS.txt','a');
%         fprintf(resultFile,label);
%         fclose(resultFile);
    end
    % plot the possibilities curves for the models
    x = window_size:1:numSamples;
    size(x)
    size(possibilities)
    figure,
        plot(x,possibilities(window_size:end,1), 'r');
        hold on;
        plot(x,possibilities(window_size:end,2), 'g');
        hold on;
        plot(x,possibilities(window_size:end,3), 'b');
        hold on;
        plot(x,possibilities(window_size:end,4), 'm');
        hold on;
        plot(x,possibilities(window_size:end,5), 'y');
        hold on;
        plot(x,possibilities(window_size:end,6), 'c');
        hold on;
        plot(x,possibilities(window_size:end,7), 'k');
        hold on;
        plot(x,possibilities(window_size:end,8), '--r');
        hold on;
        h = legend('climb','drink','eat','get up','pour','sit','stand','walk',8);
        set(h,'Interpreter','none')
%     % separate different trials in the result file
%     label = ['end of trial ',num2str(i),' \n'];
%     resultFile = fopen('RESULTS.txt','a');
%     fprintf(resultFile,label);
%     fclose(resultFile);
    clear possibilities;
end