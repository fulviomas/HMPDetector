% -------------------------------------------------------------------------
% Author: Barbara Bruno (dept. DIBRIS, University of Genova, ITALY)
%
% This code is the implementation of the algorithms described in the
% paper "Human motion modeling and recognition: a computational approach".
%
% I would be grateful if you refer to the paper in any academic
% publication that uses this code or part of it.
% Here is the BibTeX reference:
% @inproceedings{Bruno12,
% author = "B. Bruno and F. Mastrogiovanni and A. Sgorbissa and T. Vernazza and R. Zaccaria",
% title = "Human motion modeling and recognition: a computational approach",
% booktitle = "Proceedings of the 8th {IEEE} International Conference on Automation Science and Engineering ({CASE} 2012)",
% address = "Seoul, Korea",
% year = "2012",
% month = "August"
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
% BuildHMPDataset creates the models (with the Gaussian Mixture Modelling
% and Regression procedure) of the HMP of HMP_Dataset, each represented by
% a set of modelling trials stored in a specific folder. The module calls
% the fuction GenerateModel for each motion passing it the appropriate
% modelling folder. In addition, the function computes the model-specific
% threshold to be later used by the Classifier to discriminate between
% known and unknown motions.

% CREATE THE MODELS AND ASSOCIATED THRESHOLDS
scale = 1.5;  % experimentally set scaling factor for the threshold computation

% climb_stairs
disp('Building CLIMB_STAIRS model...');
folder = 'Data folder\MODELS\Climb_stairs_MODEL\';
[CLIMB_STAIRSgP CLIMB_STAIRSgS CLIMB_STAIRSbP CLIMB_STAIRSbS] = GenerateModel(folder);
CLIMB_STAIRS_threshold = ComputeThreshold(CLIMB_STAIRSgP,CLIMB_STAIRSgS,CLIMB_STAIRSbP,CLIMB_STAIRSbS,scale);

% drink_glass
disp('Building DRINK_GLASS model...');
folder = 'Data folder\MODELS\Drink_glass_MODEL\';
[DRINK_GLASSgP DRINK_GLASSgS DRINK_GLASSbP DRINK_GLASSbS] = GenerateModel(folder);
DRINK_GLASS_threshold = ComputeThreshold(DRINK_GLASSgP,DRINK_GLASSgS,DRINK_GLASSbP,DRINK_GLASSbS,scale);

% getup_bed
disp('Building GETUP_BED model...');
folder = 'Data folder\MODELS\Getup_bed_MODEL\';
[GETUP_BEDgP GETUP_BEDgS GETUP_BEDbP GETUP_BEDbS] = GenerateModel(folder);
GETUP_BED_threshold = ComputeThreshold(GETUP_BEDgP,GETUP_BEDgS,GETUP_BEDbP,GETUP_BEDbS,scale);

% pour_water
disp('Building POUR_WATER model...');
folder = 'Data folder\MODELS\Pour_water_MODEL\';
[POUR_WATERgP POUR_WATERgS POUR_WATERbP POUR_WATERbS] = GenerateModel(folder);
POUR_WATER_threshold = ComputeThreshold(POUR_WATERgP,POUR_WATERgS,POUR_WATERbP,POUR_WATERbS,scale);

% sitdown_chair
disp('Building SITDOWN_CHAIR model...');
folder = 'Data folder\MODELS\Sitdown_chair_MODEL\';
[SITDOWN_CHAIRgP SITDOWN_CHAIRgS SITDOWN_CHAIRbP SITDOWN_CHAIRbS] = GenerateModel(folder);
SITDOWN_CHAIR_threshold = ComputeThreshold(SITDOWN_CHAIRgP,SITDOWN_CHAIRgS,SITDOWN_CHAIRbP,SITDOWN_CHAIRbS,scale);

% standup_chair
disp('Building STANDUP_CHAIR model...');
folder = 'Data folder\MODELS\Standup_chair_MODEL\';
[STANDUP_CHAIRgP STANDUP_CHAIRgS STANDUP_CHAIRbP STANDUP_CHAIRbS] = GenerateModel(folder);
STANDUP_CHAIR_threshold = ComputeThreshold(STANDUP_CHAIRgP,STANDUP_CHAIRgS,STANDUP_CHAIRbP,STANDUP_CHAIRbS,scale);

% walk
disp('Building WALK model...');
folder = 'Data folder\MODELS\Walk_MODEL\';
[WALKgP WALKgS WALKbP WALKbS] = GenerateModel(folder);
WALK_threshold = ComputeThreshold(WALKgP,WALKgS,WALKbP,WALKbS,scale);

% SAVE THE MODELS IN THE CURRENT DIRECTORY
save models_and_thresholds.mat