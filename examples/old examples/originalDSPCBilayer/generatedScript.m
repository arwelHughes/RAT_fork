% THIS FILE IS GENERATED FROM RAT VIA THE "WRITESCRIPT" ROUTINE. IT IS NOT PART OF THE RAT CODE.

problem = project(name='original_dspc_bilayer', calcType='non polarised', model='standard layers', geometry='substrate/liquid', absorption=false);


paramGroup = {
              {'sub rough', 2, 6.2306477711912, 8, true, 'uniform', 0, Inf};
              {'Oxide thick', 5, 19.5400728529688, 60, true, 'uniform', 0, Inf};
              {'Oxide SLD', 3.39e-06, 3.39317612702561e-06, 3.41e-06, false, 'uniform', 0, Inf};
              {'Sam tails thick', 15, 22.6655095887172, 35, true, 'uniform', 0, Inf};
              {'Sam tails SLD', -5e-07, -4.01001212540204e-07, -3e-07, false, 'uniform', 0, Inf};
              {'Sam tails hydration', 1, 5.25317617543829, 50, true, 'uniform', 0, Inf};
              {'Sam rough', 1, 5.64087210224813, 15, true, 'uniform', 0, Inf};
              {'cw thick', 10, 17.126491405717, 28, true, 'uniform', 0, Inf};
              {'cw SLD', 0, 0, 1e-09, false, 'uniform', 0, Inf};
              {'SAM head thick', 5, 8.56837898206686, 17, true, 'uniform', 0, Inf};
              {'SAM head SLD', 1e-07, 1.75686012656988e-06, 2e-06, false, 'uniform', 0, Inf};
              {'SAM head hydration', 10, 45.4595465342009, 50, true, 'uniform', 0, Inf};
              {'Bilayer head thick', 7, 10.7078475525857, 17, true, 'uniform', 0, Inf};
              {'Bilayer head SLD', 5e-07, 1.47e-06, 1.5e-06, false, 'uniform', 0, Inf};
              {'Bilayer rough', 2, 6.01426558950656, 15, true, 'uniform', 0, Inf};
              {'Bilayer tails thick', 14, 17.827471591544, 22, true, 'uniform', 0, Inf};
              {'Bilayer tails SLD', -5e-07, -4.61089672942576e-07, 0, false, 'uniform', 0, Inf};
              {'Bilayer tails hydr', 10, 17.6464949637923, 50, true, 'uniform', 0, Inf};
              {'Bilayer heads hydr', 10, 36.1575926943429, 50, true, 'uniform', 0, Inf};
              {'cw hydration', 99.9, 100, 100, false, 'uniform', 0, Inf};
              {'Oxide Hydration', 0, 23.6176286730327, 60, true, 'uniform', 0, Inf};
              };

problem.addParameterGroup(paramGroup);

problem.removeBulkIn(1);
problem.addBulkIn('Air', 2e-06, 2.07399989449186e-06, 2.1e-06, false, 'uniform', 0, Inf);

problem.removeBulkOut(1);
problem.addBulkOut('D2O', 5.50000004295725e-06, 5.98067802097389e-06, 6.4e-06, false, 'uniform', 0, Inf);
problem.addBulkOut('SMW', 2e-06, 2.21e-06, 4.99999987368938e-06, false, 'uniform', 0, Inf);

problem.removeScalefactor(1);
problem.addScalefactor('Scalefactor 1', 0.05, 0.102860901766649, 0.2, false, 'uniform', 0, Inf);
problem.addScalefactor('Scalefactor 2', 0.05, 0.151378164199993, 0.2, false, 'uniform', 0, Inf);

problem.removeQzshift(1);
problem.addQzshift('Qz shift 1', -0.0001, 0, 0.0001, false, 'uniform', 0, Inf);

problem.removeBacksPar(1);
problem.addBacksPar('Backs parameter 1', 5e-10, 2.23352626930228e-06, 7e-06, true, 'uniform', 0, Inf);
problem.addBacksPar('Backs parameter 2', 1e-10, 3.38919667572208e-06, 4.99999987368938e-06, true, 'uniform', 0, Inf);

problem.removeResolPar(1);
problem.addResolPar('Resolution par 1', 0.01, 0.03, 0.05, false, 'uniform', 0, Inf);

problem.removeBackground(1);
problem.removeResolution(1);

problem.addLayer('Oxide', 'Oxide thick', 'Oxide SLD', 'sub rough', 'Oxide Hydration', 'bulk out');
problem.addLayer('Sam tails', 'Sam tails thick', 'Sam tails SLD', 'Sam rough', 'Sam tails hydration', 'bulk out');
problem.addLayer('Sam heads', 'SAM head thick', 'SAM head SLD', 'Sam rough', 'SAM head hydration', 'bulk out');
problem.addLayer('Central water', 'cw thick', 'cw SLD', 'Bilayer rough', 'cw hydration', 'bulk out');
problem.addLayer('Bilayer heads', 'Bilayer head thick', 'Bilayer head SLD', 'Bilayer rough', 'Bilayer heads hydr', 'bulk out');
problem.addLayer('Bilayer tails', 'Bilayer tails thick', 'Bilayer tails SLD', 'Bilayer rough', 'Bilayer tails hydr', 'bulk out');

problem.addBackground('Background D2O', 'constant', 'Backs parameter 1', '', '', '', '');
problem.addBackground('Background 2', 'constant', 'Backs parameter 2', '', '', '', '');

problem.addResolution('Resolution 1', 'constant', 'Resolution par 1', '', '', '', '');

problem.removeData(1);
problem.addData('Simulation');
problem.setData(1, 'dataRange', [0.011403 0.59342]);
problem.setData(1, 'simRange', [0.011403 0.70956]);

data_2 = readmatrix('data_2.dat');
problem.addData('dspc_bil1', data_2);
problem.setData(2, 'dataRange', [0.011403 0.59342]);
problem.setData(2, 'simRange', [0.011403 0.70956]);

data_3 = readmatrix('data_3.dat');
problem.addData('dspcbil1_smw', data_3);
problem.setData(3, 'dataRange', [0.011403 0.59342]);
problem.setData(3, 'simRange', [0.011403 0.59342]);

problem.addContrast('background', 'Background D2O', 'data', 'dspc_bil1', 'name', 'D2O', 'nba', 'Air', 'nbs', 'D2O', 'resolution', 'Resolution 1', 'scalefactor', 'Scalefactor 1');
problem.setContrast(1, 'resample', false);
problem.setContrastModel(1, {'Oxide' 'Sam tails' 'Sam heads' 'Central water' 'Bilayer heads' 'Bilayer tails' 'Bilayer tails' 'Bilayer heads'});

problem.addContrast('background', 'Background 2', 'data', 'dspcbil1_smw', 'name', 'D2O', 'nba', 'Air', 'nbs', 'SMW', 'resolution', 'Resolution 1', 'scalefactor', 'Scalefactor 1');
problem.setContrast(2, 'resample', false);
problem.setContrastModel(2, {'Oxide' 'Sam tails' 'Sam heads' 'Central water' 'Bilayer heads' 'Bilayer tails' 'Bilayer tails' 'Bilayer heads'});

