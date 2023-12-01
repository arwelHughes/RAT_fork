% VOLUME_THIOLSAM_PLUS_DPPC_POLARISED_ABS_SCRIPT   Generate MEX-function
%  volume_thiolsam_plus_DPPC_polarised_abs_mex from
%  volume_thiolsam_plus_DPPC_polarised_abs.
% 
% Script generated from project 'volume_thiolsam_plus_DPPC_polarised_abs.prj' on
%  29-Nov-2023.
% 
% See also CODER, CODER.CONFIG, CODER.TYPEOF, CODEGEN.

%% Create configuration object of class 'coder.MexCodeConfig'.
cfg = coder.config('mex');
cfg.TargetLang = 'C++';
cfg.GenerateReport = true;
cfg.ReportPotentialDifferences = false;

%% Define argument types for entry-point
%  'volume_thiolsam_plus_DPPC_polarised_abs'.
ARGS = cell(1,1);
ARGS{1} = cell(4,1);
ARGS{1}{1} = coder.typeof(0,[1 19]);
ARGS{1}{2} = coder.typeof(0);
ARGS{1}{3} = coder.typeof(0,[4 1]);
ARGS{1}{4} = coder.typeof(0);

%% Invoke MATLAB Coder.
codegen -config cfg volume_thiolsam_plus_DPPC_polarised_abs -args ARGS{1}

