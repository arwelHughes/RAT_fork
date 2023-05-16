/* This program is public domain */

/**
 *  reflectivity.
 */
#include <iostream>
#include <complex>
#include "reflcalc.h"

// Abeles matrix reflectivity calculation
static void
refl(const int layers,
     const double kz,
     const double depth[],
     const double sigma[],
     const double rho[],
     const double irho[],
     Cplx& R)
{
  const Cplx J(0,1);

  // Check that Q is not too close to zero.
  // For negative Q, reverse the layers.
  const double cutoff = 1e-10;
  int next,step;
  if (kz >= cutoff) {
    next=0;
    step=1;
  } else if (kz <= -cutoff) {
    next=layers-1;
    step=-1;
    sigma -= 1;
  } else {
    R = -1.;
    return;
  }

  // Since sqrt(1/4 * x) = sqrt(x)/2, I'm going to pull the 1/2 into the
  // sqrt to save a multiplication later.
  const double pi4=12.566370614359172e-6;        // 1e-6 * 4 pi
  const double kz_sq = kz*kz + pi4*rho[next];    // kz^2 + 4 pi Vrho
  Cplx k(fabs(kz));

  Cplx B11, B12, B21, B22;
  B11 = B22 = 1;
  B12 = B21 = 0;
#if 0
  std::cout << "kz: " << kz << std::endl;
#endif
  for (int i=0; i < layers-1; i++) {
    // The loop index is not the layer number because we may be reversing
    // the stack.  Instead, n is set to the incident layer (which may be
    // first or last) and incremented or decremented each time through.
    const Cplx k_next = sqrt(kz_sq - pi4*Cplx(rho[next+step],irho[next+step]));
    const Cplx F = (k-k_next)/(k+k_next)*exp(-2.*k*k_next*sigma[next]*sigma[next]);
    const Cplx M11 = (i>0 ? exp(J*k*depth[next]) : 1);
    const Cplx M22 = (i>0 ? exp(-J*k*depth[next]) : 1);
    const Cplx M21 = F*M11;
    const Cplx M12 = F*M22;

#if 0
    std::cout << next
        << " k:" << k << " k_next:" << k_next << " F:" << F
        << " d:" << depth[next] << " sigma:" << sigma[next]
        << " rho:" << rho[next] << " irho:" << irho[next]
        << std::endl;
#endif
    // Multiply existing layers B by new layer M
    // We have unrolled the matrix multiply for speed.
    Cplx C1, C2;
    C1 = B11*M11 + B21*M12;
    C2 = B11*M21 + B21*M22;
    B11 = C1;
    B21 = C2;
    C1 = B12*M11 + B22*M12;
    C2 = B12*M21 + B22*M22;
    B12 = C1;
    B22 = C2;
    next += step;
    k = k_next;
  }


  // And we are done.
  R = B12/B11;
}



extern "C" void
reflectivity_amplitude(const int    layers,
             const double depth[],
             const double sigma[],
             const double rho[],
             const double irho[],
             const int    points,
             const double kz[],
             const int    rho_index[],
             Cplx r[])
{

  for (int i=0; i < points; i++) {
    const int offset = layers*(rho_index!=NULL ? rho_index[i] : 0);
    refl(layers, kz[i], depth, sigma, rho+offset, irho+offset, r[i]);
  }
}