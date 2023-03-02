
% Main for working with custom script....
params = [3.0000   20.0000    0.2000   55.0000    0.2000    0.1000    4.0000    2.0000];
bulk_out = [6.35e-6 ; 0 ; 0];
bulk_in = 2.073e-6;
contrast = 1;

[output,sub_rough] = customBilayer(params,bulk_in,bulk_out,contrast);