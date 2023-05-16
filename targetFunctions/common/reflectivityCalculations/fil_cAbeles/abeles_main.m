clear

q = linspace(0.001,0.1,100);
q = q(:);

sld = [0 0  0 3;
    200 4e-6 0 3;
    100 1e-6 0 3;
    0 6.3e-6 0 4];

R = abelesReflectWrapper_mex(q,sld);

sld2 = [0 2.073e-6 0 3;
    200 4e-6 1e-8 3;
    100 1e-6 1e-8 3;
    0 6.3e-6 0 4];

R2 = abelesReflectWrapper_mex(q,sld2);


figure(1); clf
semilogy(q,R);
hold on
semilogy(q,R2);


