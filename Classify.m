function possibilities = Classify(likelihood,thresholds)

% compute the possibility value of each model
% (mapping of the likelihoods from [0..threshold(i)] to [1..0]
numModels = length(thresholds);
for i=1:1:numModels
    possibilities(i) = 1 - likelihood(i)/thresholds(i);
    if (possibilities(i) < 0)
        possibilities(i) = 0;
    end
end