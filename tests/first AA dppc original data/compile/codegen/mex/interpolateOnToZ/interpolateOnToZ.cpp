//
// Non-Degree Granting Education License -- for use at non-degree
// granting, nonprofit, educational organizations only. Not for
// government, commercial, or other organizational use.
//
// interpolateOnToZ.cpp
//
// Code generation for function 'interpolateOnToZ'
//

// Include files
#include "interpolateOnToZ.h"
#include "eml_int_forloop_overflow_check.h"
#include "interp1.h"
#include "interpolateOnToZ_data.h"
#include "linspace.h"
#include "rt_nonfinite.h"
#include "coder_array.h"
#include "mwmathutil.h"
#include <algorithm>

// Variable Definitions
static emlrtRSInfo
    emlrtRSI{
        17,                 // lineNo
        "interpolateOnToZ", // fcnName
        "/Users/arwel/Documents/gwaith/MD_bilayers_work/ALC "
        "collaboration/Fits/first AA dppc original "
        "data/compile/interpolateOnToZ.m" // pathName
    };

static emlrtRSInfo
    b_emlrtRSI{
        18,                 // lineNo
        "interpolateOnToZ", // fcnName
        "/Users/arwel/Documents/gwaith/MD_bilayers_work/ALC "
        "collaboration/Fits/first AA dppc original "
        "data/compile/interpolateOnToZ.m" // pathName
    };

static emlrtRSInfo
    c_emlrtRSI{
        20,                 // lineNo
        "interpolateOnToZ", // fcnName
        "/Users/arwel/Documents/gwaith/MD_bilayers_work/ALC "
        "collaboration/Fits/first AA dppc original "
        "data/compile/interpolateOnToZ.m" // pathName
    };

static emlrtRSInfo
    d_emlrtRSI{
        28,                 // lineNo
        "interpolateOnToZ", // fcnName
        "/Users/arwel/Documents/gwaith/MD_bilayers_work/ALC "
        "collaboration/Fits/first AA dppc original "
        "data/compile/interpolateOnToZ.m" // pathName
    };

static emlrtRSInfo e_emlrtRSI{
    15,    // lineNo
    "max", // fcnName
    "/Applications/MATLAB_R2021a.app/toolbox/eml/lib/matlab/datafun/max.m" // pathName
};

static emlrtRSInfo f_emlrtRSI{
    44,         // lineNo
    "minOrMax", // fcnName
    "/Applications/MATLAB_R2021a.app/toolbox/eml/eml/+coder/+internal/"
    "minOrMax.m" // pathName
};

static emlrtRSInfo g_emlrtRSI{
    79,        // lineNo
    "maximum", // fcnName
    "/Applications/MATLAB_R2021a.app/toolbox/eml/eml/+coder/+internal/"
    "minOrMax.m" // pathName
};

static emlrtRSInfo h_emlrtRSI{
    175,             // lineNo
    "unaryMinOrMax", // fcnName
    "/Applications/MATLAB_R2021a.app/toolbox/eml/eml/+coder/+internal/"
    "unaryMinOrMax.m" // pathName
};

static emlrtRSInfo i_emlrtRSI{
    871,                    // lineNo
    "maxRealVectorOmitNaN", // fcnName
    "/Applications/MATLAB_R2021a.app/toolbox/eml/eml/+coder/+internal/"
    "unaryMinOrMax.m" // pathName
};

static emlrtRSInfo j_emlrtRSI{
    62,                      // lineNo
    "vectorMinOrMaxInPlace", // fcnName
    "/Applications/MATLAB_R2021a.app/toolbox/eml/eml/+coder/+internal/"
    "vectorMinOrMaxInPlace.m" // pathName
};

static emlrtRSInfo k_emlrtRSI{
    54,                      // lineNo
    "vectorMinOrMaxInPlace", // fcnName
    "/Applications/MATLAB_R2021a.app/toolbox/eml/eml/+coder/+internal/"
    "vectorMinOrMaxInPlace.m" // pathName
};

