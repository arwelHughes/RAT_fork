
function resultsToJson(results,filename)

% Encodes the results into a json file...
tmpResults = struct();
for fn = fieldnames(results)'
   tmpResults.(fn{1}) = results.(fn{1});
end

tmpResults.reflectivity = correctCellArray(tmpResults.reflectivity);
tmpResults.simulation = correctCellArray(tmpResults.simulation);
tmpResults.shiftedData = correctCellArray(tmpResults.shiftedData);
tmpResults.backgrounds = correctCellArray(tmpResults.backgrounds);
tmpResults.resolutions = correctCellArray(tmpResults.resolutions );
tmpResults.sldProfiles = makeCellJson(tmpResults.sldProfiles);
tmpResults.layers = makeCellJson(tmpResults.layers);
tmpResults.resampledLayers = makeCellJson(tmpResults.resampledLayers);

encoded = jsonencode(tmpResults,ConvertInfAndNaN=false);
encoded = strrep(encoded, '"[', '[');
encoded = strrep(encoded, ']"', ']');


[path,filename,~] = fileparts(filename);
fid = fullfile(path, append(filename, '.json'));
fid = fopen(fid,'w');
fprintf(fid,'%s',encoded);
fclose(fid);

end

function outputArray = makeCellJson(cellArray)
    % The jsonencode function flattens 2d cell arrays this is a workaround to
    % avoid flattening by converting to a string array with is not flattened. 
    [row, col] = size(cellArray, [1, 2]);
    outputArray = strings([row, col]);
    for i=1:row
        for j=1:col
            entry = cellArray{i, j};
            if size(entry, 1) == 1
                entry = {entry};
            end
            if col == 1
                entry = {entry};
            end
            outputArray(i, j) = jsonencode(entry);
        end
    end
    if row == 1
        outputArray = {outputArray};
    end

end

function cellArray = correctCellArray(cellArray)
    % Corrects array with single row so its written as 2D array in json 
    [row, col] = size(cellArray, [1, 2]);
    for i=1:row
        for j=1:col
            if size(cellArray{i, j}, 1) == 1
               cellArray{i, j} = {cellArray{i, j}};
            end
        end
    end
end