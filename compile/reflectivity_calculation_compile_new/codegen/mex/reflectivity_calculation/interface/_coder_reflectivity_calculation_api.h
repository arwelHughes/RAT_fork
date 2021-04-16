//
//  Non-Degree Granting Education License -- for use at non-degree
//  granting, nonprofit, educational organizations only. Not for
//  government, commercial, or other organizational use.
//
//  _coder_reflectivity_calculation_api.h
//
//  Code generation for function '_coder_reflectivity_calculation_api'
//


#pragma once

// Include files
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include "mex.h"
#include "emlrt.h"
#include "rtwtypes.h"
#include "omp.h"
#include "reflectivity_calculation_types.h"
#define MAX_THREADS                    omp_get_max_threads()

// Function Declarations
void reflectivity_calculation_api(const mxArray * const prhs[4], int32_T nlhs,
  const mxArray *plhs[2]);

// End of code generation (_coder_reflectivity_calculation_api.h)
