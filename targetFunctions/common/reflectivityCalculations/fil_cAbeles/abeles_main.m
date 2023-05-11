clear





q = linspace(0.001,0.1,100);
q = q(:);

sld = [1e6 0  3;
    200 4e-6 3;
    100 1e-6 3;
    1e6 6.3e-6 4];

R = abelesReflectWrapper_mex(q,sld);

