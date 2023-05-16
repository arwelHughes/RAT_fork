



q = linspace(0.01,0.3,1000);


layers = [ % depth rho irho sigma
                0, 1.0, 0.0, 10.0
              200, 2.0, 1.0, 10.0
              200, 4.0, 0.0, 10.0
                0, 2.0, 0.0,  0.0];



for i = 1:length(q)
    thisq = q(i);
    kz = thisq / 2;

    rho = layers(:,2);
    irho = layers(:,3);
    d = layers(:,1);
    rough = layers(:,4);

    r(i) = abeles(kz,d,rho,irho,rough);
end