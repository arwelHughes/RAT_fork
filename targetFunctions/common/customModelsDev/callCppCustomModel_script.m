% CALLCPPCUSTOMMODEL_SCRIPT   Generate MEX-function callCppCustomModel_mex from
%  callCppCustomModel.
% 
% Script generated from project 'callCppCustomModel.prj' on 03-Mar-2023.
% 
% See also CODER, CODER.CONFIG, CODER.TYPEOF, CODEGEN.

%% Create configuration object of class 'coder.MexCodeConfig'.
cfg = coder.config('mex');
cfg.TargetLang = 'C++';
cfg.GenerateReport = true;
cfg.ReportPotentialDifferences = false;

%% Define argument types for entry-point 'callCppCustomModel'.
ARGS = cell(1,1);
ARGS{1} = cell(6,1);
ARGS{1}{1} = coder.typeof(0,[1 Inf],[0 1]);
ARGS{1}{2} = coder.typeof(0);
ARGS{1}{3} = coder.typeof(0,[1 Inf],[0 1]);
ARGS{1}{4} = coder.typeof(int32(0));
ARGS{1}{5} = coder.typeof('X',[1 Inf],[0 1]);
ARGS{1}{6} = coder.typeof('X',[1 Inf],[0 1]);

%% Invoke MATLAB Coder.
codegen -config cfg callCppCustomModel -args ARGS{1}

