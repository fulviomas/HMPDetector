function [window numWritten] = CreateWindow(actual_sample,window,N,numWritten)
% function [window numWritten] = CreateWindow(actual_sample,window,N,numWritten)
%
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
%
% AnalyzeActualWindow separates the gravity and body acceleration features
% contained in the window of real-time acceleration data.
%
% Input:
%   window --> set of real-time acceleration points to be considered for
%              the analysis
%   numSamples --> number of sample points measured by the accelerometer in
%                  the considered trial (or window)
%
% Output:
%   gravity --> matrix of the components of the gravity acceleration along
%               the 3 axes
%   body --> matrix of the components of the body-motion acceleration along
%            the 3 axes
%
% Example:
%   WORK-IN-PROGRESS

% CONVERT THE ACCELEROMETER DATA INTO REAL ACCELERATION VALUES
% mapping from [0..63] to [-14.709..+14.709]
noisy_sample(1) = -14.709 + (actual_sample(1)/63)*(2*14.709);
noisy_sample(2) = -14.709 + (actual_sample(2)/63)*(2*14.709);
noisy_sample(3) = -14.709 + (actual_sample(3)/63)*(2*14.709);

% COMPUTE THE ACTUAL WINDOW
if(numWritten < N)
    window(numWritten+1,:) = noisy_sample(:);
    numWritten = numWritten+1;
else
    window = circshift(window,[-1 0]);
    window(N,:) = noisy_sample;    
end