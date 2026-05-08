


z = 1:100;

zCen = 50;
zW = 10;

b = (z - zCen) / (sqrt(2) * zW);
f = erfc(b);


zMax = (erfcinv(0.01) * sqrt(2) * zW) + zCen;



figure(1); clf;
plot(z,f);
hold on
xline(zMax)