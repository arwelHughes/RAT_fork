

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <complex.h>

#define PI	3.14159265358979323846	/*  pi    */



double inputTest(int N, double* in, double* out) {

    /* test to make sure the inputs from 
       Matlab come in and go out in the correct
       way */
    double R;

    /*out[0] = in[0] * 2.0;
    out[1] = in[1] * 2.0;
    out[2] = in[2] * 2.0;
    out[3] = in[3] * 2.0;*/

    R = 2 + 2;

    out[0] = R;

    return 0;

}