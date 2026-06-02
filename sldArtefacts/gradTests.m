
results = jsonToResults('results.json');

sld = results.sldProfiles{1};
layers = results.layers{1};
bulkIn = results.contrastParams.bulkIn(1);
bulkOut = results.contrastParams.bulkOut(1);

figure(1); clf
subplot(2,1,1);
plot(sld(:,1),sld(:,2));

z = sld(:,1);
sldy = sld(:,1);


% Try to make the interface just from error functions...
subplot(2,1,2); hold on
currLaySLD = bulkIn;
profile = zeros(length(z),1);
i = 1;
intPos = 50;      % position of first interface

for i = 1:size(layers,1)
    nextLaySLD = layers(i,2);
    thisRough = layers(i,3);
    scale = (nextLaySLD - currLaySLD);
    interface = normcdf(z,intPos,thisRough);
    interface = (interface * scale) + currLaySLD;
    currLaySLD = nextLaySLD;
    allProfiles(:,i) = profile;
    intPos = intPos + layers(i,1);
    plot(z,interface);
end

totalInt = sum(allProfiles,2);

subplot(2,1,1); hold on
plot(z,totalInt);



%%
clear

z = 1:250;

alpha1 = 1;
alpha2 = 3;
alpha3 = 5;
alpha4 = 5;
alpha5 = 5;

p1 = normcdf(z,20,3); 
p2 = (-normcdf(z,40,3) + 1); 
p3 = normcdf(z,60,3);
p4 = (-normcdf(z,80,3) + 1);
p5 = normcdf(z,100,5);

prof = (alpha1*p1 + alpha2*p2 + alpha3*p3 + alpha4*p4 + alpha5*p5)/(alpha1 + alpha2 + alpha3 + alpha4 + alpha5);


figure(2); clf
subplot(2,1,1);
plot(z,p1);
hold on
plot(z,p2);

subplot(2,1,2)
plot(z,prof);

%function 

%% Stack version

z = 0:200;
bulkIn = 2;
bulkOut = 6.3;
subRough = 3;

layers = [20,  3.4,  3;
          20,  -0.5, 3;
          20,   6,   3;
          20,  -0.5, 3;
          20,   4,   3];

allRoughs = layers(:,3);
allRoughs = [subRough ; allRoughs(1:end-1)];
outLayer  = [0 bulkOut allRoughs(end)];
stack = [layers; outLayer];

nLayers = size(stack,1);
allFuncs = zeros(length(z),nLayers);

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

allFuncs = allFuncs .* alpha;
total = sum(allFuncs,2); %/sum(alpha);

% Find the correction....
actualSldSub = total(1);
difference = actualSldSub - bulkIn;
total = total - difference;

figure(3); clf
plot(z,total);