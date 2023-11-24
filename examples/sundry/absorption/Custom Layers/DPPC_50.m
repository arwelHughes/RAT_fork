% THIS FILE IS GENERATED FROM RAT VIA THE "WRITESCRIPT" ROUTINE. IT IS NOT PART OF THE RAT CODE.

problem = project(name='DPPC_50_3pcBins', calcType='non polarised', model='custom layers', geometry='substrate/liquid', absorption=true);

problem.setParameterValue(1, 8.82723434108396);
problem.setParameterConstraint(1, 0.1, 20);
problem.setParameterFit(1, true);
problem.setParameterPrior(1, 'uniform', 0, Inf);

paramGroup = {
              {'Alloy Thick', 100, 135.646872258354, 200, true, 'uniform', 0, Inf};
              {'Alloy SLD UP', 6e-06, 7.05721031425174e-06, 1.2e-05, true, 'uniform', 0, Inf};
              {'Alloy Rough', 2, 5.7175348961114, 10, true, 'uniform', 0, Inf};
              {'Gold Thick', 100, 154.706604632337, 200, true, 'uniform', 0, Inf};
              {'Gold Rough', 0.1, 5.42133441164452, 10, true, 'uniform', 0, Inf};
              {'Gold SLD', 4e-06, 4.45341325373169e-06, 5e-06, true, 'uniform', 0, Inf};
              {'Thiol APM', 40, 56.2703361699801, 100, true, 'uniform', 0, Inf};
              {'Waters per Head', 1, 12.2547285593575, 30, true, 'uniform', 0, Inf};
              {'Thiol coverage', 0.5, 0.905886121706168, 1, true, 'uniform', 0, Inf};
              {'Alloy SLD Down', 6e-06, 9.84164489922082e-06, 1.3e-05, true, 'uniform', 0, Inf};
              {'CW thick', 1, 12.8742707940913, 25, true, 'uniform', 0, Inf};
              {'Bilayer APM', 48, 65.8635281372538, 90, true, 'uniform', 0, Inf};
              {'Bilayer wph', 1, 11.9043174577604, 30, true, 'uniform', 0, Inf};
              {'Bilayer rough', 1, 3.87672156218186, 10, true, 'uniform', 0, Inf};
              {'Bilayer Coverage', 0.5, 0.944749649590259, 1, true, 'uniform', 0, Inf};
              {'py_isld', 1e-09, 4.87258327184808e-08, 1e-07, true, 'uniform', 0, Inf};
              {'gold isld', 1e-09, 4.2028797477809e-08, 1e-07, true, 'uniform', 0, Inf};
              };

problem.addParameterGroup(paramGroup);

problem.removeBulkIn(1);
problem.addBulkIn('Air', 0, 2.073e-06, 0, false, 'uniform', 0, Inf);

problem.removeBulkOut(1);
problem.addBulkOut('D2O', 5.8e-06, 6.21518342672587e-06, 6.35e-06, true, 'uniform', 0, Inf);
problem.addBulkOut('GMW', 4e-06, 4.50970389623731e-06, 5e-06, false, 'uniform', 0, Inf);
problem.addBulkOut('H2O', -5.6e-07, -3.15007184902591e-07, 0, true, 'uniform', 0, Inf);

problem.removeScalefactor(1);
problem.addScalefactor('Scalefactor 1', 20, 54.3703704230377, 100, true, 'uniform', 0, Inf);
problem.addScalefactor('Scalefactor 2', 20, 31.5987348045557, 100, true, 'uniform', 0, Inf);
problem.addScalefactor('Scalefactor 3', 20, 46.8582101113387, 100, true, 'uniform', 0, Inf);
problem.addScalefactor('Scalefactor 4', 20, 39.4768324365299, 100, true, 'uniform', 0, Inf);

problem.removeQzshift(1);
problem.addQzshift('Qz shift 1', -0.0001, 0, 0.0001, false, 'uniform', 0, Inf);

problem.removeBacksPar(1);
problem.addBacksPar('Backs parameter 1', 5e-08, 7.88100030895821e-06, 9e-05, true, 'uniform', 0, Inf);
problem.addBacksPar('Backs parameter 2', 1e-08, 5.46696542136395e-06, 9e-05, true, 'uniform', 0, Inf);
problem.addBacksPar('Backs parameter 3', 1e-06, 9.01960336997122e-06, 9e-05, true, 'uniform', 0, Inf);
problem.addBacksPar('Backs parameter 4', 1e-06, 5.61041493766278e-06, 9e-05, true, 'uniform', 0, Inf);
problem.addBacksPar('Backs parameter 5', 1e-06, 2.00331649600995e-06, 9e-06, false, 'uniform', 0, Inf);
problem.addBacksPar('Backs parameter 6', 1e-06, 5.06844464736415e-06, 9e-06, false, 'uniform', 0, Inf);

