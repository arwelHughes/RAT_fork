function [backgroundParams,qzshifts,scalefactors,bulkIns,bulkOuts,...
    resolutionParams,chis,reflectivity,simulation,shiftedData,layerSlds,...
    sldProfiles,resampledLayers,subRoughs] = customLayers(problemStruct,problemCells,controls)
    % The custom layers, nonPolarisedTF reflectivity calculation.
    % The function extracts the relevant parameters from the input arrays,
    % allocates these on a pre-contrast basis, then calls the 'core' 
    % calculation (the core layers nonPolarisedTF calc is shared between
    % multiple calculation types).
    
    % Extract individual cell arrays
    [repeatLayers,...
     data,...
     dataLimits,...
     simLimits,...
     ~,~,customFiles] = parseCells(problemCells);
    
    % Extract individual parameters from problemStruct
    [numberOfContrasts, geometry, contrastBackgroundIndices, contrastQzshiftIndices,...
     contrastScalefactorIndices, contrastBulkInIndices, contrastBulkOutIndices,...
     contrastResolutionParamIndices, ~, backgroundParamArray, qzshiftArray,...
     scalefactorArray, bulkInArray, bulkOutArray, resolutionParamArray, ~,...
     dataPresent, nParams, params, ~, resample, contrastBackgroundActions, cCustFiles,...
     useImaginary] = extractProblemParams(problemStruct);

    calcSld = controls.calcSldDuringFit;
    parallel = controls.parallel;
    resampleParams = controls.resampleParams;
                         
    % Pre-Allocation of output arrays...
    backgroundParams = zeros(numberOfContrasts,1);
    qzshifts = zeros(numberOfContrasts,1);
    scalefactors = zeros(numberOfContrasts,1);
    bulkIns = zeros(numberOfContrasts,1);
    bulkOuts = zeros(numberOfContrasts,1);
    resolutionParams = zeros(numberOfContrasts,1);
    subRoughs = zeros(numberOfContrasts,1);
    chis = zeros(numberOfContrasts,1);
    layerSlds = cell(numberOfContrasts,1);
    sldProfiles = cell(numberOfContrasts,1);
    shiftedData = cell(numberOfContrasts,1);
    
    reflectivity = cell(numberOfContrasts,1);
    for i = 1:numberOfContrasts
        reflectivity{i} = [1 1; 1 1];
    end
    
    simulation = cell(numberOfContrasts,1);
    for i = 1:numberOfContrasts
        simulation{i} = [1 1; 1 1];
    end
    
    resampledLayers = cell(numberOfContrasts,1);
    for i = 1:numberOfContrasts
        resampledLayers{i} = [1; 1];
    end
    
    %   --- End Memory Allocation ---
    
    % Process the custom models
    [resampledLayers,subRoughs] = nonPolarisedTF.customLayers.processCustomFunction(contrastBulkInIndices,contrastBulkOutIndices,...
        bulkInArray,bulkOutArray,cCustFiles,numberOfContrasts,customFiles,params,useImaginary);
    
    if strcmpi(parallel, coderEnums.parallelOptions.Contrasts)
    
        % Multi cored over all contrasts
        parfor i = 1:numberOfContrasts
            
            [backgroundParams(i),qzshifts(i),scalefactors(i),bulkIns(i),...
             bulkOuts(i),resolutionParams(i),chis(i),reflectivity{i},...
             simulation{i},shiftedData{i},layerSlds{i},sldProfiles{i},...
             resampledLayers{i}...
             ] = contrastCalculation(contrastBackgroundIndices(i),...
             contrastQzshiftIndices(i),contrastScalefactorIndices(i),...
             contrastBulkInIndices(i),contrastBulkOutIndices(i),...
             contrastResolutionParamIndices(i),backgroundParamArray,qzshiftArray,...
             scalefactorArray,bulkInArray,bulkOutArray,resolutionParamArray,...
             dataPresent(i),data{i},dataLimits{i},simLimits{i},repeatLayers{i},...
             contrastBackgroundActions(i),nParams,parallel,resampleParams,...
             useImaginary,resample(i),geometry,subRoughs(i),calcSld,...
             resampledLayers{i});
        
        end
    
    else
    
        % Single cored over all contrasts
        for i = 1:numberOfContrasts

            [backgroundParams(i),qzshifts(i),scalefactors(i),bulkIns(i),...
             bulkOuts(i),resolutionParams(i),chis(i),reflectivity{i},...
             simulation{i},shiftedData{i},layerSlds{i},sldProfiles{i},...
             resampledLayers{i}...
             ] = contrastCalculation(contrastBackgroundIndices(i),...
             contrastQzshiftIndices(i),contrastScalefactorIndices(i),...
             contrastBulkInIndices(i),contrastBulkOutIndices(i),...
             contrastResolutionParamIndices(i),backgroundParamArray,qzshiftArray,...
             scalefactorArray,bulkInArray,bulkOutArray,resolutionParamArray,...
             dataPresent(i),data{i},dataLimits{i},simLimits{i},repeatLayers{i},...
             contrastBackgroundActions(i),nParams,parallel,resampleParams,...
             useImaginary,resample(i),geometry,subRoughs(i),calcSld,...
             resampledLayers{i});

        end
    
    end

end


function [backgroundParamValue,qzshiftValue,scalefactorValue,bulkInValue,...
    bulkOutValue,resolutionParamValue,chi,reflectivity,simulation,shiftedData,...
    layerSld,sldProfile,resampledLayer] = contrastCalculation(backgroundParamIndex,...
    qzshiftIndex,scalefactorIndex,bulkInIndex,bulkOutIndex,resolutionParamIndex,...
    backgroundParams,qzshifts,scalefactors,bulkIns,bulkOuts,resolutionParams,...
    dataPresent,data,dataLimits,simLimits,repeatLayers,contrastBackgroundActions,...
    nParams,parallel,resampleParams,useImaginary,resample,geometry,roughness,...
    calcSld,layer)

    % Extract the relevant parameter values for this contrast
    % from the input arrays.
    % First need to decide which values of the backgrounds, scalefactors
    % data shifts and bulk contrasts are associated with this contrast
    [backgroundParamValue,qzshiftValue,scalefactorValue,bulkInValue,bulkOutValue,...
     resolutionParamValue] = backSort(backgroundParamIndex,qzshiftIndex,...
     scalefactorIndex,bulkInIndex,bulkOutIndex,resolutionParamIndex,...
     backgroundParams,qzshifts,scalefactors,bulkIns,bulkOuts,resolutionParams);
        
    % Call the core layers calculation
    [sldProfile,reflectivity,simulation,shiftedData,layerSld,resampledLayer,...
     chi] = nonPolarisedTF.coreLayersCalculation(layer,roughness,...
     geometry,bulkInValue,bulkOutValue,resample,calcSld,scalefactorValue,qzshiftValue,...
     dataPresent,data,dataLimits,simLimits,repeatLayers,backgroundParamValue,...
     resolutionParamValue,contrastBackgroundActions,nParams,parallel,resampleParams,useImaginary);

end
