function ARGS = makeCompileArgsFull()

% Define the arguments for compiling reflectivityCalculation
% using codegen.

%% Define argument types for entry-point 'RATMain'.
maxArraySize = 10000;
maxDataSize = 10000;

ARGS = cell(1,1);
ARGS{1} = cell(3,1);
ARGS_1_1 = struct;
ARGS_1_1.TF = coder.typeof('X',[1 maxArraySize],[0 1]);
ARGS_1_1.resample = coder.typeof(0,[1 maxArraySize],[0 1]);
ARG = coder.typeof(0,[maxDataSize 6],[1 0]);
ARGS_1_1.data = coder.typeof({ARG}, [1 maxArraySize],[0 1]);
ARGS_1_1.dataPresent = coder.typeof(0,[1 maxArraySize],[0 1]);
ARG = coder.typeof(0,[1 2]);
ARGS_1_1.dataLimits = coder.typeof({ARG}, [1 maxArraySize],[0 1]);
ARG = coder.typeof(0,[1 2]);
ARGS_1_1.simulationLimits = coder.typeof({ARG}, [1 maxArraySize],[0 1]);
ARGS_1_1.numberOfContrasts = coder.typeof(0);
ARGS_1_1.geometry = coder.typeof('X',[1 maxArraySize],[0 1]);
ARGS_1_1.useImaginary = coder.typeof(true);
ARG = coder.typeof(0,[1 2]);
ARGS_1_1.repeatLayers = coder.typeof({ARG}, [1 maxArraySize],[0 1]);
ARG = coder.typeof(0,[1 5],[0 1]);
ARGS_1_1.contrastBackgroundParams = coder.typeof({ARG},[1 maxArraySize],[0 1]);
ARG = coder.typeof('X',[1 maxArraySize],[0 1]);
ARGS_1_1.contrastBackgroundTypes = coder.typeof({ARG},[1 maxArraySize],[0 1]);
ARGS_1_1.contrastBackgroundActions = coder.typeof({ARG},[1 maxArraySize],[0 1]);
ARGS_1_1.contrastScalefactors = coder.typeof(0,[1 maxArraySize],[0 1]);
ARGS_1_1.contrastBulkIns = coder.typeof(0,[1 maxArraySize],[0 1]);
ARGS_1_1.contrastBulkOuts = coder.typeof(0,[1 maxArraySize],[0 1]);
ARG = coder.typeof(0,[1 5],[1 1]);
ARGS_1_1.contrastResolutionParams = coder.typeof({ARG},[1 maxArraySize],[0 1]);
ARG = coder.typeof('X',[1 maxArraySize],[0 1]);
ARGS_1_1.contrastResolutionTypes = coder.typeof({ARG},[1 maxArraySize],[0 1]);
ARGS_1_1.backgroundParams = coder.typeof(0,[1 maxArraySize],[0 1]);
ARGS_1_1.scalefactors = coder.typeof(0,[1 maxArraySize],[0 1]);
ARGS_1_1.bulkIns = coder.typeof(0,[1 maxArraySize],[0 1]);
ARGS_1_1.bulkOuts = coder.typeof(0,[1 maxArraySize],[0 1]);
ARGS_1_1.resolutionParams = coder.typeof(0,[1 maxArraySize],[0 1]);
ARGS_1_1.params = coder.typeof(0,[1 maxArraySize],[0 1]);
ARGS_1_1.numberOfLayers = coder.typeof(0);
ARG = coder.typeof(0,[1 maxArraySize],[1 1]);
ARGS_1_1.contrastLayers = coder.typeof({ARG}, [1 maxArraySize],[0 1]);
ARG = coder.typeof(0,[1 10],[1 1]);
ARGS_1_1.layersDetails = coder.typeof({ARG}, [maxArraySize 1],[1 1]);
ARG = coder.typeof('X',[1 maxArraySize],[0 1]);
ARGS_1_1.customFiles = coder.typeof({ARG}, [1 maxArraySize], [0 1]);
ARGS_1_1.modelType = coder.typeof('X',[1 maxArraySize],[0 1]);
ARGS_1_1.contrastCustomFiles = coder.typeof(0,[1 maxArraySize],[0 1]);
ARGS_1_1.contrastDomainRatios = coder.typeof(0,[1 maxArraySize],[0 1]);
ARGS_1_1.domainRatios = coder.typeof(0,[1 maxArraySize],[0 1]);
ARGS_1_1.numberOfDomainContrasts = coder.typeof(0);
ARG = coder.typeof(0,[1 maxArraySize],[1 1]);
ARGS_1_1.domainContrastLayers = coder.typeof({ARG}, [1 maxArraySize],[0 1]);
ARGS_1_1.fitParams = coder.typeof(0,[1 maxArraySize],[0 1]);
ARGS_1_1.fitLimits = coder.typeof(0,[maxArraySize 2],[1 0]);
ARG = coder.typeof('X',[1 maxArraySize],[0 1]);
ARGS_1_1.priorNames = coder.typeof({ARG}, [maxArraySize 1],[1 0]);
ARGS_1_1.priorValues = coder.typeof(0, [maxArraySize 3], [1 0]);
ARGS_1_1_names = struct;
ARG = coder.typeof('X',[1 maxArraySize],[0 1]);
ARGS_1_1_names.params = coder.typeof({ARG}, [1 maxArraySize],[0 1]);
ARGS_1_1_names.backgroundParams = coder.typeof({ARG}, [1 maxArraySize],[0 1]);
ARGS_1_1_names.scalefactors = coder.typeof({ARG}, [1 maxArraySize],[0 1]);
ARGS_1_1_names.bulkIns = coder.typeof({ARG}, [1 maxArraySize],[0 1]);
ARGS_1_1_names.bulkOuts = coder.typeof({ARG}, [1 maxArraySize],[0 1]);
ARGS_1_1_names.resolutionParams = coder.typeof({ARG}, [1 maxArraySize],[0 1]);
ARGS_1_1_names.domainRatios = coder.typeof({ARG}, [1 maxArraySize],[0 1]);
ARGS_1_1_names.contrasts = coder.typeof({ARG}, [1 maxArraySize],[0 1]);
ARGS_1_1.names = coder.typeof(ARGS_1_1_names);
ARGS_1_1_checks = struct;
ARGS_1_1_checks.params = coder.typeof(0,[1 maxArraySize],[0 1]);
ARGS_1_1_checks.backgroundParams = coder.typeof(0,[1 maxArraySize],[0 1]);
ARGS_1_1_checks.scalefactors = coder.typeof(0,[1 maxArraySize],[0 1]);
ARGS_1_1_checks.bulkIns = coder.typeof(0,[1 maxArraySize],[0 1]);
ARGS_1_1_checks.bulkOuts = coder.typeof(0,[1 maxArraySize],[0 1]);
ARGS_1_1_checks.resolutionParams = coder.typeof(0,[1 maxArraySize],[0 1]);
ARGS_1_1_checks.domainRatios = coder.typeof(0,[1 maxArraySize],[0 1]);
ARGS_1_1.checks = coder.typeof(ARGS_1_1_checks);
ARGS{1}{1} = coder.typeof(ARGS_1_1);
ARGS_1_2 = struct;
ARGS_1_2.params = coder.typeof(0,[maxArraySize 2],[1 0]);
ARGS_1_2.backgroundParams = coder.typeof(0,[maxArraySize 2],[1 0]);
ARGS_1_2.scalefactors = coder.typeof(0,[maxArraySize 2],[1 0]);
ARGS_1_2.bulkIns = coder.typeof(0,[maxArraySize 2],[1 0]);
ARGS_1_2.bulkOuts = coder.typeof(0,[maxArraySize 2],[1 0]);
ARGS_1_2.resolutionParams = coder.typeof(0,[maxArraySize 2],[1 0]);
ARGS_1_2.domainRatios = coder.typeof(0,[maxArraySize 2],[1 0]);
ARGS{1}{2} = coder.typeof(ARGS_1_2);
ARGS_1_3 = struct;
ARGS_1_3.procedure = coder.typeof('X',[1 maxArraySize],[0 1]);
ARGS_1_3.parallel = coder.typeof('X',[1 maxArraySize],[0 1]);
ARGS_1_3.resampleMinAngle = coder.typeof(0);
ARGS_1_3.resampleNPoints = coder.typeof(0);
ARGS_1_3.calcSldDuringFit = coder.typeof(true);
ARGS_1_3.display = coder.typeof('X',[1 maxArraySize],[0 1]);
ARGS_1_3.xTolerance = coder.typeof(0);
ARGS_1_3.funcTolerance = coder.typeof(0);
ARGS_1_3.maxFuncEvals = coder.typeof(0);
ARGS_1_3.maxIterations = coder.typeof(0);
ARGS_1_3.updateFreq = coder.typeof(0);
ARGS_1_3.updatePlotFreq = coder.typeof(0);
ARGS_1_3.populationSize = coder.typeof(0);
ARGS_1_3.fWeight = coder.typeof(0);
ARGS_1_3.crossoverProbability = coder.typeof(0);
ARGS_1_3.strategy = coder.typeof(0);
ARGS_1_3.targetValue = coder.typeof(0);
ARGS_1_3.numGenerations = coder.typeof(0);
ARGS_1_3.nLive = coder.typeof(0);
ARGS_1_3.nMCMC = coder.typeof(0);
ARGS_1_3.propScale = coder.typeof(0);
ARGS_1_3.nsTolerance = coder.typeof(0);
ARGS_1_3.nSamples = coder.typeof(0);
ARGS_1_3.nChains = coder.typeof(0);
ARGS_1_3.jumpProbability = coder.typeof(0);
ARGS_1_3.pUnitGamma = coder.typeof(0);
ARGS_1_3.boundHandling = coder.typeof('X',[1 maxArraySize],[0 1]);
ARGS_1_3.adaptPCR = coder.typeof(true);
ARGS_1_3.IPCFilePath = coder.typeof('X',[1 maxArraySize],[0 1]);
ARGS{1}{3} = coder.typeof(ARGS_1_3);

end
