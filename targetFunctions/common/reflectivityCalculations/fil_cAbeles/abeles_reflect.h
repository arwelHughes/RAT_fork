#ifndef ABELES_REFLECT_H
#define ABELES_REFLECT_H

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <complex.h>
#include <cblas.h>

/**
 * Calculates the reflectivity of a layered structure using the Abeles matrix method.
 * @param Q The magnitude of the scattering vector.
 * @param N The number of layers in the structure.
 * @param layerSetup A 2D array with N rows and 3 columns. Each row represents a layer and contains
 *        the layer thickness, scattering length density, and roughness (in that order).
 * @return The reflectivity of the structure.
 */
double abeles_reflect(double Q, int N, double layerSetup[N][3], double* R);
double complex findk0(float q, double bulk_in_SLD);
double complex findkn(double complex k0, double sld); 

#endif /* ABELES_REFLECT_H */