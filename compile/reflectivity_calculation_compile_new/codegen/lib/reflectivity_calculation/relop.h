//
// Non-Degree Granting Education License -- for use at non-degree
// granting, nonprofit, educational organizations only. Not for
// government, commercial, or other organizational use.
//
// relop.h
//
// Code generation for function 'relop'
//

#ifndef RELOP_H
#define RELOP_H

// Include files
#include "rtwtypes.h"
#include "omp.h"
#include <cstddef>
#include <cstdlib>

// Function Declarations
namespace coder {
namespace internal {
boolean_T b_relop(double a, double b);

boolean_T c_relop(double a, double b);

boolean_T relop(double a, double b);

} // namespace internal
} // namespace coder

#endif
// End of code generation (relop.h)