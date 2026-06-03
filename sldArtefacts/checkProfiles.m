

clear

z = 0:200;
bulkIn = 2.073e-6;
bulkOut = 6.3e-6;
subRough = 8;

layers = [20,  3.4,  4;
          20,  -0.5, 3;
          20,   6,   3;
          20,  -0.5, 3;
          15,   4,   3];
layers(:,2) = layers(:,2) * 1e-6;

%layers = [];

oldSLD = makeSLDProfile(bulkIn,bulkOut,layers,subRough,1);
newSLD = makeSLDProfileNew(bulkIn,bulkOut,layers,subRough,1);

figure(3); clf
plot(oldSLD(:,1),oldSLD(:,2));
hold on
plot(newSLD(:,1),newSLD(:,2));
legend({'old','new'});