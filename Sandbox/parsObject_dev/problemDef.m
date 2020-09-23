classdef problemDef < matlab.mixin.CustomDisplay
    properties
    %Experiment
        experimentType = 'standard';
        experimentGeometry = 'substrate/liquid';
        
    %All parameters    
        nParams
        params
        paramNames
        paramConstr
        
        nBackgrounds = 1
        backgrounds
        backgroundNames
        backgroundConstr
        
        nScalefactors = 1
        scalefactors
        scalefactorNames
        scalefactorConstr
        
        nQzshifts = 1
        qzshifts
        qzshiftNames
        qzshiftConstr
        
        nNbairs = 1
        nbairs
        nbairNames
        nbairConstr       
        
        nNbsubs = 1
        nbsubs
        nbsubNames
        nbsubConstr   
        
    %Constrasts and Data
        numberOfContrasts = 1
        allData
        dataLimits
        simLimits
        contrastBacks
        contrastShifts
        contrastScales
        contrastNbas
        contrastNbss
        contrastRes
        
    %Model
        modelType = 'layers'
        numberOfLayers
        layersDetails
        contrastLayers
        modelFilename
        modelLanguage
        
    end
    
    methods
        %Experiment block
        function obj = set.experimentType(obj,val)
           if ~strcmpi(val,{'standard','oil-water','PA','domains'})
               error('Type must be ''standard'',''oil-water'',''PA'' or ''domains'' ');
           end
           obj.experimentType = val;
        end
        
        function obj = set.experimentGeometry(obj,val)
           if ~strcmpi(val,{'air/substrate','substrate/liquid'})
               error('Type must be ''air/substrate'' or ''substrate/liquid'' ');
           end
           obj.experimentGeometry = val; 
        end
        
        %Parameters block
        function obj = set.nParams(obj,nParams)
            if (isnan(nParams) || isinf(nParams) || mod(nParams,1) ~= 0)
                error('nParams must be real integer');
            end
            obj.nParams = nParams;
            
            if isempty(obj.params)
                obj.params = zeros(1,nParams);
            elseif (length(obj.params) < nParams)
                obj = obj.extendNParams(nParams);
            elseif (length(obj.params) > nParams)
                obj = obj.contractNParams(nParams);
            end
            
            if isempty(obj.paramNames)
                obj.paramNames = cell(1,nParams);
            elseif (length(obj.paramNames) < nParams)
                obj = obj.extendNParamNames(nParams);
            elseif (length(obj.paramNames) > nParams)
                obj = obj.contractNParamNames(nParams);
            end
            
            if isempty(obj.paramConstr)
                obj.paramConstr = cell(1,nParams);            
            elseif (length(obj.paramConstr) < nParams)
                obj = obj.extendNParamConstr(nParams);
            elseif (length(obj.paramConstr) > nParams)
               obj = obj.contractNParamConstr(nParams);
            end     
            
        end
        
        
        function obj = set.params(obj,val)
            if (length(val) > obj.nParams)
               error('Length of values vector must be <= nparams');
            elseif (isnumeric(val) == false | isinteger(val) == true)
                error('Params must be vector of doubles');
            else
               obj.params = val;
            end
        end
            
        function obj = set.paramNames(obj,val)
            if (length(val) > obj.nParams)
               error('Length of paramNames vector must be <= nparams');
            elseif (iscell(val) == false)
               error('paramNames must be cell array');
             else
               obj.paramNames = val;
            end
        end
        
        function obj = set.paramConstr(obj,val)
            if (length(val) > obj.nParams)
                error('Length of poramConstr vector must be <= nParams');
            elseif (iscell(val) == false)
                error('paramConstr must be cell array');
            else
                for i = 1:length(val)
                    thisVal = val{i};
                    if isempty(thisVal)
                        val{i} = [0  0];
                    elseif (~isnumeric(thisVal) || (size(thisVal,1)~=1 || size(thisVal,2)~=2) || isinteger(val))
                        error('value %d in assignment to paramConstr must be 1x2 double',i);
                    end
                end
            end
           
            obj.paramConstr = val;
        end
        %End parameters block
        
        %-----------------------------------------------------------------------
        
        %Backgrounds block
        function obj = set.nBackgrounds(obj,nBackgrounds)
            if (isnan(nBackgrounds) || isinf(nBackgrounds) || mod(nBackgrounds,1) ~= 0)
                error('nBackgrounds must be real integer');
            end
            obj.nBackgrounds = nBackgrounds;
            
            if isempty(obj.backgrounds)
                obj.backgrounds = zeros(1,nBackgrounds);
            elseif (length(obj.backgrounds) < nBackgrounds)
                obj = obj.extendNBackgrounds(nBackgrounds);
            elseif (length(obj.backgrounds) > nBackgrounds)
                obj = obj.contractNBackgrounds(nBackgrounds);
            end
            
            if isempty(obj.backgroundNames)
                obj.backgroundNames = cell(1,nBackgrounds);
            elseif (length(obj.backgroundNames) < nBackgrounds)
                obj = obj.extendNBackgroundNames(nBackgrounds);
            elseif (length(obj.backgroundNames) > nBackgrounds)
                obj = obj.contractNBackgroundNames(nBackgrounds);
            end
            
            if isempty(obj.backgroundConstr)
                obj.backgroundConstr = cell(1,nBackgrounds);            
            elseif (length(obj.backgroundConstr) < nBackgrounds)
                obj = obj.extendNBackgroundConstr(nBackgrounds);
            elseif (length(obj.backgroundConstr) > nBackgrounds)
               obj = obj.contractNBackgroundConstr(nBackgrounds);
            end     
            
        end
        
        function obj = set.backgrounds(obj,val)
            if (length(val) > obj.nBackgrounds)
               error('Length of values vector must be <= nbackground');
            elseif (isnumeric(val) == false || isinteger(val) == true)
                error('backgrounds must be vector of doubles');
            else
               obj.backgrounds = val;
            end
        end
            
        function obj = set.backgroundNames(obj,val)
            if (length(val) > obj.nBackgrounds)
               error('Length of backgroundNames vector must be <= nbackground');
            elseif (iscell(val) == false)
               error('backgroundNames must be cell array');
             else
               obj.backgroundNames = val;
            end
        end
        
        function obj = set.backgroundConstr(obj,val)
            if (length(val) > obj.nBackgrounds)
                error('Length of poramConstr vector must be <= nbackground');
            elseif (iscell(val) == false)
                error('backgroundConstr must be cell array');
            else
                for i = 1:length(val)
                    thisVal = val{i};
                    if isempty(thisVal)
                        val{i} = [0  0];
                    elseif (~isnumeric(thisVal) || (size(thisVal,1)~=1 || size(thisVal,2)~=2) || isinteger(val))
                        error('value %d in assignment to backgroundConstr must be 1x2 double',i);
                    end
                end
            end
           
            obj.backgroundConstr = val;
        end
    %End backgrounds block
        
    %----------------------------------------------------------------------
    %scalefactors block
        function obj = set.nScalefactors(obj,nScalefactors)
            if (isnan(nScalefactors) || isinf(nScalefactors) || mod(nScalefactors,1) ~= 0)
                error('nScalefactors must be real integer');
            end
            obj.nScalefactors = nScalefactors;
            
            if isempty(obj.scalefactors)
                obj.scalefactors = zeros(1,nScalefactors);
            elseif (length(obj.scalefactors) < nScalefactors)
                obj = obj.extendnScalefactors(nScalefactors);
            elseif (length(obj.scalefactors) > nScalefactors)
                obj = obj.contractNScalefactors(nScalefactors);
            end
            
            if isempty(obj.scalefactorNames)
                obj.scalefactorNames = cell(1,nScalefactors);
            elseif (length(obj.scalefactorNames) < nScalefactors)
                obj = obj.extendNScalefactorNames(nScalefactors);
            elseif (length(obj.scalefactorNames) > nScalefactors)
                obj = obj.contractNScalefactorNames(nScalefactors);
            end
            
            if isempty(obj.scalefactorConstr)
                obj.scalefactorConstr = cell(1,nScalefactors);            
            elseif (length(obj.scalefactorConstr) < nScalefactors)
                obj = obj.extendNScalefactorConstr(nScalefactors);
            elseif (length(obj.scalefactorConstr) > nScalefactors)
               obj = obj.contractNScalefactorConstr(nScalefactors);
            end     
            
        end
        
        function obj = set.scalefactors(obj,val)
            if (length(val) > obj.nScalefactors)
               error('Length of values vector must be <= nscalefactor');
            elseif (isnumeric(val) == false || isinteger(val) == true)
                error('scalefactors must be vector of doubles');
            else
               obj.scalefactors = val;
            end
        end
            
        function obj = set.scalefactorNames(obj,val)
            if (length(val) > obj.nScalefactors)
               error('Length of scalefactorNames vector must be <= nscalefactor');
            elseif (iscell(val) == false)
               error('scalefactorNames must be cell array');
             else
               obj.scalefactorNames = val;
            end
        end
        
        function obj = set.scalefactorConstr(obj,val)
            if (length(val) > obj.nScalefactors)
                error('Length of poramConstr vector must be <= nscalefactor');
            elseif (iscell(val) == false)
                error('scalefactorConstr must be cell array');
            else
                for i = 1:length(val)
                    thisVal = val{i};
                    if isempty(thisVal)
                        val{i} = [0  0];
                    elseif (~isnumeric(thisVal) || (size(thisVal,1)~=1 || size(thisVal,2)~=2) || isinteger(val))
                        error('value %d in assignment to scalefactorConstr must be 1x2 double',i);
                    end
                end
            end
           
            obj.scalefactorConstr = val;
        end
    %End scalefactors block
    
    %----------------------------------------------------------------------
    
    %qzshifts block
        function obj = set.nQzshifts(obj,nQzshifts)
            if (isnan(nQzshifts) || isinf(nQzshifts) || mod(nQzshifts,1) ~= 0)
                error('nQzshifts must be real integer');
            end
            obj.nQzshifts = nQzshifts;
            
            if isempty(obj.qzshifts)
                obj.qzshifts = zeros(1,nQzshifts);
            elseif (length(obj.qzshifts) < nQzshifts)
                obj = obj.extendnQzshifts(nQzshifts);
            elseif (length(obj.qzshifts) > nQzshifts)
                obj = obj.contractNQzshifts(nQzshifts);
            end
            
            if isempty(obj.qzshiftNames)
                obj.qzshiftNames = cell(1,nQzshifts);
            elseif (length(obj.qzshiftNames) < nQzshifts)
                obj = obj.extendNqzshiftNames(nQzshifts);
            elseif (length(obj.qzshiftNames) > nQzshifts)
                obj = obj.contractNQzshiftNames(nQzshifts);
            end
            
            if isempty(obj.qzshiftConstr)
                obj.qzshiftConstr = cell(1,nQzshifts);            
            elseif (length(obj.qzshiftConstr) < nQzshifts)
                obj = obj.extendNqzshiftConstr(nQzshifts);
            elseif (length(obj.qzshiftConstr) > nQzshifts)
               obj = obj.contractNQzshiftConstr(nQzshifts);
            end     
            
        end
        
        function obj = set.qzshifts(obj,val)
            if (length(val) > obj.nQzshifts)
               error('Length of values vector must be <= nqzshift');
            elseif (isnumeric(val) == false | isinteger(val) == true)
                error('qzshifts must be vector of doubles');
            else
               obj.qzshifts = val;
            end
        end
            
        function obj = set.qzshiftNames(obj,val)
            if (length(val) > obj.nQzshifts)
               error('Length of qzshiftNames vector must be <= nqzshift');
            elseif (iscell(val) == false)
               error('qzshiftNames must be cell array');
             else
               obj.qzshiftNames = val;
            end
        end
        
        function obj = set.qzshiftConstr(obj,val)
            if (length(val) > obj.nQzshifts)
                error('Length of poramConstr vector must be <= nqzshift');
            elseif (iscell(val) == false)
                error('qzshiftConstr must be cell array');
            else
                for i = 1:length(val)
                    thisVal = val{i};
                    if isempty(thisVal)
                        val{i} = [0  0];
                    elseif (~isnumeric(thisVal) || (size(thisVal,1)~=1 || size(thisVal,2)~=2) || isinteger(val))
                        error('value %d in assignment to qzshiftConstr must be 1x2 double',i);
                    end
                end
            end
           
            obj.qzshiftConstr = val;
        end
        %End qzshifts block
        
    %----------------------------------------------------------------------
    
        %NBairs block
        function obj = set.nNbairs(obj,nNbairs)
            if (isnan(nNbairs) || isinf(nNbairs) || mod(nNbairs,1) ~= 0)
                error('nNbairs must be real integer');
            end
            obj.nNbairs = nNbairs;
            
            if isempty(obj.nbairs)
                obj.nbairs = zeros(1,nNbairs);
            elseif (length(obj.nbairs) < nNbairs)
                obj = obj.extendNNbairs(nNbairs);
            elseif (length(obj.nbairs) > nNbairs)
                obj = obj.contractNNbairs(nNbairs);
            end
            
            if isempty(obj.nbairNames)
                obj.nbairNames = cell(1,nNbairs);
            elseif (length(obj.nbairNames) < nNbairs)
                obj = obj.extendNNbairNames(nNbairs);
            elseif (length(obj.nbairNames) > nNbairs)
                obj = obj.contractNNbairNames(nNbairs);
            end
            
            if isempty(obj.nbairConstr)
                obj.nbairConstr = cell(1,nNbairs);            
            elseif (length(obj.nbairConstr) < nNbairs)
                obj = obj.extendNNbairConstr(nNbairs);
            elseif (length(obj.nbairConstr) > nNbairs)
               obj = obj.contractNNbairConstr(nNbairs);
            end     
            
        end
        
        
        function obj = set.nbairs(obj,val)
            if (length(val) > obj.nNbairs)
               error('Length of values vector must be <= nnbairs');
            elseif (isnumeric(val) == false | isinteger(val) == true)
                error('Nbairs must be vector of doubles');
            else
               obj.nbairs = val;
            end
        end
            
        function obj = set.nbairNames(obj,val)
            if (length(val) > obj.nNbairs)
               error('Length of nbairNames vector must be <= nnbairs');
            elseif (iscell(val) == false)
               error('nbairNames must be cell array');
             else
               obj.nbairNames = val;
            end
        end
        
        function obj = set.nbairConstr(obj,val)
            if (length(val) > obj.nNbairs)
                error('Length of poramConstr vector must be <= nNbairs');
            elseif (iscell(val) == false)
                error('nbairConstr must be cell array');
            else
                for i = 1:length(val)
                    thisVal = val{i};
                    if isempty(thisVal)
                        val{i} = [0  0];
                    elseif (~isnumeric(thisVal) || (size(thisVal,1)~=1 || size(thisVal,2)~=2) || isinteger(val))
                        error('value %d in assignment to nbairConstr must be 1x2 double',i);
                    end
                end
            end
           
            obj.nbairConstr = val;
        end
        %End NBairs block
    
        
    %----------------------------------------------------------------------
    %NBsubs block
        function obj = set.nNbsubs(obj,nNbsubs)
            if (isnan(nNbsubs) || isinf(nNbsubs) || mod(nNbsubs,1) ~= 0)
                error('nNbsubs must be real integer');
            end
            obj.nNbsubs = nNbsubs;
            
            if isempty(obj.nbsubs)
                obj.nbsubs = zeros(1,nNbsubs);
            elseif (length(obj.nbsubs) < nNbsubs)
                obj = obj.extendNNbsubs(nNbsubs);
            elseif (length(obj.nbsubs) > nNbsubs)
                obj = obj.contractNNbsubs(nNbsubs);
            end
            
            if isempty(obj.nbsubNames)
                obj.nbsubNames = cell(1,nNbsubs);
            elseif (length(obj.nbsubNames) < nNbsubs)
                obj = obj.extendNNbsubNames(nNbsubs);
            elseif (length(obj.nbsubNames) > nNbsubs)
                obj = obj.contractNNbsubNames(nNbsubs);
            end
            
            if isempty(obj.nbsubConstr)
                obj.nbsubConstr = cell(1,nNbsubs);            
            elseif (length(obj.nbsubConstr) < nNbsubs)
                obj = obj.extendNNbsubConstr(nNbsubs);
            elseif (length(obj.nbsubConstr) > nNbsubs)
               obj = obj.contractNNbsubConstr(nNbsubs);
            end     
            
        end
        
        
        function obj = set.nbsubs(obj,val)
            if (length(val) > obj.nNbsubs)
               error('Length of values vector must be <= nnbsubs');
            elseif (isnumeric(val) == false | isinteger(val) == true)
                error('Nbsubs must be vector of doubles');
            else        
               obj.nbsubs = val;
            end
        end
            
        function obj = set.nbsubNames(obj,val)
            if (length(val) > obj.nNbsubs)
               error('Length of nbsubNames vector must be <= nnbsubs');
            elseif (iscell(val) == false)
               error('nbsubNames must be cell array');
             else
               obj.nbsubNames = val;
            end
        end
        
        function obj = set.nbsubConstr(obj,val)
            if (length(val) > obj.nNbsubs)
                error('Length of poramConstr vector must be <= nNbsubs');
            elseif (iscell(val) == false)
                error('nbsubConstr must be cell array');
            else
                for i = 1:length(val)
                    thisVal = val{i};
                    if isempty(thisVal)
                        val{i} = [0  0];
                    elseif (~isnumeric(thisVal) || (size(thisVal,1)~=1 || size(thisVal,2)~=2) || isinteger(val))
                        error('value %d in assignment to nbsubConstr must be 1x2 double',i);
                    end
                end
            end
           
            obj.nbsubConstr = val;
        end
        %End NBsubs block

        
    %--------------------Contrasts-----------------------------------------
     function obj = set.numberOfContrasts(obj,nContrasts)
         
            if (isnan(nContrasts) || isinf(nContrasts) || mod(nContrasts,1) ~= 0)
                error('number of contrasts must be real integer');
            end
            obj.numberOfContrasts = nContrasts;
            
            if isempty(obj.allData)
                obj.allData = cell(1,nContrasts);
            elseif (length(obj.allData) < nContrasts)
                obj = obj.extendAllData(nContrasts);
            elseif (length(obj.allData) > nContrasts)
                obj = obj.contractAllData(nContrasts);
            end   
            
            if isempty(obj.dataLimits)
                obj.dataLimits = cell(1,nContrasts);            
            elseif (length(obj.dataLimits) < nContrasts)
                obj = obj.extendNDataLimits(nContrasts);
            elseif (length(obj.dataLimits) > nContrasts)
               obj = obj.contractNDataLimits(nContrasts);
            end
            
            if isempty(obj.simLimits)
                obj.simLimits = cell(1,nContrasts);            
            elseif (length(obj.simLimits) < nContrasts)
                obj = obj.extendNSimLimits(nContrasts);
            elseif (length(obj.simLimits) > nContrasts)
               obj = obj.contractNSimLimits(nContrasts);
            end   
            
            if isempty(obj.contrastBacks)
                obj.contrastBacks = ones(1,nContrasts);
            elseif (length(obj.contrastBacks) < nContrasts)
                obj = obj.extendNContrastBacks(nContrasts);
            elseif (length(obj.contrastBacks) > nContrasts)
               obj = obj.contractNContrastBacks(nContrasts);
            end  
            
            if isempty(obj.contrastShifts)
                obj.contrastShifts = ones(1,nContrasts);
            elseif (length(obj.contrastShifts) < nContrasts)
                obj = obj.extendNContrastShifts(nContrasts);
            elseif (length(obj.contrastShifts) > nContrasts)
               obj = obj.contractNContrastShifts(nContrasts);
            end  
            
            if isempty(obj.contrastScales)
                obj.contrastScales = ones(1,nContrasts);
            elseif (length(obj.contrastScales) < nContrasts)
                obj = obj.extendNContrastScales(nContrasts);
            elseif (length(obj.contrastScales) > nContrasts)
               obj = obj.contractNContrastScales(nContrasts);
            end  
            
            if isempty(obj.contrastNbas)
                obj.contrastNbas = ones(1,nContrasts);
            elseif (length(obj.contrastNbas) < nContrasts)
                obj = obj.extendNContrastNbas(nContrasts);
            elseif (length(obj.contrastNbas) > nContrasts)
               obj = obj.contractNContrastNbas(nContrasts);
            end 
            
            if isempty(obj.contrastNbss)
                obj.contrastNbss = ones(1,nContrasts);
            elseif (length(obj.contrastNbss) < nContrasts)
                obj = obj.extendNContrastNbss(nContrasts);
            elseif (length(obj.contrastNbss) > nContrasts)
               obj = obj.contractNContrastNbss(nContrasts);
            end 
 
            if isempty(obj.contrastRes)
                obj.contrastRes = ones(1,nContrasts);
            elseif (length(obj.contrastRes) < nContrasts)
                obj = obj.extendNContrastRes(nContrasts);
            elseif (length(obj.contrastRes) > nContrasts)
               obj = obj.contractNContrastRes(nContrasts);
            end 
            
            if isempty(obj.contrastLayers)
                obj.contrastLayers = cell(1,nContrasts);            
            elseif (length(obj.contrastLayers) < nContrasts)
                obj = obj.extendNContrastLayers(nContrasts);
            elseif (length(obj.contrastLayers) > nContrasts)
               obj = obj.contractNContrastLayers(nContrasts);
            end
            
            
     end
    
     function obj = set.allData(obj,val)
            if (length(val) > obj.numberOfContrasts)
                error('Number of datasets must be <= number Of Contrasts');
            elseif (iscell(val) == false)
                error('Each dataset must be a cell');
            else
                for i = 1:length(val)
                    thisVal = val{i};
                    if iscell(thisVal)
                        if length(thisVal) ~= 2
                            error('Call must be {''fname'' ''type''} pair');
                        end
                    elseif isnumeric(thisVal)
                        if isempty(thisVal)
                            val{i} = []; 
                        elseif (size(thisVal,2)<1 || size(thisVal,2)>4)
                            error('value %d in assignment to allData must be nx(1:4) double',i);
                        end
                    elseif isinteger(thisVal)
                        error('Numeric values of data cannot be integer');                     
                    end
                end
            end
            obj.allData = val;
      end
      
      function obj = set.dataLimits(obj,val)
            if (length(val) > obj.numberOfContrasts)
                error('Length of dataLimits array must be <= number of contrasts');
            elseif (iscell(val) == false)
                error('paramConstr must be cell array');
            else
                for i = 1:length(val)
                    thisVal = val{i};
                    if isempty(thisVal)
                        val{i} = [0  0];
                    elseif (~isnumeric(thisVal) || (size(thisVal,1)~=1 || size(thisVal,2)~=2) || isinteger(val))
                        error('value %d in assignment to dataLimits must be 1x2 double',i);
                    end
                end
            end
            obj.dataLimits = val;
      end
      
      function obj = set.simLimits(obj,val)
            if (length(val) > obj.numberOfContrasts)
                error('Length of simLimits array must be <= numbr of contrasts');
            elseif (iscell(val) == false)
                error('simLimits must be cell array');
            else
                for i = 1:length(val)
                    thisVal = val{i};
                    if isempty(thisVal)
                        val{i} = [0  0];
                    elseif (~isnumeric(thisVal) || (size(thisVal,1)~=1 || size(thisVal,2)~=2) || isinteger(val))
                        error('value %d in assignment to simLimits must be 1x2 double',i);
                    end
                end
            end
            obj.simLimits = val;
        end
     
        function obj = set.contrastBacks(obj,val)
            if (length(val) > obj.numberOfContrasts)
               error('Length of values vector must be <= numberOfContrasts');
            elseif (isnumeric(val) == false || any(mod(val,1)))
                error('backgrounds must be vector of integers');
            elseif (length(val) < obj.numberOfContrasts)
                error('Unindexed assignment - total length contrastBacks must = numberOfContrasts');
            else
               obj.contrastBacks = val;
            end
        end
      
        function obj = set.contrastShifts(obj,val)
            if (length(val) > obj.numberOfContrasts)
               error('Length of values vector must be <= numberOfContrasts');
            elseif (isnumeric(val) == false || any(mod(val,1)))
                error('contrast shifts must be vector of doubles');
            elseif (length(val) < obj.numberOfContrasts)
                error('Unindexed assignment - total length contrastShifts must = numberOfContrasts');
            else
               obj.contrastShifts = val;
            end
        end
        
        function obj = set.contrastScales(obj,val)
            if (length(val) > obj.numberOfContrasts)
               error('Length of values vector must be <= numberOfContrasts');
            elseif (isnumeric(val) == false || any(mod(val,1)))
                error('contrast scales must be vector of doubles');
            elseif (length(val) < obj.numberOfContrasts)
                error('Unindexed assignment - total length contrastScales must = numberOfContrasts');
            else
               obj.contrastScales = val;
            end
        end
        
        function obj = set.contrastNbas(obj,val)
            if (length(val) > obj.numberOfContrasts)
               error('Length of values vector must be <= numberOfContrasts');
            elseif (isnumeric(val) == false || any(mod(val,1)))
                error('contrast Nbas must be vector of doubles');
            elseif (length(val) < obj.numberOfContrasts)
                error('Unindexed assignment - total length contrastNbas must = numberOfContrasts');
            else
               obj.contrastNbas = val;
            end
        end
        
        function obj = set.contrastNbss(obj,val)
            if (length(val) > obj.numberOfContrasts)
               error('Length of values vector must be <= numberOfContrasts');
            elseif (isnumeric(val) == false || any(mod(val,1)))
                error('contrast Nbas must be vector of doubles');
            elseif (length(val) < obj.numberOfContrasts)
                error('Unindexed assignment - total length contrastNbss must = numberOfContrasts');
            else
               obj.contrastNbss = val;
            end
        end
        
        function obj = set.contrastRes(obj,val)
            if (length(val) > obj.numberOfContrasts)
               error('Length of values vector must be <= numberOfContrasts');
            elseif (isnumeric(val) == false || any(mod(val,1)))
                error('contrast Nbas must be vector of doubles');
            elseif (length(val) < obj.numberOfContrasts)
                error('Unindexed assignment - total length contrastRes must = numberOfContrasts');
            else
               obj.contrastRes = val;
            end
        end
   %--------------- End Contrasts Block ----------------------------------
   
   %Model Block
        
        function obj = set.modelType(obj,val)
             if ~ischar(val)
                 error('modelType must be char');
             end
             if ~any(strcmpi(val,{'Layers','Custom Layers','Custom XY'}))
                 error('modelType must be ''Layers'', ''Custom Layers'' or ''Custom XY'' ');
             end
             obj.modelType = val;
        end
        
        function obj = set.numberOfLayers(obj,val)
            nLayers = val;
            if (isnan(nLayers) || isinf(nLayers) || mod(nLayers,1) ~= 0)
                error('number of layers must be real integer');
            end
            obj.numberOfLayers = val;
        
            if isempty(obj.layersDetails)
                obj.layersDetails = cell(nLayers,1);
            elseif (size(obj.nLayers,1) < nLayers)
                obj = obj.extendNLayersDetails(nLayers);
            elseif (length(obj.nLayers,1) > nLayers)
                obj = obj.contractNLayersDetails(nLayers);
            end
        end
         
        function obj = set.layersDetails(obj,val)
            if (length(val) > obj.numberOfLayers)
                error('Length of layersDetails array must be <= number of layers');
            elseif (iscell(val) == false)
                error('layersDetails must be cell array');
            else
                for i = 1:length(val)
                    thisVal = val{i};
                    if isempty(thisVal)
                        val{i} = [1 1 1 0 1];
                    elseif (~isnumeric(thisVal) || size(thisVal,2)~=5 || sum(mod(thisVal,1))~=0)
                        error('value %d in assignment to layersDetails must be 1x5 integer',i);
                    end
                end
            end
            obj.layersDetails = val;  
        end
        
        function obj = set.modelFilename(obj,val)
            if ~ischar(val)
                error('model filename must be a char');
            end
            obj.modelFilename = val;
        end
        
        function obj = set.modelLanguage(obj,val)
           if ~strcmpi(val,{'matlab','python'})
               error('Model language must be ''matlab'' or ''python'' ');
           end
           obj.modelLanguage = val;
        end
        
    end %Public Methods end
   
    %-----------------------------------------------------------------------
    
    %Utility Functions.
    methods (Access = private) 
            
        
    %parameters 
        function obj = extendNParams(obj,val)
           currentLength = length(obj.params);
           new = zeros(1,(val-currentLength));
           new = [obj.params,new];
           obj.params = new;
        end
        
        function obj = contractNParams(obj,val)
           obj.params = obj.params(1:val);
        end
        
        function obj = extendNParamNames(obj,val)
           currentLength = length(obj.paramNames);
           new = cell([1,(val-currentLength)]);
           new = horzcat([obj.paramNames],new);
           obj.paramNames = new;
        end
        
        function obj = contractNParamNames(obj,val)
           obj.paramNames = obj.paramNames(1:val);
        end
        
        function obj = extendNParamConstr(obj,val)
           currentLength = length(obj.paramConstr);
           new = cell([1,(val-currentLength)]);
           new(:) = {[0 0]};
           new = horzcat([obj.paramConstr],new);
           obj.paramConstr = new;
        end
        
        function obj = contractNParamConstr(obj,val)
            obj.paramConstr = obj.paramConstr(1:val);
        end
        
        
     %Backgrounds
        function obj = extendNBackgrounds(obj,val)
           currentLength = length(obj.backgrounds);
           new = zeros(1,(val-currentLength));
           new = [obj.backgrounds,new];
           obj.backgrounds = new;
        end
        
        function obj = contractNBackgrounds(obj,val)
           obj.backgrounds = obj.backgrounds(1:val);
        end
        
        function obj = extendNBackgroundNames(obj,val)
           currentLength = length(obj.backgroundNames);
           new = cell([1,(val-currentLength)]);
           new = horzcat([obj.backgroundNames],new);
           obj.backgroundNames = new;
        end
        
        function obj = contractNBackgroundNames(obj,val)
           obj.backgroundNames = obj.backgroundNames(1:val);
        end
        
        function obj = extendNBackgroundConstr(obj,val)
           currentLength = length(obj.backgroundConstr);
           new = cell([1,(val-currentLength)]);
           new(:) = {[0 0]};
           new = horzcat([obj.backgroundConstr],new);
           obj.backgroundConstr = new;
        end
        
        function obj = contractNBackgroundConstr(obj,val)
            obj.backgroundConstr = obj.backgroundConstr(1:val);
        end
          
     %Scalefactors
        function obj = extendNScalefactors(obj,val)
           currentLength = length(obj.scalefactors);
           new = zeros(1,(val-currentLength));
           new = [obj.scalefactors,new];
           obj.scalefactors = new;
        end
        
        function obj = contractNScalefactors(obj,val)
           obj.scalefactors = obj.scalefactors(1:val);
        end
        
        function obj = extendNScalefactorNames(obj,val)
           currentLength = length(obj.scalefactorNames);
           new = cell([1,(val-currentLength)]);
           new = horzcat([obj.scalefactorNames],new);
           obj.scalefactorNames = new;
        end
        
        function obj = contractNScalefactorNames(obj,val)
           obj.scalefactorNames = obj.scalefactorNames(1:val);
        end
        
        function obj = extendNScalefactorConstr(obj,val)
           currentLength = length(obj.scalefactorConstr);
           new = cell([1,(val-currentLength)]);
           new(:) = {[0 0]};
           new = horzcat([obj.scalefactorConstr],new);
           obj.scalefactorConstr = new;
        end
        
        function obj = contractNScalefactorConstr(obj,val)
            obj.scalefactorConstr = obj.scalefactorConstr(1:val);
        end

        
    %QZ shifts
        function obj = extendNQzshifts(obj,val)
           currentLength = length(obj.qzshifts);
           new = zeros(1,(val-currentLength));
           new = [obj.qzshifts,new];
           obj.qzshifts = new;
        end
        
        function obj = contractNQzshifts(obj,val)
           obj.qzshifts = obj.qzshifts(1:val);
        end
        
        function obj = extendNQzshiftNames(obj,val)
           currentLength = length(obj.qzshiftNames);
           new = cell([1,(val-currentLength)]);
           new = horzcat([obj.qzshiftNames],new);
           obj.qzshiftNames = new;
        end
        
        function obj = contractNQzshiftNames(obj,val)
           obj.qzshiftNames = obj.qzshiftNames(1:val);
        end
        
        function obj = extendNQzshiftConstr(obj,val)
           currentLength = length(obj.qzshiftConstr);
           new = cell([1,(val-currentLength)]);
           new(:) = {[0 0]};
           new = horzcat([obj.qzshiftConstr],new);
           obj.qzshiftConstr = new;
        end
        
        function obj = contractNQzshiftConstr(obj,val)
            obj.qzshiftConstr = obj.qzshiftConstr(1:val);
        end
    
    %nbairs
        function obj = extendNNbairs(obj,val)
           currentLength = length(obj.nbairs);
           new = zeros(1,(val-currentLength));
           new = [obj.nbairs,new];
           obj.nbairs = new;
        end
        
        function obj = contractNNbairs(obj,val)
           obj.nbairs = obj.nbairs(1:val);
        end
        
        function obj = extendNNbairNames(obj,val)
           currentLength = length(obj.nbairNames);
           new = cell([1,(val-currentLength)]);
           new = horzcat([obj.nbairNames],new);
           obj.nbairNames = new;
        end
        
        function obj = contractNNbairNames(obj,val)
           obj.nbairNames = obj.nbairNames(1:val);
        end
        
        function obj = extendNNbairConstr(obj,val)
           currentLength = length(obj.nbairConstr);
           new = cell([1,(val-currentLength)]);
           new(:) = {[0 0]};
           new = horzcat([obj.nbairConstr],new);
           obj.nbairConstr = new;
        end
        
        function obj = contractNNbairConstr(obj,val)
            obj.nbairConstr = obj.nbairConstr(1:val);
        end
        
        
    %nbsubs
        function obj = extendNNbsubs(obj,val)
           currentLength = length(obj.nbsubs);
           new = zeros(1,(val-currentLength));
           new = [obj.nbsubs,new];
           obj.nbsubs = new;
        end
        
        function obj = contractNNbsubs(obj,val)
           obj.nbsubs = obj.nbsubs(1:val);
        end
        
        function obj = extendNNbsubNames(obj,val)
           currentLength = length(obj.nbsubNames);
           new = cell([1,(val-currentLength)]);
           new = horzcat([obj.nbsubNames],new);
           obj.nbsubNames = new;
        end
        
        function obj = contractNNbsubNames(obj,val)
           obj.nbsubNames = obj.nbsubNames(1:val);
        end
        
        function obj = extendNNbsubConstr(obj,val)
           currentLength = length(obj.nbsubConstr);
           new = cell([1,(val-currentLength)]);
           new(:) = {[0 0]};
           new = horzcat([obj.nbsubConstr],new);
           obj.nbsubConstr = new;
        end
        
        function obj = contractNNbsubConstr(obj,val)
            obj.nbsubConstr = obj.nbsubConstr(1:val);
        end
        
