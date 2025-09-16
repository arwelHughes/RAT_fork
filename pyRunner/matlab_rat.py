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



def matlab_rat(problem,controls,eng):
    
    # Saves the project and controls as jsons, then runs them in matlab RAT.
    # Finally, loads the project / results back in...
    
    # Save the problem.
    problem.save('pyRAT_problem')
    
    # Save the controls..
    controls.save(os.getcwd(),'pyRat_controls')
    
    
    # Get the current path...
    currPath = os.getcwd()
    
    # Manually get the matlab Rat dir for now....
    ratPath = '/Users/arwel/Documents/coding/RAT_fork/'
    
    # Set the matlab path to the RAT directory...
    eng.cd(ratPath, nargout=0)
    
    # Add the matlab paths....
    eng.feval('addPaths', nargout=0)
    
    # go back to our original directory....
    eng.cd(currPath, nargout=0)
    
    # Run the project in matlabRAT
    ratRun = "runFromPython('pyRAT_problem.json','pyRat_controls.json')"
    eng.eval(ratRun,nargout=0)
    
    # load the results back in....
    newProblem = RAT.Project.load('pyRAT_problem_project_updated.json')
    results = RAT.Results.load('pyRAT_problem_results.json')
    
    #Go back to the calling func...
    return newProblem, results
    

if __name__ == "__main__":
    
    # Connect to Matlab engine..... (this should actually connect to the existing 
    # pythonRAT Matlab session instead of starting a new one..
    eng = engine.start_matlab()
    
    # Make the project class - usual custom DSPC example but with a Matlab custom model
    import customDSPC
    
    problem = customDSPC.customDSPC()
    controls = RAT.Controls()
    controls.procedure = 'de'
    
    # Send this to Matlab RAT....
    newProblem, results = matlab_rat(problem,controls,eng)
    
    eng.quit()