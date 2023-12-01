% Main for compile of custom model with Matlab coder...

compilePars = load('compilePars');
cp = compilePars.compilePars;

[out1,out2] = volume_thiolsam_plus_DPPC_polarised_abs(cp{1},cp{2},cp{3},cp{4});

