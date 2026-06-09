

% Test of the SLD profile calc...
bulklIn = 2.073e-6;
bulkOut = 6.35e-6;
layers = [20    4e-6        3
          20    -0.5e-6     3];

subRough = 3;
nRepeats = 12;

profile = makeSLDProfile(bulkIn,bulkOut,layers,subRough,nRepeats);

figure(1); clf
plot(profile(:,1),profile(:,2));