%--------------------------------------------------------------------------
    %Data and contrasts
        function obj = extendAllData(obj,val)
           currentLength = length(obj.allData);
           new = cell([1,(val-currentLength)]);
           new(:) = {[]};
           new = horzcat([obj.allData],new);
           obj.allData = new;
        end
        
        function obj = contractAllData(obj,val)
            obj.allData = obj.allData(1:val);
        end

        function obj = extendNDataLimits(obj,val)
           currentLength = length(obj.dataLimits);
           new = cell([1,(val-currentLength)]);
           new(:) = {[0 0]};
           new = horzcat([obj.dataLimits],new);
           obj.dataLimits = new;
        end
        
        function obj = contractNDataLimits(obj,val)
            obj.dataLimits = obj.dataLimits(1:val);
        end
        
        function obj = extendNSimLimits(obj,val)
           currentLength = length(obj.simLimits);
           new = cell([1,(val-currentLength)]);
           new(:) = {[0 0]};
           new = horzcat([obj.simLimits],new);
           obj.simLimits = new;
        end
        
        function obj = contractNSimLimits(obj,val)
            obj.simLimits = obj.simLimits(1:val);
        end
        
        function obj = extendNContrastBacks(obj,val)
           currentLength = length(obj.contrastBacks);
           new = ones([1,(val-currentLength)]);
           new = horzcat([obj.contrastBacks],new);
           obj.contrastBacks = new;
        end
        
        function obj = contractNContrastBacks(obj,val)
            obj.contrastBacks = obj.contrastBacks(1:val);
        end
        
        function obj = extendNContrastShifts(obj,val)
           currentLength = length(obj.contrastShifts);
           new = ones([1,(val-currentLength)]);
           new = horzcat([obj.contrastShifts],new);
           obj.contrastShifts = new;
        end
        
        function obj = contractNContrastShifts(obj,val)
            obj.contrastShifts = obj.contrastShifts(1:val);
        end
        
        function obj = extendNContrastScales(obj,val)
           currentLength = length(obj.contrastScales);
           new = ones([1,(val-currentLength)]);
           new = horzcat([obj.contrastScales],new);
           obj.contrastShifts = new;
        end
        
        function obj = contractNContrastScales(obj,val)
            obj.contrastScales = obj.contrastScales(1:val);
        end
        
        function obj = extendNContrastNbas(obj,val)
           currentLength = length(obj.contrastNbas);
           new = ones([1,(val-currentLength)]);
           new = horzcat([obj.contrastNbas],new);
           obj.contrastNbas = new;
        end
        
        function obj = contractNContrastNbas(obj,val)
            obj.contrastNbas = obj.contrastNbas(1:val);
        end
        
        function obj = extendNContrastNbss(obj,val)
           currentLength = length(obj.contrastNbss);
           new = ones([1,(val-currentLength)]);
           new = horzcat([obj.contrastNbss],new);
           obj.contrastNbss = new;
        end
        
        function obj = contractNContrastNbss(obj,val)
            obj.contrastNbas = obj.contrastNbss(1:val);
        end
        
        function obj = extendNContrastNRes(obj,val)
           currentLength = length(obj.contrastRes);
           new = ones([1,(val-currentLength)]);
           new = horzcat([obj.contrastRes],new);
           obj.contrastNbss = new;
        end
        
        function obj = contractNContrastRes(obj,val)
            obj.contrastRes = obj.contrastRes(1:val);
        end
