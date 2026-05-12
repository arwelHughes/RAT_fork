% THIS FILE IS GENERATED FROM RAT VIA THE "WRITESCRIPT" ROUTINE. IT IS NOT PART OF THE RAT CODE.

project = createProject(name='original_dspc_bilayer', calcType='normal', model='standard layers', geometry='substrate/liquid', absorption=false);

project.showPriors = true;

project.setParameter(1, 'min', 1, 'value', 6.611145189599, 'max', 10, 'fit', true, 'priorType', 'uniform', 'mu', 0, 'sigma', Inf);

paramGroup = {
              {'Oxide thick', 20, 20, 20, false, 'uniform', 0, Inf};
              {'Oxide SLD', 3.39e-06, 3.39e-06, 3.41e-06, false, 'uniform', 0, Inf};
              {'Sam tails thick', 15, 20.4093517496297, 35, true, 'uniform', 0, Inf};
              {'Sam tails SLD', -5e-07, -4.01e-07, -3e-07, false, 'uniform', 0, Inf};
              {'Sam tails hydration', 1, 6.66324483179842, 50, true, 'uniform', 0, Inf};
              {'Sam rough', 1, 4.0741349271584, 15, true, 'uniform', 0, Inf};
              {'cw thick', 10, 18.3162253657927, 28, true, 'uniform', 0, Inf};
              {'cw SLD', 0, 0, 1e-09, false, 'uniform', 0, Inf};
              {'SAM head thick', 5, 10.6456448492931, 17, true, 'gaussian', 10, 2};
              {'SAM head SLD', 1e-07, 1.75e-06, 2e-06, false, 'uniform', 0, Inf};
              {'SAM head hydration', 10, 24.5467923188016, 50, true, 'uniform', 0, Inf};
              {'Bilayer head thick', 7, 11.4433343313129, 17, true, 'gaussian', 10, 2};
              {'Bilayer head SLD', 5e-07, 1.47e-06, 1.5e-06, false, 'uniform', 0, Inf};
              {'Bilayer rough', 2, 5.50702823336829, 15, true, 'uniform', 0, Inf};
              {'Bilayer tails thick', 14, 16.6366202070708, 22, true, 'uniform', 0, Inf};
              {'Bilayer tails SLD', -5e-07, -4.61e-07, 0, false, 'uniform', 0, Inf};
              {'Bilayer tails hydr', 10, 18.0888137198895, 50, true, 'uniform', 0, Inf};
              {'Bilayer heads hydr', 10, 29.732151925312, 50, true, 'gaussian', 30, 3};
              {'cw hydration', 99.9, 100, 100, false, 'uniform', 0, Inf};
              {'Oxide Hydration', 0, 28.129553816926, 60, true, 'uniform', 0, Inf};
              };

project.addParameterGroup(paramGroup);

project.removeBulkIn(1);
project.addBulkIn('Silicon', 2e-06, 2.073e-06, 2.1e-06, false, 'uniform', 0, Inf);

project.removeBulkOut(1);
project.addBulkOut('D2O', 5.5e-06, 6.02171929162727e-06, 6.4e-06, true, 'uniform', 0, Inf);
project.addBulkOut('SMW', 1e-06, 1.61974536577071e-06, 4.99e-06, true, 'uniform', 0, Inf);

project.removeScalefactor(1);
project.addScalefactor('Scalefactor 1', 0.05, 0.1, 0.2, false, 'uniform', 0, Inf);
project.addScalefactor('Scalefactor 2', 0.05, 0.15, 0.2, false, 'uniform', 0, Inf);

project.removeBackgroundParam(1);
project.addBackgroundParam('Backs parameter D2O', 5e-10, 2.43109715986864e-06, 7e-06, true, 'uniform', 0, Inf);
project.addBackgroundParam('Backs parameter SMW', 1e-10, 2.15333635087448e-06, 4.99e-06, true, 'uniform', 0, Inf);

project.removeResolutionParam(1);
project.addResolutionParam('Resolution par 1', 0.01, 0.03, 0.05, false, 'uniform', 0, Inf);

project.removeData(1);
project.addData('Simulation');
project.setData(1, 'simRange', [0.005 0.7]);

data_2 = readmatrix('data_2.dat');
project.addData('dspc_bil_d2O', data_2);
project.setData(2, 'dataRange', [0.011403 0.59342]);
project.setData(2, 'simRange', [0.011403 0.59342]);

data_3 = readmatrix('data_3.dat');
project.addData('dspc_bil_smw', data_3);
project.setData(3, 'dataRange', [0.011403 0.59342]);
project.setData(3, 'simRange', [0.011403 0.59342]);

project.removeBackground(1);
project.removeResolution(1);

project.addLayer('Oxide', 'Oxide thick', 'Oxide SLD', 'Substrate Roughness', 'Oxide Hydration', 'bulk out');
project.addLayer('Sam tails', 'Sam tails thick', 'Sam tails SLD', 'Sam rough', 'Sam tails hydration', 'bulk out');
project.addLayer('Sam heads', 'SAM head thick', 'SAM head SLD', 'Sam rough', 'SAM head hydration', 'bulk out');
project.addLayer('Central water', 'cw thick', 'cw SLD', 'Bilayer rough', 'cw hydration', 'bulk out');
project.addLayer('Bilayer heads', 'Bilayer head thick', 'Bilayer head SLD', 'Bilayer rough', 'Bilayer heads hydr', 'bulk out');
project.addLayer('Bilayer tails', 'Bilayer tails thick', 'Bilayer tails SLD', 'Bilayer rough', 'Bilayer tails hydr', 'bulk out');

project.addBackground('D2O Background', 'constant', 'Backs parameter D2O', '', '', '', '', '');
project.addBackground('SMW Background', 'constant', 'Backs parameter SMW', '', '', '', '', '');

project.addResolution('Resolution 1', 'constant', 'Resolution par 1', '', '', '', '', '');

project.addContrast('background', 'D2O Background', 'backgroundAction', 'add', 'bulkIn', 'Silicon', 'bulkOut', 'D2O', 'data', 'dspc_bil_d2O', 'name', 'D2O', 'resolution', 'Resolution 1', 'scalefactor', 'Scalefactor 1');
project.setContrast(1, 'resample', false);
project.setContrast(1, 'repeatLayers', 1);
project.setContrast(1, 'model', {'Oxide' 'Sam tails' 'Sam heads' 'Central water' 'Bilayer heads' 'Bilayer tails' 'Bilayer tails' 'Bilayer heads'});

project.addContrast('background', 'SMW Background', 'backgroundAction', 'add', 'bulkIn', 'Silicon', 'bulkOut', 'SMW', 'data', 'dspc_bil_smw', 'name', 'SMW', 'resolution', 'Resolution 1', 'scalefactor', 'Scalefactor 2');
project.setContrast(2, 'resample', false);
project.setContrast(2, 'repeatLayers', 1);
project.setContrast(2, 'model', {'Oxide' 'Sam tails' 'Sam heads' 'Central water' 'Bilayer heads' 'Bilayer tails' 'Bilayer tails' 'Bilayer heads'});


