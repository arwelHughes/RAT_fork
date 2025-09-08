function runFromPython(projectFilename,controlsFilename,updateFilename)

% This function runs a projectClass natively in matlabRAT. 


% Load in the project and controls....
problem = jsonToProject(projectFilename);
controls = jsonToControls(controlsFilename);

% Divert the output to a file....
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
% delete projectFilename controlsFilename

end