%-----------------------------------------------------------------------
%Model
        function obj = extendNLayersDetails(obj,val)
            currentLength = size(obj.layersDetails,1);
            new = cell((val-currentLength),1);
            new(:) = {[1 1 1 0 1]};
            new = vercat(obj.layersDetails,new);
            obj.layersDetails = new;
        end
      
        function obj = extendNContrastLayers(obj,val)
           currentLength = length(obj.contrastLayers);
           new = cell([1,(val-currentLength)]);
           new(:) = {[]};
           new = vercat([obj.contrastLayers],new);
           obj.contrastLayers = new;
        end
        
        function obj = contractNContrastLayers(obj,val)
            obj.contrastLayers = obj.contrastLayers(1:val);
        end
                 
    end     %End Private Methods
    
%-------------------------------------------------------------------------

%Display Methods
methods (Access = protected)
    
    function groups = getPropertyGroups(obj)
        
               masterPropList = struct(  'experimentType', obj.experimentType,...
                     'experimentGeometry', obj.experimentGeometry    ,...
                     'nParams', obj.nParams,...
                     'params', {obj.params},...
                     'paramNames', {obj.paramNames},...
                     'paramConstr', {obj.paramConstr},...
                     'nBackgrounds', obj.nBackgrounds,...
                     'backgrounds', {obj.backgrounds},...
                     'backgroundNames', {obj.backgroundNames},...
                     'backgroundConstr', {obj.backgroundConstr},...
                     'nScalefactors', obj.nScalefactors,...
                     'scalefactors', {obj.scalefactors},...
                     'scalefactorNames', {obj.scalefactorNames},...
                     'scalefactorConstr', {obj.scalefactorConstr},...
                     'nQzshifts', obj.nQzshifts,...
                     'qzshifts', {obj.qzshifts},...
                     'qzshiftNames', {obj.qzshiftNames},...
                     'qzshiftConstr', {obj.qzshiftConstr},...
                     'nNbairs', obj.nNbairs,...
                     'nbairs', {obj.nbairs},...
                     'nbairNames', {obj.nbairNames},...
                     'nbairConstr', {obj.nbairConstr},...       
                     'nNbsubs', obj.nNbsubs,...
                     'nbsubs', {obj.nbsubs},...
                     'nbsubNames', {obj.nbsubNames},...
                     'nbsubConstr', {obj.nbsubConstr},...   
                     'numberOfContrasts', obj.numberOfContrasts,...
                     'allData', {obj.allData},...
                     'dataLimits', {obj.dataLimits},...
                     'simLimits', {obj.simLimits},...
                     'contrastBacks', {obj.contrastBacks},...
                     'contrastShifts', {obj.contrastShifts},...
                     'contrastScales', {obj.contrastScales},...
                     'contrastNbas', {obj.contrastNbas},...
                     'contrastNbss', {obj.contrastNbss},...
                     'contrastRes', {obj.contrastRes},...
                     'modelType', obj.modelType,...
                     'numberOfLayers', obj.numberOfLayers,...
                     'layersDetails', {obj.layersDetails},...
                     'contrastLayers', {obj.contrastLayers},...
                     'modelFilename', obj.modelFilename,...
                     'modelLanguage', obj.modelLanguage);
         if isscalar(obj)        
                 if strcmpi(obj.experimentGeometry,'substrate/liquid')
                     dispPropList = masterPropList;
                 elseif strcmpi(obj.experimentGeometry,'air/substrate')
                     dispPropList = rmfield(masterPropList,{'nNbairs','nbairs','nbairNames','nbairConstr'});
                 end
                 
                 if ~strcmpi(obj.modelType,'layers')
                     dispPropList = rmfield(dispPropList,{'numberOfLayers','layersDetails','contrastLayers'});
                 else
                     dispPropList = rmfield(dispPropList,{'modelFilename','modelLanguage'});
                 end
       
                 if ~isempty(dispPropList)
                     groups = matlab.mixin.util.PropertyGroup(dispPropList);
                 else
                     groups = matlab.mixin.util.PropertyGroup(masterPropList);
                 end
        else
            groups = getPropertyGroups@matlab.mixin.CustomDisplay(obj);
        end       
    
    
    
    end
    
end     %End display methods
    
end     %End ClassDef
        
 

        