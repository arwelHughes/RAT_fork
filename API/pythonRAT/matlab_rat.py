#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Sep 12 10:59:51 2025

@author: arwel


An example of calling matlab RAT from python

"""
import ratapi as RAT
import matlab.engine as engine
import os
import tempfile
import shutil



def matlab_rat(problem, controls, eng=None, rat_path=None, out_file=None):
    """
    Run RAT calculation using MATLAB engine from Python.
    
    Parameters
    ----------
    problem : RAT.Project
        The project to run
    controls : RAT.Controls
        The controls for the calculation
    eng : matlab.engine.MatlabEngine, optional
        Existing MATLAB engine instance. If None, starts a new one.
    rat_path : str, optional
        Path to RAT MATLAB directory. If None, uses default.
    out_file : str, optional
        Optional path for MATLAB to save plot event data using useSavePlot.
    
    Returns
    -------
    new_problem : RAT.Project
        Updated project after calculation
    results : RAT.Results
        Calculation results
    """
    
    start_engine = eng is None
    if start_engine:
        eng = engine.start_matlab()
    
    try:
        # Use temp directory for files
        with tempfile.TemporaryDirectory() as temp_dir:
            problem_file = os.path.join(temp_dir, 'pyRAT_problem.json')
            controls_file = os.path.join(temp_dir, 'pyRat_controls.json')
            updated_problem_file = os.path.join(temp_dir, 'pyRAT_problem_project_updated.json')
            results_file = os.path.join(temp_dir, 'pyRAT_problem_results.json')
            events_file = os.path.join(temp_dir, 'events.log')
            
            # Save the problem and controls
            problem.save(problem_file)
            controls.save(controls_file)
            
            # Get the current path
            curr_path = os.getcwd()
            
            # Get RAT path
            if rat_path is None:
                # Try to find RAT path automatically (assuming this script is in RAT/API/pythonRAT/)
                script_dir = os.path.dirname(os.path.abspath(__file__))
                rat_path = os.path.dirname(os.path.dirname(script_dir))
            
            # Set the matlab path to the RAT directory
            eng.cd(rat_path, nargout=0)
            
            # Add the matlab paths
            eng.feval('addPaths', nargout=0)
            
            # Go back to temp directory for file access
            eng.cd(temp_dir, nargout=0)
            
            # Optionally enable saving plot events to a file in MATLAB
            if out_file is not None:
                out_file_abs = os.path.abspath(out_file)
                out_file_escaped = out_file_abs.replace("'", "''")
                eng.eval(f"useSavePlot('{out_file_escaped}')", nargout=0)
            
            # Run the project in matlabRAT
            rat_run = f"runFromPython('{os.path.basename(problem_file)}','{os.path.basename(controls_file)}','{os.path.basename(events_file)}')"
            eng.eval(rat_run, nargout=0)
            
            # Load the results back in
            new_problem = RAT.Project.load(updated_problem_file)
            results = RAT.Results.load(results_file)
            
            # Optionally read events log
            if os.path.exists(events_file):
                with open(events_file, 'r') as f:
                    events_log = f.read()
                # Could store events_log in results or return it
            
            # Go back to original directory
            eng.cd(curr_path, nargout=0)
            
            return new_problem, results
    except Exception as e:
        raise RuntimeError(f"Error running MATLAB RAT: {str(e)}")
    finally:
        if start_engine and eng is not None:
            eng.quit()
    

if __name__ == "__main__":
    
    # Connect to Matlab engine..... (this should actually connect to the existing 
    # pythonRAT Matlab session instead of starting a new one..
    eng = engine.start_matlab()
    
    try:
        # Make the project class - usual custom DSPC example but with a Matlab custom model
        import customDSPC
        
        problem = customDSPC.customDSPC()
        controls = RAT.Controls()
        controls.procedure = 'de'
        
        # Send this to Matlab RAT....
        newProblem, results = matlab_rat(problem, controls, eng)
        
        print("Calculation completed successfully")
        # Here you could do something with newProblem and results
        
    finally:
        eng.quit()