function R = abeles_reflect(Q, N, layers_thick, layers_rho, layers_sig)
% N = number of layers in total (including bulk in and bulk out), for example
% for a system of air|tails|heads|water  N=4.

nom1 = 0;
denom1 = 0;
sigmasqrd = 0;
sld_1 = 0;
sld_n = 0;
sld_np1 = 0;
bulk_in_SLD = 0;

r01 = 0 + 0i;
err1 = 0 + 0i;
err_n = 0 + 0i;
phaseFctr = 0 + 0i;
r_n_np1 = 0 + 0i;
k1 = 0 + 0i;
kn = 0 + 0i;
knp1 = 0 + 0i;
nom_n = 0 + 0i;
denom_n = 0 + 0i;
kn_ptr = 0 + 0i;

alpha = 1.0 + 0.0i;
beta = 0.0 + 0.0i;

M_n = zeros(2, 2) + 0i;
M_tot = eye(2) + 0i;
M_res = zeros(2, 2) + 0i;

% Find k0 from Q:
bulk_in_SLD = layers_rho(1);
k0 = findk0(Q, bulk_in_SLD) + 0.0i;

for n = 1:N-1 % n < 3 for (0,1,2,3) layers

    if n == 1 % n=0

        % Find k1
        sld_1 = layers_rho(n + 1) - bulk_in_SLD;
        k1 = findkn(k0, sld_1);

        % Find r01
        nom1 = k0 - k1;
        denom1 = k0 + k1;
        sigmasqrd = layers_sig(n + 1) ^ 2;
        err1 = exp(-2 * k1 * k0 * sigmasqrd);
        r01 = (nom1 / denom1) * err1;

        % Generate the M1 matrix:
        M_tot = [1.0, r01; r01, 1.0];

        % Point to the k1 via kn_ptr:
        kn_ptr = k1;

    else % n=1, n=2 ...

        % Fetch sld_n+1 (ex. sld_2 for n=1):
        sld_np1 = layers_rho(n + 1) - bulk_in_SLD;

        % Find kn and k_n+1 (ex. k1 and k2 for n=1):
        kn = kn_ptr;
        knp1 = findkn(k0, sld_np1); % knp1 = k_(n+1)

        % Find r_n,n+1:
        nom_n = kn - knp1;
        denom_n = kn + knp1;
        sigmasqrd = layers_sig(n + 1) ^ 2;
        err_n = exp(-2 * kn * knp1 * sigmasqrd);
        r_n_np1 = (nom_n / denom_n) * err_n;

        % Find the Phase Factor = (k_n * d
        phaseFctr = kn * layers_thick(n);

        % Create the M_n matrix:
        M_n = [exp(1i * phaseFctr), r_n_np1 * exp(1i * phaseFctr);
            r_n_np1 * exp(-1i * phaseFctr), exp(-1i * phaseFctr)];

        % Create Empty M_res matrix for (M_tot x M_n) result
        M_res = zeros(2, 2) + 0i;

        % Multiply the matrices
        M_res(1, 1) = M_tot(1, 1) * M_n(1, 1) + M_tot(1, 2) * M_n(2, 1);
        M_res(1, 2) = M_tot(1, 1) * M_n(1, 2) + M_tot(1, 2) * M_n(2, 2);
        M_res(2, 1) = M_tot(2, 1) * M_n(1, 1) + M_tot(2, 2) * M_n(2, 1);
        M_res(2, 2) = M_tot(2, 1) * M_n(1, 2) + M_tot(2, 2) * M_n(2, 2);

        % Reassign the values back to M_tot:
        M_tot = M_res;

        % Point to k_n+1 and sld_n+1 via kn_ptr sld_n_ptr:
        kn_ptr = knp1;
    end
end

R = abs(M_tot(2, 1) / M_tot(1, 1))^2;

end

function k0 = findk0(q, bulk_in_SLD)
q_sqrd = q^2;
k0 = sqrt((q_sqrd / 4) + 4 * pi * bulk_in_SLD) + 0.0i;
end

function k = findkn(k0, sld)
subtr = k0^2 - 4 * pi * sld;
k = sqrt(subtr);
end