static emlrtRSInfo l_emlrtRSI{
    103,         // lineNo
    "findFirst", // fcnName
    "/Applications/MATLAB_R2021a.app/toolbox/eml/eml/+coder/+internal/"
    "vectorMinOrMaxInPlace.m" // pathName
};

static emlrtRSInfo n_emlrtRSI{
    120,                        // lineNo
    "minOrMaxRealVectorKernel", // fcnName
    "/Applications/MATLAB_R2021a.app/toolbox/eml/eml/+coder/+internal/"
    "vectorMinOrMaxInPlace.m" // pathName
};

static emlrtBCInfo
    emlrtBCI{
        -1,                 // iFirst
        -1,                 // iLast
        11,                 // lineNo
        15,                 // colNo
        "X",                // aName
        "interpolateOnToZ", // fName
        "/Users/arwel/Documents/gwaith/MD_bilayers_work/ALC "
        "collaboration/Fits/first AA dppc original "
        "data/compile/interpolateOnToZ.m", // pName
        0                                  // checkKind
    };

static emlrtBCInfo
    b_emlrtBCI{
        -1,                 // iFirst
        -1,                 // iLast
        16,                 // lineNo
        16,                 // colNo
        "X",                // aName
        "interpolateOnToZ", // fName
        "/Users/arwel/Documents/gwaith/MD_bilayers_work/ALC "
        "collaboration/Fits/first AA dppc original "
        "data/compile/interpolateOnToZ.m", // pName
        0                                  // checkKind
    };

static emlrtRTEInfo b_emlrtRTEI{
    124,             // lineNo
    27,              // colNo
    "unaryMinOrMax", // fName
    "/Applications/MATLAB_R2021a.app/toolbox/eml/eml/+coder/+internal/"
    "unaryMinOrMax.m" // pName
};

static emlrtRTEInfo
    g_emlrtRTEI{
        24,                 // lineNo
        13,                 // colNo
        "interpolateOnToZ", // fName
        "/Users/arwel/Documents/gwaith/MD_bilayers_work/ALC "
        "collaboration/Fits/first AA dppc original "
        "data/compile/interpolateOnToZ.m" // pName
    };

static emlrtRTEInfo
    h_emlrtRTEI{
        25,                 // lineNo
        13,                 // colNo
        "interpolateOnToZ", // fName
        "/Users/arwel/Documents/gwaith/MD_bilayers_work/ALC "
        "collaboration/Fits/first AA dppc original "
        "data/compile/interpolateOnToZ.m" // pName
    };

// Function Definitions
emlrtCTX emlrtGetRootTLSGlobal()
{
  return emlrtRootTLSGlobal;
}

void emlrtLockerFunction(EmlrtLockeeFunction aLockee, emlrtConstCTX aTLS,
                         void *aData)
{
  omp_set_lock(&emlrtLockGlobal);
  emlrtCallLockeeFunction(aLockee, aTLS, aData);
  omp_unset_lock(&emlrtLockGlobal);
}

