//
// Non-Degree Granting Education License -- for use at non-degree
// granting, nonprofit, education, and research organizations only. Not
// for commercial or industrial use.
// File: customBilayer.cpp
//
// MATLAB Coder version            : 5.5
// C/C++ source code generated on  : 02-Mar-2023 09:25:27
//

// Include Files
#include "customBilayer.h"
#include "coder_array.h"
#include "dylib.hpp"

// Function Definitions
//
// function [output,sub_rough] = customBilayer(params,bulk_in,bulk_out,contrast)
//
// CUSTOMBILAYER  RASCAL Custom Layer Model File.
//
//
//  This file accepts 3 vectors containing the values for
//  Params, bulk in and bulk out
//  The final parameter is an index of the contrast being calculated
//  The m-file should output a matrix of layer values, in the form..
//  Output = [thick 1, SLD 1, Rough 1, Percent Hydration 1, Hydrate how 1
//            ....
//            thick n, SLD n, Rough n, Percent Hydration n, Hydration how n]
//  The "hydrate how" parameter decides if the layer is hydrated with
//  Bulk out or Bulk in phases. Set to 1 for Bulk out, zero for Bulk in.
//  Alternatively, leave out hydration and just return..
//  Output = [thick 1, SLD 1, Rough 1,
//            ....
//            thick n, SLD n, Rough n] };
//  The second output parameter should be the substrate roughness
//
// Arguments    : const ::coder::array<double, 2U> &params
//                double bulk_in
//                const ::coder::array<double, 1U> &bulk_out
//                double contrast
//                double output[3][6]
//                double *sub_rough
// Return Type  : void
//
namespace bilayer
{
  DYLIB_API void customBilayer(const ::coder::array<double, 2U> &params, double, const ::
                     coder::array<double, 1U> &bulk_out, double contrast, double
                     output[3][6], double *sub_rough)
  {
    double head_idx_0;
    double head_idx_1;
    double head_idx_1_tmp;
    double head_idx_2;
    double tail_idx_0;
    double tail_idx_1;
    double tail_idx_2;

    // 'customBilayer:20' sub_rough = params(1);
    *sub_rough = params[0];

    // 'customBilayer:21' oxide_thick = params(2);
    // 'customBilayer:22' oxide_hydration = params(3);
    // 'customBilayer:23' lipidAPM = params(4);
    // 'customBilayer:24' headHydration = params(5);
    // 'customBilayer:25' bilayerHydration = params(6);
    // 'customBilayer:26' bilayerRough = params(7);
    // 'customBilayer:27' waterThick = params(8);
    //  We have a constant SLD for the bilayer
    // 'customBilayer:31' oxide_SLD = 3.41e-6;
    //  Now make the lipid layers..
    //  Use known lipid volume and compositions
    //  to make the layers
    //  define all the neutron b's.
    // 'customBilayer:38' bc = 0.6646e-4;
    // Carbon
    // 'customBilayer:39' bo = 0.5843e-4;
    // Oxygen
    // 'customBilayer:40' bh = -0.3739e-4;
    // Hydrogen
    // 'customBilayer:41' bp = 0.513e-4;
    // Phosphorus
    // 'customBilayer:42' bn = 0.936e-4;
    // Nitrogen
    // 'customBilayer:43' bd = 0.6671e-4;
    // Deuterium
    //  Now make the lipid groups..
    // 'customBilayer:46' COO = (4*bo) + (2*bc);
    // 'customBilayer:47' GLYC = (3*bc) + (5*bh);
    // 'customBilayer:48' CH3 = (2*bc) + (6*bh);
    // 'customBilayer:49' PO4 = (1*bp) + (4*bo);
    // 'customBilayer:50' CH2 = (1*bc) + (2*bh);
    // 'customBilayer:51' CHOL = (5*bc) + (12*bh) + (1*bn);
    //  Group these into heads and tails:
    // 'customBilayer:54' Head = CHOL + PO4 + GLYC + COO;
    // 'customBilayer:55' Tails = (34*CH2) + (2*CH3);
    //  We need volumes for each.
    //  Use literature values:
    // 'customBilayer:59' vHead = 319;
    // 'customBilayer:60' vTail = 782;
    //  we use the volumes to calculate the SLD's
    // 'customBilayer:63' SLDhead = Head / vHead;
    // 'customBilayer:64' SLDtail = Tails / vTail;
    //  We calculate the layer thickness' from
    //  the volumes and the APM...
    // 'customBilayer:68' headThick = vHead / lipidAPM;
    // 'customBilayer:69' tailThick = vTail / lipidAPM;
    //  Manually deal with hydration for layers in
    //  this example.
    // 'customBilayer:73' oxSLD = (oxide_hydration * bulk_out(contrast)) + ((1 - oxide_hydration) * oxide_SLD);
    // 'customBilayer:74' headSLD = (headHydration * bulk_out(contrast)) + ((1 - headHydration) * SLDhead);
    // 'customBilayer:75' tailSLD = (bilayerHydration * bulk_out(contrast)) + ((1 - bilayerHydration) * SLDtail);
    //  Make the layers
    // 'customBilayer:78' oxide = [oxide_thick oxSLD sub_rough];
    // 'customBilayer:79' water = [waterThick bulk_out(contrast) bilayerRough];
    // 'customBilayer:80' head = [headThick headSLD bilayerRough];
    head_idx_0 = 319.0 / params[3];
    head_idx_1_tmp = bulk_out[static_cast<int>(contrast) - 1];
    head_idx_1 = params[4] * head_idx_1_tmp + (1.0 - params[4]) *
      2.0103761755485893E-6;
    head_idx_2 = params[6];

    // 'customBilayer:81' tail = [tailThick tailSLD bilayerRough];
    tail_idx_0 = 782.0 / params[3];
    tail_idx_1 = params[5] * head_idx_1_tmp + (1.0 - params[5]) *
      -5.9554987212276231E-7;
    tail_idx_2 = params[6];

    // 'customBilayer:83' output = [oxide ; water ; head ; tail ; tail ; head];
    output[0][0] = params[1];
    output[1][0] = params[2] * head_idx_1_tmp + (1.0 - params[2]) * 3.41E-6;
    output[2][0] = params[0];
    output[0][1] = params[7];
    output[1][1] = head_idx_1_tmp;
    output[2][1] = params[6];
    output[0][2] = head_idx_0;
    output[0][3] = tail_idx_0;
    output[0][4] = tail_idx_0;
    output[0][5] = head_idx_0;
    output[1][2] = head_idx_1;
    output[1][3] = tail_idx_1;
    output[1][4] = tail_idx_1;
    output[1][5] = head_idx_1;
    output[2][2] = head_idx_2;
    output[2][3] = tail_idx_2;
    output[2][4] = tail_idx_2;
    output[2][5] = head_idx_2;
  }
}
