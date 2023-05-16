clear

q = linspace(0.001,0.4,1000);
q = q(:);

layers = [16000 0  3;
    200 4e-6 3;
    100 1e-6 3;
    16000 6.3e-6 4];

thick = layers(:,1);
rho = layers(:,2);
rough = layers(:,3);
N = length(thick);

R = abeles_reflect_matlab(q,N,thick,rho,rough);

layers = [0 2.073e-6  3;
    200 4e-6 3;
    100 1e-6 3;
    0 6.3e-6 4];


thick = layers(:,1);
rho = layers(:,2);
rough = layers(:,3);
N = length(thick);

R2 = abeles_reflect_matlab(q,N,thick,rho,rough);

% Multilayer....
sld3 = [200 4e-6 3;
    100 1e-6 3];

repeats = 10;
allSld  = sld3;
for i = 1:repeats
    allSld = [allSld ; sld3];
end

layers = [0 2.073e-6 3 ; allSld ; 0 6.3e-6 4];


thick = layers(:,1);
rho = layers(:,2);
rough = layers(:,3);
N = length(thick);

R3 = abeles_reflect_matlab(q,N,thick,rho,rough);

figure(1); clf
semilogy(q,R);
hold on
semilogy(q,R2);
semilogy(q,R3);