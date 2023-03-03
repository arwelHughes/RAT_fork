% CUSTOMBILAYER_SCRIPT   Generate static library customBilayer from
%  customBilayer.
% 
% Script generated from project 'customBilayer.prj' on 02-Mar-2023.
% 
% See also CODER, CODER.CONFIG, CODER.TYPEOF, CODEGEN.

%% Create configuration object of class 'coder.EmbeddedCodeConfig'.
cfg = coder.config('lib');
cfg.GenerateReport = true;
cfg.ReportPotentialDifferences = false;
cfg.GenCodeOnly = true;
cfg.InlineBetweenUserFunctions = 'Readability';
cfg.InlineBetweenMathWorksFunctions = 'Readability';
cfg.InlineBetweenUserAndMathWorksFunctions = 'Readability';
cfg.TargetLang = 'C++';
cfg.PreserveVariableNames = 'UserNames';
cfg.CppNamespace = 'bilayer';
cfg.PreserveArrayDimensions = true;
cfg.MATLABSourceComments = true;
cfg.CodeFormattingTool = 'MathWorks';
cfg.RunInitializeFcn = false;
cfg.DataTypeReplacement = 'CBuiltIn';
cfg.MultiInstanceCode = true;

%% Define argument types for entry-point 'customBilayer'.
ARGS = cell(1,1);
ARGS{1} = cell(4,1);
ARGS{1}{1} = coder.typeof(0,[1 Inf],[0 1]);
ARGS{1}{2} = coder.typeof(0);
ARGS{1}{3} = coder.typeof(0,[Inf  1],[1 0]);
ARGS{1}{4} = coder.typeof(0);

%% Invoke MATLAB Coder.
codegen -config cfg customBilayer -args ARGS{1}

