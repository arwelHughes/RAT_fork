function y = gaussian_convolution(xin, yin, x, dx)

    % Convolve the input function yin(xin) with a Gaussian resolution
    % function.
    %
    % For each output point xo = x(k_out), the calculation is
    %
    %   y(xo) = integral[ yin(x) * G(xo-x; sigma) dx ]
    %
    % where
    %
    %   G(xo-x; sigma) = 1/(sqrt(2*pi)*sigma)
    %                    * exp(-(xo-x)^2/(2*sigma^2))
    %
    % The input function yin(xin) is assumed to be piecewise linear
    % between the supplied xin points. The convolution integral over
    % each linear segment can then be evaluated analytically.
    %
    % sigma = dx(k_out) is the Gaussian resolution width associated
    % with each output point.

    y = zeros(size(x));
    Nin = numel(xin);
    Nout = numel(x);

    % log(0.001). This is used to truncate the Gaussian when its
    % amplitude has fallen to 0.1% of its maximum.
    LOG_RESLIMIT = -6.90775527898213703123;

    % Index of the input point near the left-hand edge of the
    % Gaussian integration range. This is carried between output
    % points to avoid repeatedly searching from the beginning.
    k_in = 1;

    for k_out = 1:Nout

        % Gaussian resolution width for this output point.
        sigma = dx(k_out);

        % Output coordinate at which we want the convolved value.
        xo = x(k_out);

        % Truncate the Gaussian when it has fallen to 0.1% of
        % its peak value.
        %
        % exp(-limit^2/(2*sigma^2)) = 0.001
        %
        % Therefore
        %
        %   limit = sqrt(-2*sigma^2*log(0.001))
        %         ~= 3.717*sigma
        %
        % so the convolution only needs to consider approximately
        %
        %   xo - 3.717*sigma  <= x <=  xo + 3.717*sigma.
        limit = sqrt(-2.0 * sigma * sigma * LOG_RESLIMIT);


        % Find the first input point at or just after the left-hand
        % edge of the Gaussian integration range.
        while k_in < Nin && xin(k_in) < xo - limit
            k_in = k_in + 1;
        end

        % Move back one point if necessary so that k_in is the input
        % point immediately before (or near) xo-limit.
        while k_in > 1 && xin(k_in) > xo - limit
            k_in = k_in - 1;
        end


        if sigma > 0

            % Perform the actual Gaussian convolution at xo.
            %
            % convolveGaussianPoint treats yin(xin) as a piecewise
            % linear function and integrates each linear segment
            % analytically against the Gaussian resolution function.
            y(k_out) = convolveGaussianPoint( ...
                xin, yin, k_in, Nin, xo, limit, sigma);

        elseif k_in < Nin

            % If sigma = 0 there is no resolution broadening.
            % Simply linearly interpolate yin at xo.

            m = (yin(k_in + 1) - yin(k_in)) / ...
                (xin(k_in + 1) - xin(k_in));

            b = yin(k_in) - m * xin(k_in);

            y(k_out) = m * xo + b;

        elseif k_in > 1

            % If sigma = 0 and xo lies beyond the final input point,
            % linearly extrapolate from the final two points.

            m = (yin(k_in) - yin(k_in - 1)) / ...
                (xin(k_in) - xin(k_in - 1));

            b = yin(k_in) - m * xin(k_in);

            y(k_out) = m * xo + b;
        end
    end
end


function out = convolveGaussianPoint(xin, yin, k, n, xo, limit, sigma)

    SQRT2 = 1.41421356237309504880;
    SQRT2PI = 2.50662827463100050241;

    % Precompute quantities that are constant for this output point.
    %
    % These would otherwise be recalculated for every input interval.
    inv_sqrt2sigma = 1.0 / (SQRT2 * sigma);
    sigma_over_sqrt2pi = sigma / SQRT2PI;

    % 2*sigma^2, used in the Gaussian exponent.
    two_sigma_sq = 2.0 * sigma * sigma;


    % ---------------------------------------------------------------
    % Initialise at the first input point.
    % ---------------------------------------------------------------

    % Distance from the input point to the output position.
    z = xo - xin(k);

    % Unnormalised Gaussian at this point:
    %
    %   G = exp(-(xo-x)^2/(2*sigma^2))
    %
    Glo = exp(-z * z / two_sigma_sq);

    % The integral of the Gaussian is expressed in terms of erf:
    %
    %   erf(-(xo-x)/(sqrt(2)*sigma))
    %
    erfmin = erf(-z * inv_sqrt2sigma);
    erflo = erfmin;

    % Accumulate the convolution integral here.
    y = 0;


    % ---------------------------------------------------------------
    % Integrate over the piecewise-linear input function.
    % ---------------------------------------------------------------

    while k < n

        k = k + 1;

        % Ignore duplicate input points.
        if xin(k) ~= xin(k - 1)

            % Distance from the new input point to xo.
            zhi = xo - xin(k);

            % Dimensionless distance in units of sigma:
            %
            %   u = -(xo-x)/(sqrt(2)*sigma)
            %
            u = -zhi * inv_sqrt2sigma;

            % Unnormalised Gaussian at the new endpoint.
            Ghi = exp(-u * u);

            % Error-function value at the new endpoint.
            erfhi = erf(u);


            % -------------------------------------------------------
            % Linear interpolation between the two input points.
            %
            %   yin(x) = m*x + b
            % -------------------------------------------------------

            m = (yin(k) - yin(k - 1)) / ...
                (xin(k) - xin(k - 1));

            b = yin(k) - m * xin(k);


            % -------------------------------------------------------
            % Analytically integrate
            %
            %   (m*x + b) * Gaussian(x)
            %
            % over this input interval.
            %
            % The first term comes from the integral of the
            % Gaussian and therefore contains erf().
            %
            % The second term comes from the integral of
            % (x-xo)*Gaussian and therefore contains Ghi-Glo.
            % -------------------------------------------------------

            y = y ...
                + 0.5 * (m * xo + b) * (erfhi - erflo) ...
                - sigma_over_sqrt2pi * m * (Ghi - Glo);


            % Current endpoint becomes the lower endpoint for
            % the next interval.
            Glo = Ghi;
            erflo = erfhi;


            % Stop once we have reached the upper Gaussian limit.
            %
            % limit ~= 3.717*sigma, corresponding to a Gaussian
            % amplitude of approximately 0.1% of its peak.
            if xin(k) >= xo + limit
                break
            end
        end
    end


    % ---------------------------------------------------------------
    % Normalisation
    % ---------------------------------------------------------------
    %
    % The Gaussian has been truncated to approximately +/-3.717*sigma,
    % so its integrated area is slightly less than one.
    %
    % The erf difference gives the area of this truncated Gaussian.
    % Renormalising ensures that a constant input function remains
    % constant after convolution.
    % ---------------------------------------------------------------

    out = 2 * y / (erflo - erfmin);

end