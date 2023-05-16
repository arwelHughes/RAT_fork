% ABELESREFLECTWRAPPER_SCRIPT   Generate MEX-function abelesReflectWrapper_mex
%  from abelesReflectWrapper.
% 
% Script generated from project 'abelesReflectWrapper.prj' on 12-May-2023.
% 
% See also CODER, CODER.CONFIG, CODER.TYPEOF, CODEGEN.

%% Create configuration object of class 'coder.MexCodeConfig'.
cfg = coder.config('mex');
cfg.GenerateReport = true;
cfg.EnableJIT = true;
cfg.EnableJITSilentBailOut = true;

%% Define argument types for entry-point 'abelesReflectWrapper'.
ARGS = cell(1,1);
ARGS{1} = cell(2,1);
ARGS{1}{1} = coder.typeof(0,[10000   1],[1 0]);
ARGS{1}{2} = coder.typeof(0,[1000   4],[1 0]);

%% Invoke MATLAB Coder.
codegen -config cfg abelesReflectWrapper -args ARGS{1}

