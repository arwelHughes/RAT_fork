function runFromPython(projectFilename,controlsFilename,updateFilename)

% This function runs a projectClass natively in matlabRAT. 
% controlsFilename - The controls class json
% projectFileName - The project class json..
% updateFileName - the events output file (maybe just keep as a default)


% Load in the project and controls....
problem = jsonToProject(projectFilename);
controls = jsonToControls(controlsFilename);

% Divert the events output to a file
if nargin < 3 || isempty(updateFilename)
    updateFilename = 'events.log';
end

% Open file for writing events
eventFileID = fopen(updateFilename, 'w');
if eventFileID == -1
    warning('Could not open events file for writing');
    eventFileID = [];
end

% Register event handlers to write to file
if ~isempty(eventFileID)
    eventManager.register(coderEnums.eventTypes.Message, @writeMessageToFile);
    eventManager.register(coderEnums.eventTypes.Progress, @writeProgressToFile);
end

% Run the project....
[problem,results] = RAT(problem,controls);

% Save the results....
[~,projectName,~] = fileparts(projectFilename);

fullProjectSaveFilename = strcat(projectName,'_project_updated.json');
fullResultsSaveFilename = strcat(projectName,'_results.json');

projectToJson(problem,fullProjectSaveFilename);
resultsToJson(results,fullResultsSaveFilename);

% Close event file
if ~isempty(eventFileID)
    fclose(eventFileID);
end

% Clean up...
% delete the temporary files. TODO

    function writeMessageToFile(message)
        if ~isempty(eventFileID)
            fprintf(eventFileID, 'MESSAGE: %s\n', message);
        end
    end

    function writeProgressToFile(progressType, progressValue)
        if ~isempty(eventFileID)
            fprintf(eventFileID, 'PROGRESS: %s - %.2f\n', progressType, progressValue);
        end
    end

end