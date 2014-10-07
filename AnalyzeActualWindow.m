function [gravity body] = AnalyzeActualWindow(window,numSamples)
% function [gravity body] = AnalyzeActualWindow(window,numSamples)
%
% AnalyzeActualWindow separates the gravity and body acceleration features
% contained in the window of real-time acceleration data, by first reducing
% the noise on the raw data with a median filter and then discriminating
% between the features with a low-pass IIR filter.
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


% REDUCE THE NOISE ON THE SIGNALS BY MEDIAN FILTERING
n = 3;      % order of the median filter
clean_window(:,:) = medfilt1(window(:,:),n);

% SEPARATE THE GRAVITY AND BODY-ACCELERATION COMPONENTS
% IIR filter parameters (all frequencies are in Hz)
Fs = 32;            % sampling frequency
Fpass = 0.25;       % passband frequency
Fstop = 2;          % stopband frequency
Apass = 0.001;      % passband ripple (dB)
Astop = 100;        % stopband attenuation (dB)
match = 'pass';     % band to match exactly
delay = 64;         % delay (# samples) introduced by filtering
% create the IIR filter
h  = fdesign.lowpass(Fpass, Fstop, Apass, Astop, Fs);
Hd = cheby1(h, 'MatchExactly', match);
% apply the filter on the acceleration signals (to isolate gravity)
g(:,1) = filter(Hd,clean_window(:,1));
g(:,2) = filter(Hd,clean_window(:,2));
g(:,3) = filter(Hd,clean_window(:,3));
% compute the body-acceleration components by subtraction
g = circshift(g,[-delay 0]);
i = 1:1:(numSamples-delay);
gravity(i,:) = g(i,:);
body(i,:) = clean_window(i,:) - gravity(i,:);

% % DISPLAY THE RESULTS
% % comparison between the noisy and clean signals
% time = 1:1:max(numSamples);
% % noisy signal
% figure,
%     subplot(3,1,1);
%     plot(time,window(:,1),'-');
%     axis([0 max(numSamples) -14.709 +14.709]);
%     title('Noisy acceleration along the x axis');
%     subplot(3,1,2);
%     plot(time,window(:,2),'-');
%     axis([0 max(numSamples) -14.709 +14.709]);
%     title('Noisy acceleration along the y axis');
%     subplot(3,1,3);
%     plot(time,window(:,3),'-');
%     axis([0 max(numSamples) -14.709 +14.709]);
%     title('Noisy acceleration along the z axis');
% % clean signal
% figure,
%     subplot(3,1,1);
%     plot(time,clean_window(:,1),'-');
%     axis([0 max(numSamples) -14.709 +14.709]);
%     title('Filtered acceleration along the x axis');
%     subplot(3,1,2);
%     plot(time,clean_window(:,2),'-');
%     axis([0 max(numSamples) -14.709 +14.709]);
%     title('Filtered acceleration along the y axis');
%     subplot(3,1,3);
%     plot(time,clean_window(:,3),'-');
%     axis([0 max(numSamples) -14.709 +14.709]);
%     title('Filtered acceleration along the z axis');
% % comparison between raw data and the gravity and body acc. components
% time = 1:1:(numSamples-delay);
% figure,
%     subplot(3,1,1);
%     plot(time,clean_window(1:numSamples-delay,1),'-r');
%     hold on;
%     plot(time,gravity(1:numSamples-delay,1),'-g');
%     hold on;
%     plot(time,body(1:numSamples-delay,1),'-b');    
%     axis([0 numSamples-delay -14.709 +14.709]);
%     title('Raw acceleration, gravity & body acc. components along the x axis');
%     subplot(3,1,2);
%     plot(time,clean_window(1:numSamples-delay,2),'-r');
%     hold on;
%     plot(time,gravity(1:numSamples-delay,2),'-g');
%     hold on;
%     plot(time,body(1:numSamples-delay,2),'-b');    
%     axis([0 numSamples-delay -14.709 +14.709]);
%     title('Raw acceleration, gravity & body acc. components along the y axis');
%     subplot(3,1,3);
%     plot(time,clean_window(1:numSamples-delay,3),'-r');
%     hold on;
%     plot(time,gravity(1:numSamples-delay,3),'-g');
%     hold on;
%     plot(time,body(1:numSamples-delay,3),'-b');    
%     axis([0 numSamples-delay -14.709 +14.709]);
%     title('Raw acceleration, gravity & body acc. components along the z axis');
% % display the gravity and body acc. components
% figure,
%     subplot(3,2,1);
%     plot(time,gravity(1:numSamples-delay,1));
%     title('Gravity');
%     subplot(3,2,3);
%     plot(time,gravity(1:numSamples-delay,2));
%     subplot(3,2,5);
%     plot(time,gravity(1:numSamples-delay,3));
%     subplot(3,2,2);
%     plot(time,body(1:numSamples-delay,1));
%     title('Body acceleration');
%     subplot(3,2,4);
%     plot(time,body(1:numSamples-delay,2));
%     subplot(3,2,6);
%     plot(time,body(1:numSamples-delay,3));