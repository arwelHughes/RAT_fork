classdef controlsClass < handle & matlab.mixin.CustomDisplay
    % ``controlsClass`` determines how RAT works. It allows the user to interact with the software, by choosing how to parallelise, 
    % whether to calculate the SLD during a fit, how many iterations an algorithm should do and more.
    %
    % There are 5 different procedures available for calculations in RAT. They are: 
    %  
    % * Calculate
    % * Simplex
    % * Differential Evolution (DE)
    % * Nested Sampler (NS)
    % * DREAM
    %
    % Each procedure has their own unique set of options so the relevant procedure is listed in square brackets before the options description.
    %
    % Examples
    % --------
    % >>> controls = controlsClass();
    % >>> controls.procedure = procedures.Dream;
    % >>> controls.nSamples = 6000;
    % >>> controls.nChains = 10;
    % >>> controls.parallel = parallelOptions.Contrasts;
    %  
    % Alternatively use the ``setProcedure`` method
    %
    % >>> controls = controlsClass();
    % >>> controls.setProcedure('dream', 'nSamples', 6000, 'nChains', 10, 'parallel', 'contrasts');
    %
    % Attributes
    % ----------
    % parallel : parallelOptions, default: parallelOptions.Single 
    %     How the calculation should be parallelised (This uses the Parallel Computing Toolbox). Can be 'single', 'contrasts' or 'points'.
    % procedure : procedures, default: procedures.Calculate
    %     Which procedure RAT should execute. Can be 'calculate', 'simplex', 'de', 'ns', or 'dream'.
    % calcSldDuringFit : logical, default: false
    %     Whether SLD will be calculated during fit (for live plotting etc.)
    % resampleMinAngle : float, default: 0.9
    %     The upper threshold on the angle between three sampled points for resampling, in units of radians over pi.
    % resampleNPoints : whole number, default: 50
    %     The number of initial points to use for resampling.
    % display : displayOptions, default: displayOptions.Iter
    %     How much RAT should print to the terminal. Can be 'off', 'iter', 'notify', or 'final'.
    % updateFreq : whole number, default: 1
    %     [SIMPLEX, DE] Number of iterations between printing progress updates to the terminal.
    % updatePlotFreq : whole number, default: 20
    %     [SIMPLEX, DE] Number of iterations between updates to live plots.
    %
    % xTolerance : float, default: 1e-6 
    %     [SIMPLEX] The termination tolerance for step size.
    % funcTolerance : float, default: 1e-6
    %     [SIMPLEX] The termination tolerance for change in chi-squared.
    % maxFuncEvals : whole number, default: 10000
    %     [SIMPLEX] The maximum number of function evaluations before the algorithm terminates.
    % maxIterations : whole number, default: 1000
    %     [SIMPLEX] The maximum number of iterations before the algorithm terminates.
    %
    % populationSize : whole number, default: 20
    %     [DE] The number of candidate solutions that exist at any time.
    % fWeight : float, default: 0.5
    %     [DE] The step size for how different mutations are to their parents.
    % crossoverProbability : float, default: 0.8
    %     [DE] The probability of exchange of parameters between individuals at any iteration.
    % strategy : searchStrategy, default: searchStrategy.RandomWithPerVectorDither
    %     [DE] The algorithm used to generate new candidates.
    % targetValue : float, default: 1
    %     [DE] The value of chi-squared at which the algorithm will terminate.
    % numGenerations : whole number, default: 500
    %     [DE] The maximum number of iterations before the algorithm terminates.
    %
    % nLive : whole number, default: 150
    %     [NS] The number of points to sample.
    % nMCMC : whole number, default: 0
    %     [NS] If non-zero, an MCMC process with ``nMCMC`` chains will be used instead of MultiNest.
    % propScale : float, default: 0.1
    %     [NS] A scaling factor for the ellipsoid generated by MultiNest.
    % nsTolerance : float, default: 0.1
    %     [NS] The tolerance threshold for when the algorithm should terminate.
    %
    % nSamples : whole number, default: 20000
    %     [DREAM] The total number of function evaluations (number of algorithm generations times number of chains).
    % nChains : whole number, default: 10
    %     [DREAM] The number of Markov chains to use in the algorithm.
    % jumpProbability : float, default: 0.5
    %     [DREAM] The probability range for the size of jumps in sampling. Larger values mean more variable jumps.
    % pUnitGamma : float, default: 0.2
    %     [DREAM] The probability that the scaling-down factor of jumps will be ignored and a larger jump will be taken.
    % boundHandling : boundHandlingOptions, default: boundHandlingOptions.Reflect
    %     [DREAM] How steps past the space boundaries should be handled. Can be 'off', 'reflect', 'bound', or 'fold'.
    % adaptPCR : logical, default: true
    %     [DREAM] Whether the crossover probability for differential evolution should be adapted during the run.

    properties
        
        procedure = procedures.Calculate.value
        parallel = parallelOptions.Single.value
        calcSldDuringFit = false
        resampleMinAngle = 0.9
        resampleNPoints = 50
        display = displayOptions.Iter.value
        
        xTolerance = 1e-6
        funcTolerance = 1e-6
        maxFuncEvals = 10000
        maxIterations = 1000

        updateFreq = 1
        updatePlotFreq = 20

        populationSize = 20
        fWeight = 0.5
        crossoverProbability = 0.8
        strategy = searchStrategy.RandomWithPerVectorDither.index
        targetValue = 1
        numGenerations = 500
        
        nLive = 150
        nMCMC = 0
        propScale = 0.1
        nsTolerance = 0.1
        
        nSamples = 20000
        nChains = 10
        jumpProbability = 0.5
        pUnitGamma = 0.2
        boundHandling = boundHandlingOptions.Reflect.value
        adaptPCR = true;
    end
    
    
    properties (SetAccess = private, Hidden = true)
        IPCFilePath = ''
    end
    
    %------------------------- Set and Get ------------------------------
    methods
        function set.parallel(obj,val)
            message = sprintf('parallel must be a parallelOptions enum or one of the following strings (%s)', ...
                strjoin(parallelOptions.values(), ', '));
            obj.parallel = validateOption(val, 'parallelOptions', message).value;
        end
        
        function set.procedure(obj,val)
            message = sprintf('procedure must be a procedures enum or one of the following strings (%s)', ...
                strjoin(procedures.values(), ', '));
            obj.procedure = validateOption(val, 'procedures', message).value;
        end
        
        function set.calcSldDuringFit(obj,val)
            validateLogical(val, 'calcSldDuringFit must be logical ''true'' or ''false''');
            obj.calcSldDuringFit = val;
        end
        
        function set.display(obj,val)
            message = sprintf('display must be a displayOptions enum or one of the following strings (%s)', ...
                strjoin(displayOptions.values(), ', '));
            obj.display = validateOption(val, 'displayOptions', message).value;
        end
        
        function set.updateFreq(obj, val)
            validateNumber(val, 'updateFreq must be a whole number', true);
            if val < 1
                throw(exceptions.invalidValue('updateFreq must be greater or equal to 1'));
            end
            obj.updateFreq = val;
        end
        
        function set.updatePlotFreq(obj, val)
            validateNumber(val, 'updatePlotFreq must be a whole number', true);
            if val < 1
                throw(exceptions.invalidValue('updatePlotFreq must be greater or equal to 1'));
            end
            obj.updatePlotFreq = val;
        end
        
        function set.resampleMinAngle(obj,val)
            validateNumber(val, 'resampleMinAngle must be a number');
            if (val <= 0 || val > 1)
                throw(exceptions.invalidValue('resampleMinAngle must be between 0 and 1'));
            end
            obj.resampleMinAngle = val;
        end
        
        function set.resampleNPoints(obj,val)
            validateNumber(val, 'resampleNPoints must be a whole number', true);
            if (val <= 0)
                throw(exceptions.invalidValue('resampleNPoints must be greater than 0'));
            end
            obj.resampleNPoints = val;
        end
        
        % Simplex control methods
        function set.xTolerance(obj, val)
            obj.xTolerance = validateNumber(val, 'xTolerance must be a number');
        end
        
        function set.funcTolerance(obj, val)
            obj.funcTolerance = validateNumber(val, 'funcTolerance must be a number');
        end
        
        function set.maxFuncEvals(obj, val)
            obj.maxFuncEvals = validateNumber(val, 'maxFuncEvals must be a whole number', true);
        end
        
        function set.maxIterations(obj, val)
            obj.maxIterations = validateNumber(val, 'maxIterations must be a whole number', true);
        end
        
        % DE controls methods
        function set.populationSize(obj, val)
            validateNumber(val, 'populationSize must be a whole number', true);
            if val < 1
                throw(exceptions.invalidValue('populationSize must be greater or equal to 1'));
            end
            obj.populationSize = val;
        end
        
        function set.fWeight(obj,val)
            obj.fWeight = validateNumber(val,'fWeight must be a number');
            if val <= 0
              throw(exceptions.invalidValue('fWeight must be greater than 0'));
            end
        end
        
        function set.crossoverProbability(obj,val)
            validateNumber(val, 'crossoverProbability must be a number');
            if (val < 0 || val > 1)
                throw(exceptions.invalidValue('crossoverProbability must be between 0 and 1'));
            end
            obj.crossoverProbability = val;
        end
        
        function set.strategy(obj,val)
            values = searchStrategy.values();
            message = sprintf('strategy must be a searchStrategy enum or one of the following strings (%s)', ...
                strjoin(string(values), ', '));
            
            % Convert the strategy to its index
            obj.strategy = validateOption(val, 'searchStrategy', message).index;
        end
        
        function set.targetValue(obj,val)
            validateNumber(val, 'targetValue must be a number');
            if val < 1
                throw(exceptions.invalidValue('targetValue must be greater or equal to 1'));
            end
            obj.targetValue = val;
        end
        
        function set.numGenerations(obj, val)
            validateNumber(val, 'numGenerations value must be a whole number', true);
            if val < 1
                throw(exceptions.invalidValue('numGenerations must be greater or equal to 1'));
            end
            obj.numGenerations = val;
        end
        
        % NS control methods
        function set.nLive(obj, val)
            validateNumber(val, 'nLive must be a whole number', true);
            if val < 1
                throw(exceptions.invalidValue('nLive must be greater or equal to 1'));
            end
            obj.nLive = val;
        end
        
        function set.nMCMC(obj, val)
            validateNumber(val, 'nMCMC must be a whole number', true);
            if val < 0
                throw(exceptions.invalidValue('nMCMC must be greater or equal than 0'));
            end
            obj.nMCMC = val;
        end
        
        function set.propScale(obj, val)
            validateNumber(val, 'propScale must be a number');
            if (val < 0 || val > 1)
                throw(exceptions.invalidValue('propScale must be between 0 and 1'));
            end
            obj.propScale = val;
        end
        
        function set.nsTolerance(obj,val)
            validateNumber(val, 'nsTolerance must be a number ');
            if val < 0
                throw(exceptions.invalidValue('nsTolerance must be greater or equal to 0'));
            end
            obj.nsTolerance = val;
        end
        
        % DREAM methods
        function set.nSamples(obj,val)
            validateNumber(val, 'nSamples must be a whole number', true);
            if val < 0
                throw(exceptions.invalidValue('nSample must be greater or equal to 0'));
            end
            obj.nSamples = val;
        end
        
        function set.nChains(obj,val)
            validateNumber(val, 'nChains must be a whole number', true);
            if val <= 1
                throw(exceptions.invalidValue('nChains must be a finite integer greater than 1'));
            end
            obj.nChains = val;
        end
        
        function set.jumpProbability(obj,val)
            validateNumber(val, 'jumpProbability must be a number');
            if (val < 0 || val > 1)
                throw(exceptions.invalidValue('JumpProbability must be a fraction between 0 and 1'));
            end
            obj.jumpProbability = val;
        end
        
        function set.pUnitGamma(obj,val)
            validateNumber(val, 'pUnitGamma must be a number');
            if (val < 0 || val > 1)
                throw(exceptions.invalidValue('pUnitGamma must be a fraction between 0 and 1'));
            end
            obj.pUnitGamma = val;
        end
        
        function set.boundHandling(obj,val)
            message = sprintf('boundHandling must be a boundHandlingOptions enum or one of the following strings (%s)', ...
                strjoin(boundHandlingOptions.values(), ', '));
            obj.boundHandling = validateOption(val, 'boundHandlingOptions', message).value;
        end
        
        function set.adaptPCR(obj,val)
            validateLogical(val, 'adaptPCR must be logical ''true'' or ''false''');
            obj.adaptPCR = val;
        end
        
        
        function obj = setProcedure(obj, procedure, varargin)
            % Sets the properties of the controls object based on the selected procedures
            % 
            % Examples
            % --------
            % >>> controls = controlsClass();
            % >>> controls.setProcedure('simplex', 'xTolerance', 1e-6, 'funcTolerance', 1e-6,'maxFuncEvals', 1000);
            % >>> controls.setProcedure('dream');  % This will use default DREAM options 
            % >>> controls.setProcedure('ns', 'nLive', 150,'nMCMC', 0, 'propScale', 0.1, 'nsTolerance', 0.1);
            %
            % Parameters
            % ----------
            % procedure : str or procedures
            %    Which procedure RAT should execute. Can be 'calculate', 'simplex', 'de', 'ns', or 'dream'.
            % varargin
            %   keyword/value pairs of the available options for the specified procedure.            
            message = sprintf(['%s is not a supported procedure. The procedure must be a procedures enum or one of ' ...
                'the following strings (%s)'], procedure, strjoin(procedures.values(), ', '));
            procedure = validateOption(procedure, 'procedures', message).value;
            switch procedure
                
                case procedures.Calculate.value
                    % Parses the inputs and sets the object properties of
                    % the Calculate procedure
                    if ~isempty(varargin)
                        obj = obj.processCalculateInput(varargin);
                    end
                    obj.procedure = procedures.Calculate.value;
                    
                case procedures.Simplex.value
                    % Parses the inputs and sets the object properties of
                    % the Simplex procedure
                    if ~isempty(varargin)
                        obj = obj.processSimplexInput(varargin);
                    end
                    obj.procedure = procedures.Simplex.value;
                    
                case procedures.DE.value
                    % Parses the inputs and sets the object properties of
                    % the Differential Evolution procedure
                    if ~isempty(varargin)
                        obj = obj.processDEInput(varargin);
                    end
                    obj.procedure = procedures.DE.value;
                    
                case procedures.NS.value
                    % Parses the inputs and sets the object properties of
                    % the Nested Sampler procedure
                    if ~isempty(varargin)
                        obj = obj.processNSInput(varargin);
                    end
                    obj.procedure = procedures.NS.value;
                    
                case procedures.Dream.value
                    % Parses the inputs and sets the object properties of
                    % the DREAM procedure
                    if ~isempty(varargin)
                        obj = obj.processDreamInput(varargin);
                    end
                    obj.procedure = procedures.Dream.value;
            end
            
        end
        
        function obj = initialiseIPC(obj)
            % Creates and initialises the inter-process communication file
            %
            % Examples
            % --------
            % >>> controls = controlsClass();
            % >>> controls.initialiseIPC(); 
            obj.IPCFilePath = tempname();
            fileID = fopen(obj.IPCFilePath, 'w');
            fwrite(fileID, false, 'uchar');
            fclose(fileID);
        end
        
        function path = getIPCFilePath(obj)
            % Returns the path of the IPC file.
            %
            % Examples
            % --------
            % >>> controls = controlsClass();
            % >>> path = controls.getIPCFilePath();
            %
            % Returns
            % -------
            % path : char array
            %    path of the IPC file.
            path = obj.IPCFilePath;
        end
        
        function obj = sendStopEvent(obj)
            % Sends the stop event via IPC file.
            %
            % Examples
            % --------
            % >>> controls = controlsClass();
            % >>> controls.sendStopEvent();
            if isempty(obj.IPCFilePath)
                return
            end
            fileID = fopen(obj.IPCFilePath, 'w');
            fwrite(fileID, true, 'uchar');
            fclose(fileID);
        end
    end
    
    %------------------------- Display Methods --------------------------
    methods (Access = protected)
        function groups = getPropertyGroups(obj)
            masterPropList = struct('parallel', {obj.parallel},...
                'procedure', {obj.procedure},...
                'calcSldDuringFit', {obj.calcSldDuringFit},...
                'display', {obj.display},...
                'xTolerance', {obj.xTolerance},...
                'funcTolerance', {obj.funcTolerance},...
                'maxFuncEvals', {obj.maxFuncEvals},...
                'maxIterations', {obj.maxIterations},...
                'updateFreq', {obj.updateFreq},...
                'updatePlotFreq', {obj.updatePlotFreq},...
                'populationSize', {obj.populationSize},...
                'fWeight', {obj.fWeight},...
                'crossoverProbability', {obj.crossoverProbability},...
                'strategy', {obj.strategy},...
                'targetValue', {obj.targetValue},...
                'numGenerations', {obj.numGenerations},...
                'nLive', {obj.nLive},...
                'nMCMC', {obj.nMCMC},...
                'propScale', {obj.propScale},...
                'nsTolerance', {obj.nsTolerance},...
                'resampleMinAngle', {obj.resampleMinAngle},...
                'resampleNPoints', {obj.resampleNPoints},...
                'nSamples', {obj.nSamples},...
                'nChains', {obj.nChains},...
                'jumpProbability', {obj.jumpProbability},...
                'pUnitGamma', {obj.pUnitGamma},...
                'boundHandling', {obj.boundHandling},...
                'adaptPCR', {obj.adaptPCR});
            
            simplexCell = {'xTolerance',...
                'funcTolerance',...
                'maxFuncEvals',...
                'maxIterations',...
                };
            
            deCell = {'populationSize',...
                'fWeight',...
                'crossoverProbability',...
                'strategy',...
                'targetValue',...
                'numGenerations'};
            
            nsCell = {'nLive',...
                'nMCMC',...
                'propScale',...
                'nsTolerance'};
            
            dreamCell = {'nSamples',...
                'nChains',...
                'jumpProbability',...
                'pUnitGamma',...
                'boundHandling',...
                'adaptPCR'};
            
            if isscalar(obj)
                dispPropList = masterPropList;
                if strcmpi(obj.procedure, 'calculate')
                    dispPropList = rmfield(masterPropList, [deCell, simplexCell, nsCell, dreamCell, {'updatePlotFreq','updateFreq'}]);
                elseif strcmpi(obj.procedure, 'simplex')
                    dispPropList = rmfield(masterPropList, [deCell, nsCell, dreamCell]);
                elseif strcmpi(obj.procedure, 'de')
                    dispPropList = rmfield(masterPropList, [simplexCell, nsCell, dreamCell]);
                    % Add the update back...
                elseif strcmpi(obj.procedure, 'ns')
                    dispPropList = rmfield(masterPropList, [simplexCell, deCell, dreamCell, {'updatePlotFreq','updateFreq'}]);
                elseif strcmpi(obj.procedure, 'dream')
                    dispPropList = rmfield(masterPropList, [simplexCell, deCell, nsCell, {'updatePlotFreq','updateFreq'}]);
                end
                groups = matlab.mixin.util.PropertyGroup(dispPropList);
            else
                groups = getPropertyGroups@matlab.mixin.CustomDisplay(obj);
            end
        end
    end
    
    %------------------------- Parsing Methods --------------------------
    methods (Access = private)
        
        function obj = processCalculateInput(obj, varargin)
            % Parses calculate keyword/value pairs and sets the properties of the class.
            %
            % obj.processCalculateInput('param', 'value')
            %
            % The parameters that can be set when using calculate procedure are
            % 1) parallel
            % 2) calcSldDuringFit
            % 3) resampleMinAngle
            % 4) resampleNPoints
            % 5) display
            
            % The default values for Calculate
            defaultParallel = parallelOptions.Single.value;
            defaultCalcSldDuringFit = false;
            defaultMinAngle = 0.9;
            defaultNPoints = 50;
            defaultDisplay = displayOptions.Iter.value;
            
            % Creates the input parser for the calculate parameters
            p = inputParser;
            p.PartialMatching = false;
            addParameter(p,'parallel',  defaultParallel,   @(x) isText(x) || isenum(x));
            addParameter(p,'calcSldDuringFit',   defaultCalcSldDuringFit,    @islogical);
            addParameter(p,'resampleMinAngle', defaultMinAngle,  @isnumeric);
            addParameter(p,'resampleNPoints', defaultNPoints,  @isnumeric);
            addParameter(p,'display',   defaultDisplay,    @(x) isText(x) || isenum(x));
            properties = varargin{:};
            
            % Parses the input or raises invalidOption error
            errorMsg = 'Only parallel, calcSldDuringFit, resampleMinAngle, resampleNPoints and display can be set while using the Calculate procedure';
            inputBlock = obj.parseInputs(p, properties, errorMsg);
            
            % Sets the values the for Calculate parameters
            obj.parallel = inputBlock.parallel;
            obj.calcSldDuringFit = inputBlock.calcSldDuringFit;
            obj.resampleMinAngle = inputBlock.resampleMinAngle;
            obj.resampleNPoints = inputBlock.resampleNPoints;
            obj.display = inputBlock.display;
        end
        
        function obj = processSimplexInput(obj, varargin)
            % Parses simplex keyword/value pairs and sets the properties of the class.
            %
            % obj.parseSimplexInput('param', 'value')
            %
            % The parameters that can be set when using simplex procedure are
            % 1) xTolerance
            % 2) funcTolerance
            % 3) maxFuncEvals
            % 4) maxIterations
            % 5) updateFreq
            % 6) updatePlotFreq
            % 7) parallel
            % 8) calcSldDuringFit
            % 9) resampleMinAngle
            % 10) resampleNPoints
            % 11) display
            
            % The simplex default values
            defaultXTolerance = 1e-6;
            defaultFuncTolerance = 1e-6;
            defaultMaxFuncEvals = 10000;
            defaultMaxIterations = 1000;
            defaultUpdateFreq = 1;
            defaultUpdatePlotFreq = 20;
            defaultParallel = parallelOptions.Single.value;
            defaultCalcSldDuringFit = false;
            defaultMinAngle = 0.9;
            defaultNPoints = 50;
            defaultDisplay = displayOptions.Iter.value;
            
            % Parses the input for simplex parameters
            p = inputParser;
            p.PartialMatching = false;
            addParameter(p,'xTolerance',  defaultXTolerance,   @isnumeric);
            addParameter(p,'funcTolerance',   defaultFuncTolerance,    @isnumeric);
            addParameter(p,'maxFuncEvals', defaultMaxFuncEvals,  @isnumeric);
            addParameter(p,'maxIterations',   defaultMaxIterations,    @isnumeric);
            addParameter(p,'updateFreq',   defaultUpdateFreq,    @isnumeric);
            addParameter(p,'updatePlotFreq',   defaultUpdatePlotFreq,    @isnumeric);
            addParameter(p,'parallel',  defaultParallel,   @(x) isText(x) || isenum(x));
            addParameter(p,'calcSldDuringFit',   defaultCalcSldDuringFit,    @islogical);
            addParameter(p,'resampleMinAngle', defaultMinAngle,  @isnumeric);
            addParameter(p,'resampleNPoints', defaultNPoints,  @isnumeric);
            addParameter(p,'display',   defaultDisplay,    @(x) isText(x) || isenum(x));
            properties = varargin{:};
            
            % Parses the input or raises invalidOption error
            errorMsg = 'Only xTolerance, funcTolerance, maxFuncEvals, maxIterations, updateFreq, updatePlotFreq, parallel, calcSldDuringFit, resampleMinAngle, resampleNPoints and display can be set while using the Simplex procedure.';
            inputBlock = obj.parseInputs(p, properties, errorMsg);
            
            % Sets the values the for simplex parameters
            obj.xTolerance = inputBlock.xTolerance;
            obj.funcTolerance = inputBlock.funcTolerance;
            obj.maxFuncEvals = inputBlock.maxFuncEvals;
            obj.maxIterations = inputBlock.maxIterations;
            obj.updateFreq = inputBlock.updateFreq;
            obj.updatePlotFreq = inputBlock.updatePlotFreq;
            obj.parallel = inputBlock.parallel;
            obj.calcSldDuringFit = inputBlock.calcSldDuringFit;
            obj.resampleMinAngle = inputBlock.resampleMinAngle;
            obj.resampleNPoints = inputBlock.resampleNPoints;
            obj.display = inputBlock.display;
        end
        
        function obj = processDEInput(obj, varargin)
            % Parses differential evolution keyword/value pairs and sets the properties of the class.
            %
            % obj.processDEInput('param', 'value')
            %
            % The parameters that can be set when using de procedure are
            % 1) populationSize
            % 2) fWeight
            % 3) crossoverProbability
            % 4) strategy
            % 5) targetValue
            % 6) numGenerations
            % 7) parallel
            % 8) calcSldDuringFit
            % 9) resampleMinAngle
            % 10) resampleNPoints
            % 11) display
            % 12) updateFreq
            % 13) updatePlotFreq
            
            % The default values for DE
            defaultPopulationSize = 20;
            defaultFWeight = 0.5;
            defaultCrossoverProbability = 0.8;
            defaultStrategy = 4;
            defaultTargetValue = 1;
            defaultNumGenerations = 500;
            defaultParallel = parallelOptions.Single.value;
            defaultCalcSldDuringFit = false;
            defaultMinAngle = 0.9;
            defaultNPoints = 50;
            defaultDisplay = displayOptions.Iter.value;
            defaultUpdateFreq = 1;
            defaultUpdatePlotFreq = 20;
            
            % Creates the input parser for the DE parameters
            p = inputParser;
            p.PartialMatching = false;
            addParameter(p,'populationSize',  defaultPopulationSize,   @isnumeric);
            addParameter(p,'fWeight',   defaultFWeight,    @isnumeric);
            addParameter(p,'crossoverProbability', defaultCrossoverProbability,  @isnumeric);
            addParameter(p,'strategy',   defaultStrategy,    @isnumeric);
            addParameter(p,'targetValue',   defaultTargetValue,    @isnumeric);
            addParameter(p,'numGenerations',   defaultNumGenerations,    @isnumeric);
            addParameter(p,'parallel',  defaultParallel,   @(x) isText(x) || isenum(x));
            addParameter(p,'calcSldDuringFit',   defaultCalcSldDuringFit,    @islogical);
            addParameter(p,'resampleMinAngle', defaultMinAngle,  @isnumeric);
            addParameter(p,'resampleNPoints', defaultNPoints,  @isnumeric);
            addParameter(p,'display',   defaultDisplay,    @(x) isText(x) || isenum(x));
            addParameter(p,'updateFreq',   defaultUpdateFreq,    @isnumeric);
            addParameter(p,'updatePlotFreq',   defaultUpdatePlotFreq,    @isnumeric);
            properties = varargin{:};
            
            % Parses the input or raises invalidOption error
            errorMsg = 'Only populationSize, fWeight, crossoverProbability, strategy, targetValue, numGenerations, parallel, calcSldDuringFit, resampleMinAngle, resampleNPoints, display, updateFreq, and updatePlotFreq can be set while using the Differential Evolution procedure';
            inputBlock = obj.parseInputs(p, properties, errorMsg);
            
            % Sets the values the for DE parameters
            obj.populationSize = inputBlock.populationSize;
            obj.fWeight = inputBlock.fWeight;
            obj.crossoverProbability = inputBlock.crossoverProbability;
            obj.strategy = inputBlock.strategy;
            obj.targetValue = inputBlock.targetValue;
            obj.numGenerations = inputBlock.numGenerations;
            obj.parallel = inputBlock.parallel;
            obj.calcSldDuringFit = inputBlock.calcSldDuringFit;
            obj.resampleMinAngle = inputBlock.resampleMinAngle;
            obj.resampleNPoints = inputBlock.resampleNPoints;
            obj.display = inputBlock.display;
            obj.updateFreq = inputBlock.updateFreq;
            obj.updatePlotFreq = inputBlock.updatePlotFreq;
        end
        
        function obj = processNSInput(obj, varargin)
            % Parses nested sampler keyword/value pairs and sets the properties of the class.
            %
            % obj.processNSInput('param', 'value')
            %
            % The parameters that can be set when using nested sampler procedure are
            % 1) nLive
            % 2) nMCMC
            % 3) propScale
            % 4) nsTolerance
            % 5) parallel
            % 6) calcSldDuringFit
            % 7) resampleMinAngle
            % 8) resampleNPoints
            % 9) display
            
            % The default values for NS
            defaultnLive = 150;
            defaultnMCMC = 0;
            defaultPropScale = 0.1;
            defaultNsTolerance = 0.1;
            defaultParallel = parallelOptions.Single.value;
            defaultCalcSldDuringFit = false;
            defaultMinAngle = 0.9;
            defaultNPoints = 50;
            defaultDisplay = displayOptions.Iter.value;
            
            % Creates the input parser for the NS parameters
            p = inputParser;
            p.PartialMatching = false;
            addParameter(p,'nLive',  defaultnLive,   @isnumeric);
            addParameter(p,'nMCMC',   defaultnMCMC,    @isnumeric);
            addParameter(p,'propScale', defaultPropScale,  @isnumeric);
            addParameter(p,'nsTolerance',   defaultNsTolerance,    @isnumeric);
            addParameter(p,'parallel',  defaultParallel,   @(x) isText(x) || isenum(x));
            addParameter(p,'calcSldDuringFit',   defaultCalcSldDuringFit,    @islogical);
            addParameter(p,'resampleMinAngle', defaultMinAngle,  @isnumeric);
            addParameter(p,'resampleNPoints', defaultNPoints,  @isnumeric);
            addParameter(p,'display',   defaultDisplay,    @(x) isText(x) || isenum(x));
            properties = varargin{:};
            
            % Parses the input or raises invalidOption error
            errorMsg = 'Only nLive, nMCMC, propScale, nsTolerance, parallel, calcSldDuringFit, resampleMinAngle, resampleNPoints and display can be set while using the Nested Sampler procedure';
            inputBlock = obj.parseInputs(p, properties, errorMsg);
            
            % Sets the values the for NS parameters
            obj.nLive = inputBlock.nLive;
            obj.nMCMC = inputBlock.nMCMC;
            obj.propScale = inputBlock.propScale;
            obj.nsTolerance = inputBlock.nsTolerance;
            obj.parallel = inputBlock.parallel;
            obj.calcSldDuringFit = inputBlock.calcSldDuringFit;
            obj.resampleMinAngle = inputBlock.resampleMinAngle;
            obj.resampleNPoints = inputBlock.resampleNPoints;
            obj.display = inputBlock.display;
        end
        
        function obj = processDreamInput(obj, varargin)
            % Parses Dream keyword/value pairs and sets the properties of the class.
            %
            % obj.processDreamInput('param', 'value')
            %
            % The parameters that can be set when using Dream procedure are
            % 1) nSamples
            % 2) nChains
            % 3) jumpProbability
            % 4) pUnitGamma
            % 5) boundHandling
            % 6) adaptPCR
            % 7) parallel
            % 8) calcSldDuringFit
            % 9) resampleMinAngle
            % 10) resampleNPoints
            % 11) display
            
            % The default values for Dream
            defaultNSamples = 50000;
            defaultNChains = 10;
            defaultJumpProbability = 0.5;
            defaultPUnitGamma = 0.2;
            defaultBoundHandling = boundHandlingOptions.Fold.value;
            defaultAdaptPCR = false;
            defaultParallel = parallelOptions.Single.value;
            defaultCalcSldDuringFit = false;
            defaultMinAngle = 0.9;
            defaultNPoints = 50;
            defaultDisplay = displayOptions.Iter.value;
            
            % Creates the input parser for the Dream parameters
            p = inputParser;
            p.PartialMatching = false;
            addParameter(p,'nSamples',  defaultNSamples,   @isnumeric);
            addParameter(p,'nChains',   defaultNChains,    @isnumeric);
            addParameter(p,'jumpProbability', defaultJumpProbability,  @isnumeric);
            addParameter(p,'pUnitGamma',   defaultPUnitGamma,    @isnumeric);
            addParameter(p,'boundHandling',   defaultBoundHandling, @(x) isText(x) || isenum(x));
            addParameter(p,'adaptPCR', defaultAdaptPCR, @islogical);
            addParameter(p,'parallel',  defaultParallel,   @(x) isText(x) || isenum(x));
            addParameter(p,'calcSldDuringFit',   defaultCalcSldDuringFit,    @islogical);
            addParameter(p,'resampleMinAngle', defaultMinAngle,  @isnumeric);
            addParameter(p,'resampleNPoints', defaultNPoints,  @isnumeric);
            addParameter(p,'display',   defaultDisplay,    @(x) isText(x) || isenum(x));
            properties = varargin{:};
            
            % Parses the input or raises invalidOption error
            errorMsg = 'Only nSamples, nChains, jumpProbability, pUnitGamma, boundHandling, adaptPCR, parallel, calcSldDuringFit, resampleMinAngle, resampleNPoints and display can be set while using the DREAM procedure';
            inputBlock = obj.parseInputs(p, properties, errorMsg);
            
            % Sets the values the for Dream parameters
            obj.nSamples = inputBlock.nSamples;
            obj.nChains = inputBlock.nChains;
            obj.jumpProbability = inputBlock.jumpProbability;
            obj.pUnitGamma = inputBlock.pUnitGamma;
            obj.boundHandling = inputBlock.boundHandling;
            obj.adaptPCR = inputBlock.adaptPCR;
            obj.parallel = inputBlock.parallel;
            obj.calcSldDuringFit = inputBlock.calcSldDuringFit;
            obj.resampleMinAngle = inputBlock.resampleMinAngle;
            obj.resampleNPoints = inputBlock.resampleNPoints;
            obj.display = inputBlock.display;
        end
        
        function inputBlock = parseInputs(~, p, properties, errorMsg)
            % Parses the input or raises invalidOption error
            try
                parse(p, properties{:});
                inputBlock = p.Results;
            catch ME
                if (strcmp(ME.identifier,'MATLAB:InputParser:UnmatchedParameter'))
                    throw(exceptions.invalidOption(errorMsg));
                else
                    rethrow(ME)
                end
            end
        end
        
    end
end
