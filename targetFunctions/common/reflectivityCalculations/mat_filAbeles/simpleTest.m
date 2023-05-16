

% data = dlmread('test6.dat');
% q = data(:,1);


q = linspace(0.0015,0.05,1000);
q = q(:);

layers = [0    complex(2.073e-6,0)             0
    1.2e3   complex(4.66e-6,1.6e-8) 10
    0       complex(6.3e-6,0)       4];

thick = layers(:,1);
rho = layers(:,2);
rough = layers(:,3);
N = length(thick);

R = abeles_reflect_matlab(q,N,thick,rho,rough);

figure(1); clf
semilogy(q,R);

% hold on
% semilogy(q,data(:,2));


