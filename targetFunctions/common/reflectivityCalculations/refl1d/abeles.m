function ref = abeles(kz,d,rho,irho,sigma)

kz_sq = kz^2 + 4e-6*pi.*rho(1);
k = kz;

B11 = 1;
B22 = 0;
B21 = 0;
B12 = 0;

for n = 1:length(d) - 1

    k_next = sqrt(kz_sq - 4e-6 * pi * complex(rho(n+1),irho(n+1)));
    F = (k - k_next) / (k + k_next);
    F = F * exp(-2 * k * k_next * sigma(n)^2);

    if n == 1
        M11 = 1;
        M22 = 1;
    else
        M11 = exp(1i*k*d(n));
        M22 = exp(-1i*k*d(n));
    end

    M21 = F*M11;
    M12 = F*M22;

    C1 = B11*M11 + B21*M12;
    C2 = B11*M21 + B21*M22;

    B11 = C1;
    B21 = C2;

    C1 = B12*M11 + B22*M12;
    C2 = B12*M21 + B22*M22;
    B12 = C1;
    B22 = C2;

    k = k_next;
end

ref = B12/B11;

end
