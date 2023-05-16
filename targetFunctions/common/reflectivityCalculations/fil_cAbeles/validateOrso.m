% 
% % Validations against ORSO tests...
% 
% 
% % Test 1 multilayer test....
% layers = [30.0000	-1.9493e-6	0.0000	0.0000
% 70.0000	9.4245e-6	0.0000	0.0000
% 30.0000	-1.9493e-6	0.0000	0.0000
% 70.0000	9.4245e-6	0.0000	0.0000
% 30.0000	-1.9493	0.0000	0.0000
% 70.0000	9.4245	0.0000	0.0000
% 30.0000	-1.9493	0.0000	0.0000
% 70.0000	9.4245	0.0000	0.0000
% 30.0000	-1.9493	0.0000	0.0000
% 70.0000	9.4245	0.0000	0.0000
% 30.0000	-1.9493	0.0000	0.0000
% 70.0000	9.4245	0.0000	0.0000
% 30.0000	-1.9493	0.0000	0.0000
% 70.0000	9.4245	0.0000	0.0000
% 30.0000	-1.9493	0.0000	0.0000
% 70.0000	9.4245	0.0000	0.0000
% 30.0000	-1.9493	0.0000	0.0000
% 70.0000	9.4245	0.0000	0.0000
% 30.0000	-1.9493	0.0000	0.0000
% 70.0000	9.4245	0.0000	0.0000
% 0.0000	2.0704	0.0000	0.0000];
% 
% sld = zeros(length(layers),3);
% 
% sld(:,1) = layers(:,1);
% sld(:,2) = layers(:,2) .* 1e-6; %,layers(:,3));
% sld(:,3) = layers(:,4);
% 
% bulkIn = 0;
% bulkOut = 2.0704e-6;
% 
% data = dlmread('test1Data.dat');
% q = data(:,1);
% sub_rough = 0;
% 
% ref = callAbeles_mex(q', sld, bulkIn, bulkOut, sub_rough);


%%
% test 7
layers = [
0.00e+00 0.0e+00 0.00e+00 0
1.20e+03 4.66e-6 1.60e-8 1.00e+01
0.00e+00 6.36e-6 0.00e-6 3.00e+00];

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
q = data7(:,1);

%ref = callAbeles_mex(q', layers, bulkIn, bulkOut, sub_rough);
ref = abelesReflectWrapper_mex(q,layers);

%out = abelesSingle(q,allSld,bulkIn,bulkOut,1,3,1,length(q));

figure(2); clf
semilogy(data7(:,1),data7(:,2));
hold on
semilogy(q,ref);





