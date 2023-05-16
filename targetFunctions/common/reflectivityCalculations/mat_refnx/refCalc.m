% Attempt at a line-byline converstion of refnc refcalc.c to
% Matlab.

function ref = refCalc(xP,thick,sld_re,sld_im,sldSub,sldSuper,rough,sub_rough,back,scale,nLayers)


% In the original AbelesCalc_ImagAll all the coefficients (eg. back, scale etc)
% are in coefP,but we pass these as individual parameters already (so no
% need to extract them from coefP..)

ref = zeros(length(xP),1);

tiny = 1e-30;
oneC = complex(1,0);

% starting from line 135 of refcalc...
sub = complex(sldSub(1),sldSub(2) + tiny);
super = complex(sldSuper,0);

% Fill out the SLD's for all the layers...
for loop = 2:nLayers+1
    t = complex(sld_re(loop-1),abs(sld_im(loop-1)) + tiny);
    SLD(loop) = 1e-6 * 4 * pi * (t - super);

    thickness(loop - 1) = complex(0,abs(thick(loop - 1)));
    rough_sqr(loop - 1) = -2 * rough(loop - 1)^2;
end

SLD(1) = complex(0,0);
SLD(nLayers + 2) = 1e-6 * 4 * pi + (sub - super);
rough_sqr(nLayers + 1) = -2 * sub_rough ^2;
thickness(nLayers + 1) = 0;

% Loop over the points....
npoints = length(xP);
for j = 1:npoints

    qq2 = complex(xP(j)^2 / 4,0);   % Xp input is in K, so q^2 = (2*k)^2 = 4*k^2
    kn = xP(j) / 2;                 % why this??

    for ii = 1:nLayers+1

        % Wavevector in the layer..
        kn_next = sqrt(qq2 - SLD(ii+1));

        % reflectance of the next interface..
        rj = (kn - kn_next)/(kn + kn_next) * exp(kn * kn_next * rough_sqr(ii));

        if ii==1
            % Characteristic matrix of the first interface
            MRtotal(1,1) = oneC;
            MRtotal(1,2) = rj;
            MRtotal(2,2) = oneC;
            MRtotal(2,1) = rj;
        else
            % Work out beta for the layer...
            beta = exp(kn * thickness(ii));

            % Make the characteristic matrix for the layer..
            MI(1,1) = beta;
            MI(1,2) = rj * beta;
            MI(2,2) = oneC / beta;
            MI(1,1) = rj * MI(2,2);

            % Mutiply the matrix by the total...
            MRtotal = MRtotal * MI;
        end

        kn = kn_next;
    end

    num = abs(MRtotal(2,1));
    num = num * num;

    den = abs(MRtotal(1,1));
    den = den * den;

    answer = (num / den);
    answer = (answer * scale) + back;

    ref(j) = answer;

end

end