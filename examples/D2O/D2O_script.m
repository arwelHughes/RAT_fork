
%% Analysis of D2O Calibration Sample

% Start by making an empty project...
problem = createProject(name='D2O Sample');

% The default is already D2O. To analyse a sample we just need to include
% the data and make a contrast....
data = readtable('D2O_data.dat');
data = table2array(data);
problem.addData('D2O Data',data);

% Make a contrast..
problem.addContrast('name',         'D2O',...
                    'background',   'Background 1',...
                    'resolution',   'Resolution 1',...
                    'scalefactor',  'Scalefactor 1',...
                    'BulkOut',      'SLD D2O',...        
                    'BulkIn',       'SLD Air',...        
                    'data',         'D2O Data');

% Ensure that Background and Scalefactor are fittable...
problem.setScalefactor(1,'fit',true);
problem.setBackgroundParam(1,'fit',true);

% Make sure we have a decent range for roughness...
problem.setParameter(1,'min',1,'max',10);

% Make a controls block..
controls = controlsClass();
controls.procedure = 'dream';

% Run the analysis....
[problem,results] = RAT(problem,controls);

% Plot them out...
figure(1); clf
bayesShadedPlot(problem,results,'fit','average','KeepAxes',true,'interval',65,'q4',false);

figure(2); clf
cornerPlot(results)

%% Deciding if the surface is clean...

% Run the Nested Sampler....
controls.procedure = 'NS';
controls.display = 'final';
[problem,noLayerResults] = RAT(problem,controls);


% Add a layer to the sample, and re-run the NS....
parameters = {{'d',     0,      0,      20,     true}
              {'rho',   -0.5e-6 0   6.35e-6,    true}
              {'sig',   0,      0,      10,     true}};

problem.addParameterGroup(parameters);

% Group these into a layer...
problem.addLayer('Layer 1','d','rho','sig');

% Set the model on our contrast to be this layer....
problem.setContrastModel(1,{'Layer 1'});






