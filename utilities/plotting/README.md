# RAT Plotting Utilities

This folder contains helper utilities for plotting RAT results from plot event data.

## Key helpers

- `useLivePlot(figureId)`
  - Opens or uses a MATLAB figure and updates it whenever `eventTypes.Plot` events are emitted.
  - Example: `useLivePlot(1)`

- `useSavePlot(filename)`
  - Registers a handler for `eventTypes.Plot` events that saves each event payload to `filename` as JSON.
  - The file is appended with one JSON record per event.
  - Example: `useSavePlot('plotEvents.json')`

- `useFilePlot(filename)`
  - Alias for `useSavePlot(filename)`.

## Usage

1. Call `addPaths` to ensure RAT is on the MATLAB path.
2. Start RAT calculations normally.
3. Use either `useLivePlot` or `useSavePlot` before running the calculation.

Example:

```matlab
addPaths;
useSavePlot('plotEvents.json');
[project, results] = RAT(project, controls);
```

## Notes

- `useLivePlot` will clear any previously registered `eventTypes.Plot` listeners before registering itself.
- `useSavePlot` also clears previously registered plot listeners and writes output in newline-delimited JSON format.
- To stop saving events, call `closeFile()` on the returned `useSavePlot` object.
