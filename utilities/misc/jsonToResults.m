
function results = jsonToResults(filename)

% Loads in the results from a json results file, and converts it so the
% format required for matlabRAT. The conversion mainly means converting
% flattened array back to cells..

% Load in the json array
[path,filename,~] = fileparts(filename);
file = fullfile(path, append(filename, '.json'));
jsonRes = jsondecode(fileread(file));

% Go through converting all arrays to cells (where the arrays have been
% squeezed). If they are already cells, the subfunctions will just keep the
% original..
results.reflectivity = simArray2Cells(jsonRes.reflectivity);
results.simulation = simArray2Cells(jsonRes.simulation);
results.shiftedData = dataArray2Cells(jsonRes.shiftedData);
results.backgrounds = simArray2Cells(jsonRes.backgrounds);
results.resolutions = simArray2Cells(jsonRes.resolutions);
results.sldProfiles = sldArray2Cells(jsonRes.sldProfiles);
results.layers = sldArray2Cells(jsonRes.layers);    % Layers array is in the same format as the SLDs
results.resampledLayers = sldArray2Cells(jsonRes.resampledLayers);

% These correctly load in as structs or arrays....
results.calculationResults = jsonRes.calculationResults;
results.contrastParams = jsonRes.contrastParams;
results.fitParams = jsonRes.fitParams';
results.fitNames = jsonRes.fitNames;

% contrastParams.resample has the wrong shape...
results.contrastParams.resample = results.contrastParams.resample';

% If we have Bayes results, we have extra work to do....
if isfield(jsonRes,'predictionIntervals')
    results.predictionIntervals = jsonRes.predictionIntervals;
    results.predictionIntervals.reflectivity = simArray2Cells(results.predictionIntervals.reflectivity);
    results.predictionIntervals.sld = sldArray2Cells(results.predictionIntervals.sld);
    
    results.confidenceIntervals = jsonRes.confidenceIntervals;
    results.dreamParams = jsonRes.dreamParams;
    results.dreamOutput = jsonRes.dreamOutput;
    results.nestedSamplerOutput = jsonRes.nestedSamplerOutput;
    results.chain = jsonRes.chain;
end

end


% ----------------------------------------------------------

function outCell = sldArray2Cells(inArray)

% Check we don't already have cells..
if iscell(inArray)
    row = size(inArray, 1); 
    if iscell(inArray{1})
        col = size(inArray{1}, 1);
    else
        col = size(inArray(1),1);
    end
    outCell = cell(row, col);
    for i=1:row
        for j=1:col
            outCell{i, j} = squeeze(inArray{i}{j});
        end
    end
else
    dims = size(inArray);
    row = dims(1);
    col = dims(2);
    outCell = cell(row, col);
    for i=1:row
        for j=1:col
            outCell{i, j} = reshape(inArray(i, j, :, :), dims(3:end));
        end
    end
end
end

% --------------------------------------------------------------

function outCell = dataArray2Cells(inArray)

% Check we don't already have cells..
if iscell(inArray)
    outCell = reshape(inArray,numel(inArray),1);
else

    % Get number of profiles...
    nProfiles = size(inArray,1);

    for i = 1:nProfiles
        thisDat = inArray(i,:,:,:);
        thisDat = squeeze(thisDat); % Collapse singleton dims....
        outCell{i,1} = thisDat;
    end
end

end

% --------------------------------------------------------------

function outCell = simArray2Cells(inArray)

% Check we don't already have cells..
if iscell(inArray)
    outCell = inArray;
else
    % Get 3rd dimension of array...
    dims = size(inArray,1);

    for i = 1:dims
        thisArray = inArray(i,:,:);
        outCell{i,1} = squeeze(thisArray);
    end
end

end

% ----------------------------------------------------------