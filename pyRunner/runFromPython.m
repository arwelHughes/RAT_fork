function runFromPython(projectFilename,controlsFilename,updateFilename)

% This function runs a projectClass natively in matlabRAT. 
% controlsFilename - The controls class json
% projectFileName - The project class json..
% updateFileName - the events output file (maybe just keep as a default)


% Load in the project and controls....
problem = jsonToProject(projectFilename);
controls = jsonToControls(controlsFilename);

% Divert the events output output to a file....
% TODO....

% Run the project....
[problem,results] = RAT(problem,controls);

% Save the results....
[~,projectName,~] = fileparts(projectFilename);

fullProjectSaveFilename = strcat(projectName,'_project_updated.json');
fullResultsSaveFilename = strcat(projectName,'_results.json');

projectToJson(problem,fullProjectSaveFilename);
resultsToJson(results,fullResultsSaveFilename);

% Clean up...
% delete the temporary files. TODO

end