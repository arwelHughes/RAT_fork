


%


layers = [100 2 0 3
          200 4 0.01 3
          100 2 0 3];

thick = layers(:,1);
sld_re = layers(:,2);
sld_im = layers(:,3);
rough = layers(:,4);

sldSub = [6.35e-6, 0];
sldSuper = 0;
bck = 1e-7;
scale = 1;
nLayers = size(layers,1);

sub_rough = 3;

q = linspace(0.01,0.3,500); % Does iw want this in k??
k  = q ./ 2;

ref = refCalc(q,thick,sld_re,sld_im,sldSub,sldSuper,rough,sub_rough,bck,scale,nLayers);

figure(1); clf
semilogy(q,ref);
