function [layers,rough] = callCppCustomModel(params,nba,nbs,numberOfContrasts,libName,funcName)

% Call the CPP custom model....
coder.extrinsic('testDLL_mex_latest');

if coder.target('MATLAB')

    % Just make some dummy outputs....
    layers = [0 0 0 ; 0 0 0];
    rough = 3;

else

    % Try to call the CPP shared library..

    % (1) Initially do this by calling the mex..
    [layers,rough] = testDLL_mex_latest(params,nba,nbs,numberOfContrasts,libName,funcName);

end

end