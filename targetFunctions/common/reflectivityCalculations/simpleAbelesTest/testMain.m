
q = linspace(0.001,0.4,1000);
q = q(:);

sld = [200 4e-6 3
       100 1e-6 3];
nbair = 2.073e-6;
nbsub = 6.35e-6;
nrepeats = 1;
rsub = 4;
layers = 2;
points = length(q);

out = abelesSingle(q,sld,nbair,nbsub,nrepeats,rsub,layers,points);