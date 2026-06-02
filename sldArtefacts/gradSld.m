%% Stack version

z = 0:200;
bulkIn = 2;
bulkOut = 6.3;
subRough = 3.5;

layers = [20,  3.4,  3;
          20,  -0.5, 6;
          20,   6,   3;
          20,  -0.5, 3;
          15,   4,   3];

% Arrange the roughnes' in the solid/liquid way....
allRoughs = layers(:,3);
allRoughs = [subRough ; allRoughs(1:end-1)];
outLayer  = [0 bulkOut allRoughs(end)];
layers(:,3) = allRoughs(:);
stack = [layers; outLayer];

nLayers = size(stack,1);
allFuncs = zeros(length(z),nLayers);
alpha = zeros(nLayers,1);

lastLayer = bulkIn;
thisPos = 30;

for i = 1:nLayers
    
    thisRough = stack(i,3);
    nextLayer = stack(i,2);
    diff = nextLayer - lastLayer;

    thisFun = normcdf(z,thisPos,thisRough);
    if diff < 1
        thisFun = -thisFun + 1;
    end

    allFuncs(:,i) = thisFun(:);
    alpha(i) = abs(diff);
    thisPos = stack(i,1) + thisPos;
    lastLayer = nextLayer;
end

allFuncs = allFuncs .* alpha';
total = sum(allFuncs,2); %/sum(alpha);

% Find the correction....
actualSldSub = total(1);
difference = actualSldSub - bulkIn;
total = total - difference;
total = total * 1e-6;

figure(3); clf
plot(z,total);