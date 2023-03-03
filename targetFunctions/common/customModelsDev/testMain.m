
% Make the params.....
Parameters = {
    %       Name                min         val         max     fit? 
        {'Oxide thick',         5,          20,         60,     true   };
        {'Oxide Hydration'      0,          0.2,        0.5,    true   };
        {'Lipid APM'            45          55          65      true   };
        {'Head Hydration'       0           0.2         0.5     true   };
        {'Bilayer Hydration'    0           0.1         0.2     true   };
        {'Bilayer Roughness'    2           4           8       true   };
        {'Water Thickness'      0           2           10      true   };
        };

params = [20 0.2 55 0.2 0.1 4 3];
nba = 2.073e-6;
nbs  = [0 0 0];
numberOfContrasts = int32(3);

libName = 'customBilayer';
funcName = 'customBilayer';

[layers,sRough] = callCppCustomModel_mex(params,nba,nbs,numberOfContrasts,libName,funcName);

%[allLayersArr,allRoughsArr] = testDLL(params,nba,nbs,numberOfContrasts,libraryName,functionName)