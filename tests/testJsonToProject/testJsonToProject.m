classdef testJsonToProject < matlab.unittest.TestCase

    properties
        input
        expected
    end

    properties (TestParameter)
        file = {'absorption', ...
            'domains_custom_layers', ...
            'domains_custom_XY', ...
            'domains_standard_layers', ...
            'DSPC_custom_layers', ...
            'DSPC_custom_XY', ...
            'DSPC_standard_layers'}

        resultFile = {'result', ...
            'result_bayes'}

        controlsParams = {{'calculate', 'numSimulationPoints', 100},...
                          {'simplex' 'xTolerance', 19},...
                          {'de' 'populationSize', 200},...
                          {'ns' 'nLive', 19},...
                          {'dream' 'nSamples', 200}}
        r2Tests = {{'normalReflectivity', 'standardLayers', 'standardLayersDSPCScript'},...
                   {'domains', 'customLayers', 'domainsCustomLayersScript'},...
                   {'domains', 'customXY', 'domainsCustomXYScript'}}
    end

    methods(TestClassSetup)
        function addDataPath(testCase)
            import matlab.unittest.fixtures.PathFixture
            path = fullfile(getappdata(0, 'root'), 'tests', 'testJsonToProject');
            testCase.applyFixture(PathFixture(path));
        end
        function setWorkingFolder(testCase)
            import matlab.unittest.fixtures.WorkingFolderFixture;
            testCase.applyFixture(WorkingFolderFixture);
        end
    end

    % test that JSON to Project successfully converts projects
    methods (Test)
        function testJsonConversion(testCase, file)
            project = jsonToProject(append(file, ".json"));
            projectToJson(project, "test.json");
            project2 = jsonToProject("test.json");

            props = properties(project);
            for i = 1:length(props)
                testCase.verifyEqual(project.(props{i}), project2.(props{i}));
            end
        end

       function testJsonResultConversion(testCase, resultFile)
            result = jsonToResults(append(resultFile, ".json"));
            resultsToJson(result, "test.json");
            result2 = jsonToResults("test.json");

            props = properties(result);
            for i = 1:length(props)
                testCase.verifyEqual(result.(props{i}), result2.(props{i}));
            end
       end

       function testJsonControlsConversion(testCase, controlsParams)
            controls = controlsClass();
            controls.setProcedure(controlsParams{1}, controlsParams{2:end});

            controlsToJson(controls, "test.json");
            controls2 = jsonToControls("test.json");

            props = properties(controls);
            for i = 1:length(props)
                testCase.verifyEqual(controls.(props{i}), controls2.(props{i}));
            end
       end

       function testR2Conversion(testCase, r2Tests)
            scriptName = r2Tests{3};
            outFolder = ['save_' scriptName];
           
            copyfile(fullfile(getappdata(0, 'root'), 'examples', r2Tests{1}, r2Tests{2}), ...
                     fullfile(pwd))
            evalc(scriptName);
            
            controls = controlsClass();
            [~, project, result] =  evalc('RAT(problem, controls);');

            saveR2(outFolder,  project, result, controls)
            testCase.verifyEqual(exist(fullfile(pwd, outFolder, 'results.json'), 'file'), 2)
            testCase.verifyEqual(exist(fullfile(pwd, outFolder, 'project.json'), 'file'), 2)
            testCase.verifyEqual(exist(fullfile(pwd, outFolder, 'controls.json'), 'file'), 2)
            for i=1:project.customFile.rowCount
                customFile = project.customFile.varTable{i, 2};
                testCase.verifyEqual(exist(fullfile(pwd, outFolder, customFile), 'file'), 2)
            end

            [project2, result2] = loadR2(outFolder);
            props = properties(project);
            for i = 1:length(props)
                % verifies the problem name, model type and geometry
                testCase.verifyEqual(project.experimentName, project2.experimentName);
                testCase.verifyEqual(project.modelType, project2.modelType);
                testCase.verifyEqual(project.geometry, project2.geometry);
    
                % verifies the count of problem properties
                testCase.verifyEqual(project.contrasts.numberOfContrasts, project2.contrasts.numberOfContrasts);
                testCase.verifyEqual(project.parameters.rowCount, project2.parameters.rowCount);
                testCase.verifyEqual(project.bulkOut.rowCount, project2.bulkOut.rowCount);
                testCase.verifyEqual(project.background.backgrounds.rowCount, project2.background.backgrounds.rowCount);
                testCase.verifyEqual(project.data.rowCount, project2.data.rowCount);
                testCase.verifyEqual(project.scalefactors.rowCount, project2.scalefactors.rowCount);
                if isa(project.layers, 'layersClass')
                    testCase.verifyEqual(project.layers.rowCount, project2.layers.rowCount);
                end
                testCase.verifyEqual(project.bulkIn.rowCount, project2.bulkIn.rowCount);
            end

            props = properties(result);
            for i = 1:length(props)
                testCase.verifyEqual(result.(props{i}), result2.(props{i}));
            end
            close all
        end
    end

end