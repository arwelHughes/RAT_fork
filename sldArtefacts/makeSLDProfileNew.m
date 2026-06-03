
function SLD = makeSLDProfileNew(bulkIn,bulkOut,layers,subRough,nRepeats)

% Make a z range for the profile...
z = 1:250;

% Scale the SLDs...
layers(:,2) = layers(:,2) * 1e6;
bulkIn = bulkIn * 1e6;
bulkOut = bulkOut * 1e6;

% Arrange the roughnes' in the layers to reflect the 'next roughness'
% loop...
allRoughs = layers(:,3);
lastRough = allRoughs(end);
allRoughs = [subRough ; allRoughs(1:end-1)];
outLayer  = [0 bulkOut lastRough];
layers(:,3) = allRoughs(:);
layers = [layers; outLayer];

nLayers = size(layers,1);
allFuncs = zeros(length(z),nLayers);
alpha = zeros(1,nLayers);

lastLayerSLD = bulkIn;
thisPos = 50;

for i = 1:nLayers
    nextRough = layers(i,3);
    nextLayerSLD = layers(i,2);
    diff = nextLayerSLD - lastLayerSLD;

    thisFun = normcdf(z,thisPos,nextRough);
    if diff < 1
        thisFun = -thisFun;
    end

    allFuncs(:,i) = thisFun(:);
    alpha(i) = abs(diff);
    thisPos = layers(i,1) + thisPos;
    lastLayerSLD = nextLayerSLD;
end

allFuncs = allFuncs .* alpha;
total = sum(allFuncs,2); 
total = (total + bulkIn) * 1e-6;

SLD = [z(:) total(:)];

end