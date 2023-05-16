#ifndef _REFLCALC_H
#define _REFLCALC_H


// For C++ use the standard complex double type
// For C just use an array of doubles
// Note: C99 could use complex double.
#ifdef __cplusplus
# include <complex>
# include <cmath>
  typedef std::complex<double> Cplx;
#else
# include <math.h>
  typedef double Cplx;
#endif

 // Inclusion from C
#ifdef __cplusplus
    extern "C" {
#endif


void
reflectivity_amplitude(const int layers,
                       const double d[], const double sigma[],
                       const double rho[], const double irho[],
                       const int points,
                       const double kz[], const int rho_offset[],
                       Cplx r[]);



#ifdef __cplusplus
}
#endif

#endif /* _REFLCALC_H */



