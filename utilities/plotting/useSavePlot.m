classdef useSavePlot < handle
    % Saves plot event data to a file instead of displaying a live MATLAB figure.
    %
    % Examples
    % --------
    % >>> useSavePlot('plotEvents.json');
    %
    % Parameters
    % ----------
    % filename : char or string
    %    Path to the file where plot event data will be written.

    properties (Hidden)
        filename
        fileID
        handle
    end

    methods
        function obj = useSavePlot(filename)
            arguments
                filename {mustBeText, mustBeNonempty} = []
            end

            if isempty(filename)
                error('useSavePlot:invalidFilename', 'Filename must be provided.');
            end

            obj.filename = char(filename);
            obj.fileID = fopen(obj.filename, 'a');
            if obj.fileID == -1
                error('useSavePlot:fileOpenError', 'Could not open file %s for writing.', obj.filename);
            end

            obj.handle = @(varargin) obj.savePlot(varargin{:});

            % Ensure only one plot event listener is active at a time.
            eventManager.clear(eventTypes.Plot);
            eventManager.register(eventTypes.Plot, obj.handle);

            fprintf('Plot events will be saved to %s.\n', obj.filename);
        end
    end

    methods (Hidden)
        function savePlot(obj, data)
            % Save the received plot event data to the configured file.
            %
            % Parameters
            % ----------
            % data : struct
            %    Plot event data from RAT.

            try
                json = jsonencode(data);
            catch ME
                warning('useSavePlot:saveFailure', 'Failed to encode plot event data: %s', ME.message);
                return;
            end

            fprintf(obj.fileID, '%s\n', json);
            try
                fflush(obj.fileID);
            catch
                % Some MATLAB versions may not support fflush for text files.
            end
        end

        function closeFile(obj)
            % Close the save file and unregister the plot event handler.
            eventManager.unregister(eventTypes.Plot, obj.handle);
            if obj.fileID ~= -1
                fclose(obj.fileID);
                obj.fileID = -1;
            end
        end

        function delete(obj)
            if obj.fileID ~= -1
                obj.closeFile();
            end
        end
    end
end
