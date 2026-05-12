function obj = useFilePlot(filename)
% Alias for useSavePlot for compatibility with file-based plotting.
%
% Examples
% --------
% >>> useFilePlot('plotEvents.json');
    
    obj = useSavePlot(filename);
end
