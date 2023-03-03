//
// Non-Degree Granting Education License -- for use at non-degree
// granting, nonprofit, education, and research organizations only. Not
// for commercial or industrial use.
// File: customBilayer.h
//
// MATLAB Coder version            : 5.5
// C/C++ source code generated on  : 02-Mar-2023 09:25:27
//
#ifndef CUSTOMBILAYER_H
#define CUSTOMBILAYER_H

// Include Files
#include "rtwtypes.h"
#include "coder_array.h"
#include <cstddef>
#include <cstdlib>
#include "dylib.hh"

// Function Declarations
namespace bilayer
{
  DYLIB_API void customBilayer(const ::coder::array<double, 2U> &params, double
    bulk_in, const ::coder::array<double, 1U> &bulk_out, double contrast, double
    output[3][6], double *sub_rough);
}

#endif

//
// File trailer for customBilayer.h
//
// [EOF]
//