problem.removeResolPar(1);
problem.addResolPar('Resolution par 1', 0.01, 0.0393517351417507, 0.05, true, 'uniform', 0, Inf);

problem.removeBackground(1);
problem.removeResolution(1);

problem.addCustomFile('volume_thiolsam_plus_DPPC_tail_split_polarised', 'volume_thiolsam_plus_DPPC_tail_split_polarised_abs.m', 'matlab', 'pwd');

problem.addBackground('Background 1', 'constant', 'Backs parameter 1', '', '', '', '');
problem.addBackground('Background 2', 'constant', 'Backs parameter 2', '', '', '', '');
problem.addBackground('Background 3', 'constant', 'Backs parameter 3', '', '', '', '');
problem.addBackground('Background 4', 'constant', 'Backs parameter 4', '', '', '', '');
problem.addBackground('Background 5', 'constant', 'Backs parameter 5', '', '', '', '');
problem.addBackground('Background 6', 'constant', 'Backs parameter 6', '', '', '', '');

problem.addResolution('Resolution 1', 'constant', 'Resolution par 1', '', '', '', '');

problem.removeData(1);
problem.addData('Simulation');
problem.setData(1, 'dataRange', [0.01218 0.23877]);
problem.setData(1, 'simRange', [0.01218 0.23877]);

data_2 = readmatrix('data_2.dat');
problem.addData('f92408_10_D2O_d_3pc', data_2);
problem.setData(2, 'dataRange', [0.01218 0.22727]);
problem.setData(2, 'simRange', [0.01218 0.22727]);

data_3 = readmatrix('data_3.dat');
problem.addData('f92408_10_D2O_u_3pc', data_3);
problem.setData(3, 'dataRange', [0.01218 0.23877]);
problem.setData(3, 'simRange', [0.01218 0.23877]);

data_4 = readmatrix('data_4.dat');
problem.addData('f92411_13_H2O_u_3pc', data_4);
problem.setData(4, 'dataRange', [0.01218 0.23877]);
problem.setData(4, 'simRange', [0.01218 0.23877]);

data_5 = readmatrix('data_5.dat');
problem.addData('f92411_13_H2O_d_3pc', data_5);
problem.setData(5, 'dataRange', [0.01218 0.23877]);
problem.setData(5, 'simRange', [0.01218 0.23877]);

problem.addContrast('background', 'Background 1', 'data', 'f92408_10_D2O_d_3pc', 'name', 'Thiol D2O', 'nba', 'Air', 'nbs', 'D2O', 'resolution', 'Resolution 1', 'scalefactor', 'Scalefactor 1');
problem.setContrast(1, 'resample', false);
problem.setContrastModel(1, {'volume_thiolsam_plus_DPPC_tail_split_polarised'});

problem.addContrast('background', 'Background 2', 'data', 'f92408_10_D2O_u_3pc', 'name', 'Thiol D2O', 'nba', 'Air', 'nbs', 'D2O', 'resolution', 'Resolution 1', 'scalefactor', 'Scalefactor 2');
problem.setContrast(2, 'resample', false);
problem.setContrastModel(2, {'volume_thiolsam_plus_DPPC_tail_split_polarised'});

problem.addContrast('background', 'Background 3', 'data', 'f92411_13_H2O_u_3pc', 'name', 'Thiol D2O', 'nba', 'Air', 'nbs', 'H2O', 'resolution', 'Resolution 1', 'scalefactor', 'Scalefactor 3');
problem.setContrast(3, 'resample', false);
problem.setContrastModel(3, {'volume_thiolsam_plus_DPPC_tail_split_polarised'});

problem.addContrast('background', 'Background 4', 'data', 'f92411_13_H2O_d_3pc', 'name', 'Thiol D2O', 'nba', 'Air', 'nbs', 'H2O', 'resolution', 'Resolution 1', 'scalefactor', 'Scalefactor 4');
problem.setContrast(4, 'resample', false);
problem.setContrastModel(4, {'volume_thiolsam_plus_DPPC_tail_split_polarised'});

