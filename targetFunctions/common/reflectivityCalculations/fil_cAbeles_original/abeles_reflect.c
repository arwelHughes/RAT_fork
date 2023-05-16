/* 
 * Abeles Algorithm for computing Neutron Reflectivity 
 * from multiple layers model
 * 
 * 
 * Author: Filip Ciesielski
 * August 2013
 */

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <complex.h>

#define PI	3.14159265358979323846	/*  pi    */

double complex findk0(float q, double bulk_in_SLD) {

    double complex k0;
    double q_sqrd = pow(q, 2);

    k0 = sqrt((q_sqrd / 4) + 4 * PI * bulk_in_SLD) + 0.0 * I;

    return k0;
}


double complex findkn(double complex k0, double sld) {

    double complex k;
    double complex subtr;

    subtr = cpow(k0, 2) - 4 * PI * sld;
    k = csqrt(subtr);

    return k;
}


double abeles_reflect(double Q, int N, double* layers_thick, double* layers_rho, double* layers_sig, double* R_out) {
    /* N = number of layers in total (including bulk in and bulk out), for example
     * for a system of air|tails|heads|water  N=4.
     */       

    double nom1, denom1, sigmasqrd, sld_1, sld_n, sld_np1;
    double bulk_in_SLD;
    
    double complex r01, err1, err_n, phaseFctr, r_n_np1;
    double complex k1, kn, knp1, nom_n, denom_n;
    double complex *kn_ptr;        
    
    double complex alpha = 1.0 + 0.0 * I;
    double complex beta = 0.0 + 0.0 * I;
    
    double complex M_n[4];
    double complex M_tot[4]; 
    double complex M_res[4];

    double R;
    
    /* Find k0 from Q:*/
    bulk_in_SLD = layers_rho[0];
    double complex k0;
    k0 = findk0(Q, bulk_in_SLD) + 0.0 * I;

    int n;
    for (n = 0; n < N-1; n++) {    /* n < 3 for (0,1,2,3) layers */

        if (n == 0) { /* n=0 */

            /* Find k1 */        
            sld_1 = layers_rho[n + 1] - bulk_in_SLD;
            k1 = findkn(k0, sld_1);

            /* Find r01 */
            nom1 = k0 - k1;
            denom1 = k0 + k1;
            sigmasqrd = pow(layers_sig[n + 1], 2);
            err1 = exp(-2 * k1 * k0 * sigmasqrd);
            r01 = (nom1 / denom1) * err1;

            /* Generate the M1 matrix: */
            M_tot[0] = 1.0 + 0.0 * I;
            M_tot[1] = r01;
            M_tot[2] = r01;
            M_tot[3] = 1.0 + 0.0 * I;             
            
            /* Point to the k1 via kn_ptr: */            
            kn_ptr = &k1;            
            
        } else { /* n=1, n=2 ...*/                           
            
            /* Fetch sld_n+1 (ex. sld_2 for n=1): */            
            sld_np1 = layers_rho[n + 1] - bulk_in_SLD;
            
            /* Find kn and k_n+1 (ex. k1 and k2 for n=1): */
            kn = *kn_ptr;
            knp1 = findkn(k0, sld_np1);/*knp1 = k_(n+1) */            
            
            /* Find r_n,n+1: */
            nom_n = kn - knp1;
            denom_n = kn + knp1;
            sigmasqrd = pow(layers_sig[n + 1], 2);
            err_n = exp(-2 * kn * knp1 * sigmasqrd);
            r_n_np1 = (nom_n / denom_n) * err_n;

            /*Find the Phase Factor = (k_n * d_n)  */
            phaseFctr = kn * layers_thick[n];
            
            /* Create the M_n matrix: */        
            M_n[0] = cpow(exp(1.0), phaseFctr*I);
            M_n[1] = r_n_np1 * cpow(exp(1.0), phaseFctr*I);
            M_n[2] = r_n_np1 * cpow(exp(1.0), (-1)*phaseFctr*I);
            M_n[3] = cpow(exp(1.0), (-1)*phaseFctr*I);                       

            /*Creat Empty M_res matrix for (M_tot x M_n) result*/
            M_res[0] = 0.0;
            M_res[1] = 0.0;
            M_res[2] = 0.0;
            M_res[3] = 0.0;

            /* Multiply the matricies*/
            M_res[0] = M_tot[0] * M_n[0] + M_tot[1] * M_n[2];
            M_res[1] = M_tot[0] * M_n[1] + M_tot[1] * M_n[3];
            M_res[2] = M_tot[2] * M_n[0] + M_tot[3] * M_n[2];
	        M_res[3] = M_tot[2] * M_n[1] + M_tot[3] * M_n[3];   
            
            /*Reassign the values back to M_tot:*/
            M_tot[0] = M_res[0];
            M_tot[1] = M_res[1];
            M_tot[2] = M_res[2];
            M_tot[3] = M_res[3];                               
                                 
            /* Point to k_n+1 and sld_n+1  via kn_ptr sld_n_ptr: */     
            kn_ptr = &knp1;
        }
    };
    
    R = cabs(M_tot[2]/M_tot[0]);
    R = pow(R, 2.0);
    
    R_out[0] = R;

    return 0;
}