void interpolateOnToZ(const emlrtStack *sp, const coder::array<real_T, 1U> &X,
                      const coder::array<real_T, 1U> &Y,
                      const coder::array<real_T, 2U> &z,
                      coder::array<real_T, 2U> &newY)
{
  coder::array<real_T, 1U> r;
  coder::array<real_T, 1U> r1;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack e_st;
  emlrtStack f_st;
  emlrtStack g_st;
  emlrtStack h_st;
  emlrtStack i_st;
  emlrtStack st;
  real_T dv[100];
  real_T xRightPad_data[100];
  real_T d;
  real_T ex;
  int32_T a;
  int32_T idx;
  int32_T k;
  int32_T last;
  boolean_T exitg1;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  e_st.prev = &d_st;
  e_st.tls = d_st.tls;
  f_st.prev = &e_st;
  f_st.tls = e_st.tls;
  g_st.prev = &f_st;
  g_st.tls = f_st.tls;
  h_st.prev = &g_st;
  h_st.tls = g_st.tls;
  i_st.prev = &h_st;
  i_st.tls = h_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b((emlrtCTX)sp);
  //  Interpolates the curve given by [X Y] onto Z.
  //  It first extends the range of X and Y to cover the
  //  whole range of z, otherwise Matlab's interp1 will
  //  return NaN when beyond the range of the original X
  //  Pad out the lower end of X and Y
  if (1 > X.size(0)) {
    emlrtDynamicBoundsCheckR2012b(1, 1, X.size(0), &emlrtBCI, (emlrtCTX)sp);
  }
  //  Do the same for the upper edge
  if (X.size(0) < 1) {
    emlrtDynamicBoundsCheckR2012b(X.size(0), 1, X.size(0), &b_emlrtBCI,
                                  (emlrtCTX)sp);
  }
  st.site = &emlrtRSI;
  b_st.site = &e_emlrtRSI;
  c_st.site = &f_emlrtRSI;
  d_st.site = &g_emlrtRSI;
  if (z.size(1) < 1) {
    emlrtErrorWithMessageIdR2018a(&d_st, &b_emlrtRTEI,
                                  "Coder:toolbox:eml_min_or_max_varDimZero",
                                  "Coder:toolbox:eml_min_or_max_varDimZero", 0);
  }
  e_st.site = &h_emlrtRSI;
  f_st.site = &i_emlrtRSI;
  last = z.size(1);
  if (z.size(1) <= 2) {
    if (z.size(1) == 1) {
      ex = z[0];
    } else if ((z[0] < z[1]) ||
               (muDoubleScalarIsNaN(z[0]) && (!muDoubleScalarIsNaN(z[1])))) {
      ex = z[1];
    } else {
      ex = z[0];
    }
  } else {
    g_st.site = &k_emlrtRSI;
    if (!muDoubleScalarIsNaN(z[0])) {
      idx = 1;
    } else {
      idx = 0;
      h_st.site = &l_emlrtRSI;
      if (z.size(1) > 2147483646) {
        i_st.site = &m_emlrtRSI;
        coder::check_forloop_overflow_error(&i_st);
      }
      k = 2;
      exitg1 = false;
      while ((!exitg1) && (k <= last)) {
        if (!muDoubleScalarIsNaN(z[k - 1])) {
          idx = k;
          exitg1 = true;
        } else {
          k++;
        }
      }
    }
    if (idx == 0) {
      ex = z[0];
    } else {
      g_st.site = &j_emlrtRSI;
      ex = z[idx - 1];
      a = idx + 1;
      h_st.site = &n_emlrtRSI;
      if ((idx + 1 <= z.size(1)) && (z.size(1) > 2147483646)) {
        i_st.site = &m_emlrtRSI;
        coder::check_forloop_overflow_error(&i_st);
      }
      for (k = a; k <= last; k++) {
        d = z[k - 1];
        if (ex < d) {
          ex = d;
        }
      }
    }
  }
  if (ex - X[X.size(0) - 1] <= 10.0) {
    st.site = &b_emlrtRSI;
    b_st.site = &e_emlrtRSI;
    c_st.site = &f_emlrtRSI;
    d_st.site = &g_emlrtRSI;
    e_st.site = &h_emlrtRSI;
    f_st.site = &i_emlrtRSI;
    last = z.size(1);
    if (z.size(1) <= 2) {
      if (z.size(1) == 1) {
        ex = z[0];
      } else if ((z[0] < z[1]) ||
                 (muDoubleScalarIsNaN(z[0]) && (!muDoubleScalarIsNaN(z[1])))) {
        ex = z[1];
      } else {
        ex = z[0];
      }
    } else {
      g_st.site = &k_emlrtRSI;
      if (!muDoubleScalarIsNaN(z[0])) {
        idx = 1;
      } else {
        idx = 0;
        h_st.site = &l_emlrtRSI;
        if (z.size(1) > 2147483646) {
          i_st.site = &m_emlrtRSI;
          coder::check_forloop_overflow_error(&i_st);
        }
        k = 2;
        exitg1 = false;
        while ((!exitg1) && (k <= last)) {
          if (!muDoubleScalarIsNaN(z[k - 1])) {
            idx = k;
            exitg1 = true;
          } else {
            k++;
          }
        }
      }
      if (idx == 0) {
        ex = z[0];
      } else {
        g_st.site = &j_emlrtRSI;
        ex = z[idx - 1];
        a = idx + 1;
        h_st.site = &n_emlrtRSI;
        if ((idx + 1 <= z.size(1)) && (z.size(1) > 2147483646)) {
          i_st.site = &m_emlrtRSI;
          coder::check_forloop_overflow_error(&i_st);
        }
        for (k = a; k <= last; k++) {
          d = z[k - 1];
          if (ex < d) {
            ex = d;
          }
        }
      }
    }
    last = 1;
    xRightPad_data[0] = ex;
  } else {
    st.site = &c_emlrtRSI;
    b_st.site = &e_emlrtRSI;
    c_st.site = &f_emlrtRSI;
    d_st.site = &g_emlrtRSI;
    e_st.site = &h_emlrtRSI;
    f_st.site = &i_emlrtRSI;
    last = z.size(1);
    if (z.size(1) <= 2) {
      if (z.size(1) == 1) {
        ex = z[0];
      } else if ((z[0] < z[1]) ||
                 (muDoubleScalarIsNaN(z[0]) && (!muDoubleScalarIsNaN(z[1])))) {
        ex = z[1];
      } else {
        ex = z[0];
      }
    } else {
      g_st.site = &k_emlrtRSI;
      if (!muDoubleScalarIsNaN(z[0])) {
        idx = 1;
      } else {
        idx = 0;
        h_st.site = &l_emlrtRSI;
        if (z.size(1) > 2147483646) {
          i_st.site = &m_emlrtRSI;
          coder::check_forloop_overflow_error(&i_st);
        }
        k = 2;
        exitg1 = false;
        while ((!exitg1) && (k <= last)) {
          if (!muDoubleScalarIsNaN(z[k - 1])) {
            idx = k;
            exitg1 = true;
          } else {
            k++;
          }
        }
      }
      if (idx == 0) {
        ex = z[0];
      } else {
        g_st.site = &j_emlrtRSI;
        ex = z[idx - 1];
        a = idx + 1;
        h_st.site = &n_emlrtRSI;
        if ((idx + 1 <= z.size(1)) && (z.size(1) > 2147483646)) {
          i_st.site = &m_emlrtRSI;
          coder::check_forloop_overflow_error(&i_st);
        }
        for (k = a; k <= last; k++) {
          d = z[k - 1];
          if (ex < d) {
            ex = d;
          }
        }
      }
    }
    coder::linspace(muDoubleScalarCeil(X[X.size(0) - 1]), ex, dv);
    last = 100;
    std::copy(&dv[0], &dv[100], &xRightPad_data[0]);
  }
  // Interpolate them onto z....
  coder::linspace(0.0, muDoubleScalarFloor(X[0]), dv);
  r.set_size(&g_emlrtRTEI, sp, (X.size(0) + last) + 100);
  for (a = 0; a < 100; a++) {
    r[a] = dv[a];
  }
  idx = X.size(0);
  for (a = 0; a < idx; a++) {
    r[a + 100] = X[a];
  }
  for (a = 0; a < last; a++) {
    r[(a + X.size(0)) + 100] = xRightPad_data[a];
  }
  r1.set_size(&h_emlrtRTEI, sp, (Y.size(0) + last) + 100);
  for (a = 0; a < 100; a++) {
    r1[a] = 0.0;
  }
  idx = Y.size(0);
  for (a = 0; a < idx; a++) {
    r1[a + 100] = Y[a];
  }
  for (a = 0; a < last; a++) {
    r1[(a + Y.size(0)) + 100] = 0.0;
  }
  st.site = &d_emlrtRSI;
  coder::interp1(&st, r, r1, z, newY);
  //  Debug plot
  emlrtHeapReferenceStackLeaveFcnR2012b((emlrtCTX)sp);
}

// End of code generation (interpolateOnToZ.cpp)
