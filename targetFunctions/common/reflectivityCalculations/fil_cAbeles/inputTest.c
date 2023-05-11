

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <complex.h>

#define PI	3.14159265358979323846	/*  pi    */



double inputTest(int N, double in[N][2], double* out) {

    /* test to make sure the inputs from 
       Matlab come in and go out in the correct
       way */

    out[0] = in[0][0] * 2.0;
    out[1] = in[0][1] * 2.0;
    out[2] = in[1][0] * 2.0;
    out[3] = in[1][1] * 2.0;

    return 0;

}