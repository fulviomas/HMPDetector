function likelihood = CompareWithModels(gravity,body,MODELgP,MODELgS,MODELbP,MODELbS)

% compute the difference between the actual value and the ideal value (for
% each acceleration component) using Mahalanobis distance
numPoints = size(MODELgS,3);
gravity = gravity';
body = body';
time = MODELgP(1,:);

distance = zeros(numPoints,2);
for i=1:1:numPoints
    x = time(i);
    distance(i,1) = (transpose(gravity(:,x)-MODELgP(2:4,find(time==x))))*inv(MODELgS(:,:,find(time==x)))*(gravity(:,i)-MODELgP(2:4,find(time==x)));
    distance(i,2) = (transpose(body(:,x)-MODELbP(2:4,find(time==x))))*inv(MODELbS(:,:,find(time==x)))*(body(:,i)-MODELbP(2:4,find(time==x)));
end
% compute the likelihood of the model as the mean value of the distances
likelihood = mean(mean(distance));