

layers = [
16000 0.0e+00 0.00e+00 0
1.20e+03 4.66e-6 1.60e-8 1.00e+01
16000 6.36e-6 0.00e-6 3.00e+00];

data7 = dlmread('test7.dat');

% thick = layers(:,1);
% sld = layers(:,2:3);
% sld = sld .* 1e-6;
% sld = complex(sld(:,1),sld(:,2));
% rough = layers(:,4);

%allSld = [thick sld rough];
%allSld = allSld(2,:);

% bulkIn = 0;
% bulkOut = 6.35e-6;
% 
% sub_rough = 3;
%q = data7(:,1);

q = linspace(0.01,0.5,1000);

%ref = callAbeles_mex(q', layers, bulkIn, bulkOut, sub_rough);
layers_thick = layers(:,1);
layers_sig = layers(:,4);
layers(:,3) = layers(:,3);% + eps;
layers_rho = complex(layers(:,2),layers(:,3));

N = length(layers_thick);

%ref = abeles_reflect_matlab(q,N,layers_thick,layers_rho,layers_sig);
ref = gptWrapper(q,N,layers_thick,layers_rho,layers_sig);


%out = abelesSingle(q,allSld,bulkIn,bulkOut,1,3,1,length(q));

figure(2); clf
%semilogy(data7(:,1),data7(:,2));
hold on
semilogy(q,ref);