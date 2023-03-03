classdef customModelClass < handle

    properties
        matlabEngine
        pythonSession
    end

    methods
        function startExternalMatlabEngine(obj)
            % Todo
        end

        function stopExternalMatlabEngine(obj)
            % Todo
        end

        function [allLayers,allRoughs] = callMatlabCustomModel_single()
            % This version excecutes the custom model via extrinsic 'feval'
            % into base Matlab workspace.



        end




        function [allLayers,allRoughs] = callCppCustomModel(cBacks,cShifts,cScales,cNbas,cNbss,cRes,backs,...
                shifts,sf,nba,nbs,res,cCustFiles,numberOfContrasts,customFiles,params)

            allLayers = cell(numberOfContrasts,1);
            for i = 1:numberOfContrasts
                allLayers{i} = [1 ; 1];
            end
            coder.varsize('allLayers{:}',[1000,5],[1,1]);

            for i = 1:numberOfContrasts
                tempOut = zeros(1000,5);
                sRough = 0.0;
                % This is the function that calls the C++ header function that loads the library,function and calls it with the supplied arguments
                [tempOut,sRough,nLayers,nCols] = callExternalCpp(params,nba,nbs,i,cLibName,cfunctionName);

                if (nLayers >= 1)
                    output = zeros(nLayers,nCols);
                    for i = 1:(nLayers*nCols)
                        thisVal = tempOut(i);  %Make use of Matlab linear indexing.
                        output(rowCount,colCount) = thisVal;
                        rowCount = rowCount + 1;
                        if rowCount == (nLayers+1)
                            rowCount = 1;
                            colCount = colCount + 1;
                        end
                    end
                else
                    output = [1 1 1];
                    sRough = 1;
                end
                allLayers{i} = output;
                allRoughs(i) = sRough;
            end
        end
    end

    methods (Access=private)

        function [allLayersArr,allRoughsArr] = callExternalCpp(params,nba,nbs,numberOfContrasts,libraryName,functionName)
            coder.cinclude('<functional>');
            coder.cinclude('<string>');
            coder.cinclude('<iostream>');
            coder.cinclude('<map>');
            coder.cinclude('<vector>');
            coder.cinclude('libManager.h');
            coder.cinclude('<tuple>');
            coder.updateBuildInfo('addLinkFlags','-ldl');

            % Need to find a way to make this work with 100000,3
            output = zeros(10000,5);
            subRough = 0.0;

            %cfunctionName(isstrprop(cfunctionName,'digit')) = [];

            p = coder.opaque('Library','NULL','HeaderFile','libManager.h');
            % Make an instance
            p = coder.ceval('Library');
            %coder.ceval('std::mem_fn(&Library::loadInfo)',p,[clibraryName,'0'],[cfunctionName,'0']);

            coder.ceval('std::mem_fn(&Library::loadRunner)',p,coder.ref(params),coder.ref(nba),coder.ref(nbs)...
                ,numberOfContrasts,coder.wref(output),coder.wref(subRough),libraryName,functionName);

            allLayersArr = output;
            allRoughsArr = subRough;
        end

    end
end