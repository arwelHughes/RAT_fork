 classdef testBackgroundsClass < matlab.unittest.TestCase   
    
   properties
      parameters
      backgrounds
      background
      names
   end

   methods(TestMethodSetup)
      function createBackground(testCase)
         params = parametersClass(testCase.parameters{1, :});
         testCase.background = backgroundsClass(params, testCase.backgrounds(1, :), testCase.names);
      end
   end

   methods(TestClassSetup)
      function createBackgrounds(testCase)
         testCase.parameters = {
                  % Name               min   val   max  fit? 'Prior Type','mu','sigma'
                  'background param 1', 0.01, 0.03, 0.05, false, priorTypes.Uniform.value, 0, Inf;
                  'background param 2', 0.1, 0.19, 1.0, true, priorTypes.Gaussian.value, -1, 1;
                  'background param 3', 0.2, 0.17, 1.1, false, priorTypes.Uniform.value, 0, Inf;
                  };
         testCase.backgrounds = {
                  'background 1', allowedTypes.Constant.value, 'background param 1', '', '', '', '', '';
                  'background 2', allowedTypes.Constant.value, 'background param 2', '', '', '', '', '';
                  'background 3', allowedTypes.Function.value, 'function_name', 'background param 1', 'background param 2', '', '', '';
                  'background 4', allowedTypes.Data.value, 'data_name', '', '', '', '', '';
                  };
      end

      function createTestNames(testCase)
          testCase.names.customFileNames = "function_name";
          testCase.names.dataNames = "data_name";
      end
   end

   methods (Test)
      function testCreation(testCase)
         % Tests background class can be created and the start parameters is set correctly
         params = parametersClass(testCase.parameters{1, :});
         params.varTable = [params.varTable; vertcat(testCase.parameters(2:end, :))];
         
         testBackground = backgroundsClass(params, testCase.backgrounds(1, :), testCase.names);
         
         testCase.verifyEqual(string(testBackground.backgroundParams.varTable{1, :}), ...
                              string(testCase.parameters(1, :)), 'Start background parameter not set correctly');
         testCase.verifySize(testBackground.backgroundParams.varTable, [3, 8], 'background Parameters has wrong dimension');
         
         testCase.verifyEqual(string(testBackground.backgrounds.varTable{1, :}), ...
                              string(testCase.backgrounds(1, :)), 'Start background parameter not set correctly');
         testCase.verifySize(testBackground.backgrounds.varTable, [1, 8], 'backgrounds has wrong dimension');
      end

      function testGetNames(testCase)
         % Tests getNames returns correctly
         backgroundNames = testCase.background.getNames();
         testCase.verifyEqual(backgroundNames, string(testCase.backgrounds(1, 1)), 'getNames method not working');
         testCase.verifySize(backgroundNames, [1, 1], 'background names has wrong dimension');

         testCase.background.backgrounds.varTable = [testCase.background.backgrounds.varTable; vertcat(testCase.backgrounds(2:end, :))];
         backgroundNames = testCase.background.getNames();
         testCase.verifyEqual(backgroundNames, convertCharsToStrings(testCase.backgrounds(:, 1)), 'getNames method not working');
         testCase.verifySize(backgroundNames, [size(testCase.backgrounds, 1), 1], 'background names has wrong dimension');
      end

      function testAddBackground(testCase)
         % Checks that background can be added
         testCase.background.backgroundParams.varTable = [testCase.background.backgroundParams.varTable; vertcat(testCase.parameters(2:end, :))];
         
         testCase.background.addBackground(testCase.names);
         testCase.verifyEqual(string(testCase.background.backgrounds.varTable{end, :}),...
                              string({'New background 2', allowedTypes.Constant.value, '', '', '', '', '', ''}), 'addBackground method not working');
         testCase.background.addBackground(testCase.names, 'New Back');
         testCase.verifyEqual(string(testCase.background.backgrounds.varTable{end, :}),...
                              string({'New Back', allowedTypes.Constant.value, '', '', '', '', '', ''}), 'addBackground method not working');
         testCase.background.addBackground(testCase.names, testCase.backgrounds{3, 1:5});
         testCase.verifyEqual(string(testCase.background.backgrounds.varTable{end, :}),...
                              string(testCase.backgrounds(3, :)), 'addBackground method not working');
         testCase.background.addBackground(testCase.names, testCase.backgrounds{4, 1:3});
         testCase.verifyEqual(string(testCase.background.backgrounds.varTable{end, :}),...
                              string(testCase.backgrounds(4, :)), 'addBackground method not working');
         testCase.background.addBackground(testCase.names, 'background 5', allowedTypes.Function, 'function_name', "BACKGROUND PARAM 1", 3);
         testCase.verifyEqual(string(testCase.background.backgrounds.varTable{end, :}),...
                              ["background 5", string(allowedTypes.Function.value), "function_name", "background param 1", "background param 3", "", "", ""], ...
                              'addBackground method not working');
         testCase.verifyWarning(@() testCase.background.addBackground(testCase.names, "New background 6", allowedTypes.Constant.value, "background param 1", "extra_value", '', '', '', ''), 'warnings:invalidNumberOfInputs');
         testCase.verifyWarning(@() testCase.background.addBackground(testCase.names, "New background 7", allowedTypes.Data.value, "data_name", "background param 1", "extra_value", '', '', ''), 'warnings:invalidNumberOfInputs');
         testCase.verifyError(@() testCase.background.addBackground(testCase.names, 'New', 'fixed'), exceptions.invalidOption.errorID);
         testCase.verifyError(@() testCase.background.addBackground(testCase.names, 'New', allowedTypes.Constant), exceptions.invalidNumberOfInputs.errorID);
         testCase.verifyError(@() testCase.background.addBackground(testCase.names, 'New', allowedTypes.Constant.value, 6), exceptions.indexOutOfRange.errorID);
      end

      function testRemoveBackground(testCase)
         % Checks that background can be removed
         testCase.background.backgrounds.varTable = [testCase.background.backgrounds.varTable; vertcat(testCase.backgrounds(2:end, :))];

         testCase.background.removeBackground(3);
         testCase.verifyEqual(testCase.background.backgrounds.varTable{:, 1}, ...
                              ["background 1"; "background 2"; "background 4"], 'removeBackground method not working');
         testCase.background.removeBackground([1, 3]);
         testCase.verifyEqual(testCase.background.backgrounds.varTable{:, 1}, "background 2", 'removeBackground method not working');  
      end

      function testSetBackgroundName(testCase)
         % Checks that background name can be modified
         testCase.background.backgrounds.varTable = [testCase.background.backgrounds.varTable; vertcat(testCase.backgrounds(2:end, :))];
         testCase.background.setBackgroundName(1, 'background one');
         testCase.verifyEqual(testCase.background.backgrounds.varTable{1, 1}, ...
                              "background one", 'setBackgroundName method not working');
         testCase.background.setBackgroundName(3, 'background three');
         testCase.verifyEqual(testCase.background.backgrounds.varTable{3, 1}, ...
                              "background three", 'setBackgroundName method not working');
         testCase.verifyError(@() testCase.background.setBackgroundName(2, 2), 'MATLAB:validators:mustBeTextScalar');
      end

      function testSetBackground(testCase)
          import matlab.unittest.fixtures.SuppressedWarningsFixture
          testCase.applyFixture(SuppressedWarningsFixture('warnings:invalidNumberOfInputs'))
          testCase.applyFixture(SuppressedWarningsFixture('warnings:fieldsCleared'))

         % Checks that background can be modified
         testCase.background.backgrounds.varTable = [testCase.background.backgrounds.varTable; vertcat(testCase.backgrounds(2:end, :))];
         testCase.background.backgroundParams.varTable = [testCase.background.backgroundParams.varTable; vertcat(testCase.parameters(2:end, :))];
         
         testCase.background.setBackground('Background 1',testCase.names, 'name', 'Back 1');
         testCase.verifyEqual(testCase.background.backgrounds.varTable{1, 1}, "Back 1", 'setBackground method not working');
         testCase.background.setBackground(1, testCase.names, 'name', 'Background 1');
         testCase.verifyEqual(testCase.background.backgrounds.varTable{1, 1}, "Background 1", 'setBackground method not working');

         testCase.background.setBackground(1, testCase.names, 'type', allowedTypes.Constant.value);
         testCase.verifyEqual(testCase.background.backgrounds.varTable{1, 2}, string(allowedTypes.Constant.value), 'setBackground method not working');
         testCase.background.setBackground('Background 1', testCase.names, 'type', allowedTypes.Function.value); 

         testCase.verifyEqual(testCase.background.backgrounds.varTable{1, 2}, string(allowedTypes.Function.value), 'setBackground method not working');
         testCase.verifyError(@() testCase.background.setBackground(2, testCase.names, 'type', 'random'), exceptions.invalidOption.errorID);
         
         testCase.background.setBackground('Background 2', testCase.names, 'Source', 1);
         testCase.verifyEqual(testCase.background.backgrounds.varTable{2, 3}, "background param 1", 'setBackground method not working');
         
         testCase.background.setBackground(2, testCase.names, 'Value2', 'Background param 1');
         testCase.verifyEqual(testCase.background.backgrounds.varTable{2, 5}, "background param 1", 'setBackground method not working');
         testCase.verifyError(@() testCase.background.setBackground(2, testCase.names, 'Value2', 'random'), exceptions.nameNotRecognised.errorID);
         testCase.verifyError(@() testCase.background.setBackground(5, testCase.names, 'Value2', 'random'), exceptions.indexOutOfRange.errorID);
         testCase.verifyError(@() testCase.background.setBackground(true, testCase.names, 'Value2', 'random'), exceptions.invalidType.errorID);
         
         testCase.background.setBackground(3, testCase.names, 'name', 'New Name', 'type', allowedTypes.Constant.value, 'source', 'Background param 3', 'value1', '');

         testCase.verifyEqual(testCase.background.backgrounds.varTable{3, 1}, "New Name", 'setBackground method not working');
         testCase.verifyEqual(testCase.background.backgrounds.varTable{3, 2}, string(allowedTypes.Constant.value), 'setBackground method not working');
         testCase.verifyEqual(testCase.background.backgrounds.varTable{3, 3}, "background param 3", 'setBackground method not working');
         testCase.verifyEqual(testCase.background.backgrounds.varTable{3, 4}, "", 'setBackground method not working');

         testCase.background.setBackground(3, testCase.names, 'type', allowedTypes.Function.value, 'source', 'function_name');

         testCase.verifyEqual(testCase.background.backgrounds.varTable{3, 2}, string(allowedTypes.Function.value), 'setBackground method not working');
         testCase.verifyEqual(testCase.background.backgrounds.varTable{3, 3}, "function_name", 'setBackground method not working');
      end

      function testSetBackgroundWarnings(testCase)
          testCase.background.backgrounds.varTable = [testCase.background.backgrounds.varTable; vertcat(testCase.backgrounds(2:end, :))];
          testCase.background.backgroundParams.varTable = [testCase.background.backgroundParams.varTable; vertcat(testCase.parameters(2:end, :))];

          testCase.verifyWarning(@() testCase.background.setBackground(1, testCase.names, "Value1", "Background param 1"), 'warnings:invalidNumberOfInputs');
          testCase.verifyWarning(@() testCase.background.setBackground(4, testCase.names, "Value2", "Background param 1"), 'warnings:invalidNumberOfInputs');
      end

      function testDisplayTable(testCase)
         % Check that the contents of the background are printed
         paramHeader = {'p', 'Name', 'Min', 'Value', 'Max', 'Fit?'};
         display = evalc('testCase.background.displayTable()');
         testCase.verifyNotEmpty(display, 'displayTable method not working');
         display = split(display, ["(a)", "(b)"]);  % splits background parameter table from background table
         testCase.verifyLength(display, 3);

         displayArray = textscan(display{2},'%s','Delimiter','\r','TextType','string');
         displayArray = strip(displayArray{1});
         % display table should be height of backgroundParams table plus header and divider row
         testCase.verifyLength(displayArray, height(testCase.background.backgroundParams.varTable) + 3);
         % Remove html tags used to format header then split table when
         % 2 or more spaces are found to avoid splitting names with single space
         displayHeader = eraseBetween(displayArray{2}, '<', '>', 'Boundaries','inclusive');
         displayHeader = regexp(displayHeader, '\s{2,}', 'split');
         testCase.verifyEqual(displayHeader, paramHeader);
         row = regexp(displayArray{4}, '\s{2,}', 'split');
         row = string(replace(row, '"', ''));
         testCase.verifyLength(row, length(paramHeader));
         testCase.verifyEqual(row, string({1, testCase.parameters{1, 1:5}}), 'displayTable method not working')

         paramHeader = {'p', 'Name', 'Type', 'Source', 'Value 1', 'Value 2', 'Value 3', 'Value 4', 'Value 5'};
         displayArray = textscan(display{3},'%s','Delimiter','\r','TextType','string');
         displayArray = strip(displayArray{1});
         % display table should be height of background table plus header and divider row
         testCase.verifyLength(displayArray, height(testCase.background.backgrounds.varTable) + 3);
         displayHeader = eraseBetween(displayArray{2}, '<', '>', 'Boundaries','inclusive');
         displayHeader = regexp(displayHeader, '\s{2,}', 'split');
         testCase.verifyEqual(displayHeader, paramHeader);
         row = regexp(displayArray{4}, '\s{2,}', 'split');
         row = string(replace(row, '"', ''));
         testCase.verifyLength(row, length(paramHeader));
         testCase.verifyEqual(row, string({1, testCase.backgrounds{1, :}}), 'displayTable method not working')

         paramHeader = {'p', 'Name', 'Min', 'Value', 'Max', 'Fit?', 'Prior Type', 'mu', 'sigma'};
         display = evalc('testCase.background.displayTable(true)');
         display = split(display, ["(a)", "(b)"]); 
         displayArray = textscan(display{2},'%s','Delimiter','\r','TextType','string');
         displayArray = strip(displayArray{1});
         displayHeader = eraseBetween(displayArray{2}, '<', '>', 'Boundaries','inclusive');
         displayHeader = regexp(displayHeader, '\s{2,}', 'split');
         testCase.verifyEqual(displayHeader, paramHeader);
         row = regexp(displayArray{4}, '\s{2,}', 'split');
         row = string(replace(row, '"', ''));
         testCase.verifyLength(row, length(paramHeader));
         testCase.verifyEqual(row, string({1, testCase.parameters{1, :}}), 'displayTable method not working')
      end

      function testToStruct(testCase)
         % Checks that class to struct works correctly
         expected.backgroundParamNames = {'background param 1'};
         expected.backgroundParamLimits = {[0.0100 0.0500]};
         expected.backgroundParamValues = 0.0300;
         expected.fitBackgroundParam = 0;
         expected.backgroundParamPriors = {{'background param 1', priorTypes.Uniform.value, 0, Inf}};
         expected.backgroundNames = "background 1";
         expected.backgroundTypes = string(allowedTypes.Constant.value);
         expected.backgroundValues = {"background param 1", "", "", "", "", ""};
         testCase.verifyEqual(testCase.background.toStruct(), expected, 'toStruct method not working');

         testCase.background.backgrounds.varTable = [testCase.background.backgrounds.varTable; vertcat(testCase.backgrounds(2:3, :))];
         testCase.background.backgroundParams.varTable = [testCase.background.backgroundParams.varTable; vertcat(testCase.parameters(2:3, :))];

         expected.backgroundParamNames = {'background param 1', 'background param 2', 'background param 3'};
         expected.backgroundParamLimits = {[0.0100 0.0500], [0.1000 1], [0.2000 1.1000]};
         expected.backgroundParamValues = [0.0300, 0.1900, 0.1700];
         expected.fitBackgroundParam = [0, 1, 0];
         expected.backgroundParamPriors = {{'background param 1', priorTypes.Uniform.value, 0, Inf};... 
                                           {'background param 2', priorTypes.Gaussian.value, -1, 1};... 
                                           {'background param 3', priorTypes.Uniform.value, 0, Inf}};
         expected.backgroundNames = ["background 1"; "background 2"; "background 3"];
         expected.backgroundTypes = [string(allowedTypes.Constant.value); string(allowedTypes.Constant.value); 
                                     string(allowedTypes.Function.value)];
         expected.backgroundValues = {"background param 1", "", "", "", "", ""; "background param 2", "", "", "", "", "";...
                                      "function_name", "background param 1", "background param 2", "", "", ""};
         testCase.verifyEqual(testCase.background.toStruct(), expected, 'toStruct method not working');
      end
   end
end
