

% Test of abeles...
q = linspace(0.01,0.3,1000);

sld = [1200, complex(4.66e-6,1e-8), 10];
nbair = complex(0,0);
nbsub = complex(6.35e-6,0);
nrepeats = 1;
nlayers = 1;
npoints = length(q);
rsub = 3;

ref = abelesSingle(q,sld,nbair,nbsub,nrepeats,rsub,nlayers,npoints);
