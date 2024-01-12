% THIS FILE IS GENERATED FROM RAT VIA THE "WRITESCRIPT" ROUTINE. IT IS NOT PART OF THE RAT CODE.

problem = createProject(name='defaultProject', calcType='non polarised', model='standard layers', geometry='air/substrate', absorption=false);

problem.setParameterValue(1, 4.84435233788376);
problem.setParameterLimits(1, 3, 8);
problem.setParameterFit(1, true);
problem.setParameterPrior(1, 'uniform', 0, Inf);


problem.removeBulkIn(1);
problem.addBulkIn('Air', 0, 0, 0, false, 'uniform', 0, Inf);

problem.removeBulkOut(1);
problem.addBulkOut('D2O', 6.3e-06, 6.35e-06, 6.4e-06, false, 'uniform', 0, Inf);

problem.removeScalefactor(1);
problem.addScalefactor('Scalefactor 1', 0.05, 0.101413389534789, 0.3, true, 'uniform', 0, Inf);

problem.removeQzshift(1);
problem.addQzshift('Qz shift 1', -0.0001, 0, 0.0001, false, 'uniform', 0, Inf);

problem.removeBackgroundParam(1);
problem.addBackgroundParam('Backs parameter 1', 5e-08, 3.06906832182103e-06, 7e-06, true, 'uniform', 0, Inf);

problem.removeResolutionParam(1);
problem.addResolutionParam('Resolution par 1', 0.01, 0.03, 0.05, false, 'uniform', 0, Inf);

problem.removeBackground(1);
problem.removeResolution(1);

problem.addBackground('Background 1', 'constant', 'Backs parameter 1', '', '', '', '');

problem.addResolution('Resolution 1', 'constant', 'Resolution par 1', '', '', '', '');

problem.removeData(1);
problem.addData('Simulation');
problem.setData(1, 'dataRange', [0.048866 0.61169]);
problem.setData(1, 'simRange', [0.048866 0.61169]);

data_2 = readmatrix('data_2.dat');
problem.addData('f82395c', data_2);
problem.setData(2, 'dataRange', [0.048866 0.61169]);
problem.setData(2, 'simRange', [0.048866 0.61169]);

problem.addContrast('background', 'Background 1', 'bulkIn', 'Air', 'bulkOut', 'D2O', 'data', 'f82395c', 'name', 'Chain-d, acmw', 'resolution', 'Resolution 1', 'scalefactor', 'Scalefactor 1');
problem.setContrast(1, 'resample', false);

