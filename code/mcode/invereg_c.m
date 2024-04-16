function [XtX, lambda, Glambda, reg_param, G] = invereg_c(U, s, V, YtY, autom_lambda, lambda, leftbound, rightbound)

    [n, ~, m] = size(YtY);
    p = length(s);
    onesm = ones(1, m);
    s2 = s .^ 2;
    reg_sigma = diag((s ./ (s2 + lambda .^ 2)) * onesm);
    left_T = V * pinv(reg_sigma) * U';
    right_T = U * pinv(reg_sigma') * V';

    if nargin < 6
        lambda = -1;
    end

    if nargin < 7
        leftbound = -1;
    end

    if nargin < 8
        rightbound = [];
    end

    rho2_v = [];

    if isempty(lambda) | (lambda == -1)

        % Set defaults.
        npoints = 100; % Number of points on the curve.
        smin_ratio = 16 * eps; % Smallest regularization parameter.

        % Initialization.
        No_Ok = 1;
        reg_param = zeros(npoints, 1);
        G = reg_param;

        while No_Ok
            reg_param(npoints) = max([s(p), s(1) * smin_ratio, leftbound]);

            if isempty(rightbound)
                ratio = 1.2 * (s(1) ./ reg_param(npoints)) .^ (1 / (npoints - 1));

                for i = npoints - 1:-1:1
                    reg_param(i) = ratio * reg_param(i + 1);
                end

            else

                reg_param = linspace(rightbound, reg_param(npoints), npoints)';

            end

            for i = 1:npoints
                tmp = reg_param(i) * reg_param(i);
                f1 = tmp ./ (s2 + tmp);
                left_tmp = V * pinv(f1 * onesm) * U';
                right_tmp = U * pinv(f1 * onesm') * V';
                fb = left_tmp * YtY * right_tmp;
                rho2_v = fb(:)' * fb(:);
                tmp = sum(f1);
                tmp = tmp * tmp;
                G(i) = rho2_v / tmp;
            end

            [mGlambda, mminGi] = min(G);
            lmin = minloc(G);
            np = length(lmin);

            if np == 1
                minGi = lmin;
            else
                ind = find((lmin == npoints) | (lmin == 1));
                lmin(ind) = [];

                if isempty(lmin)

                    if G(npoints) > G(1)
                        minGi = 1;
                    else
                        minGi = npoints;
                    end

                else
                    [aa, bb] = min(G(lmin));
                    minGi = lmin(bb);
                end

            end

            Glambda = real(G(minGi));
            lambda = reg_param(minGi);

            if 0
                %  figure
                loglog(reg_param, G, '-'), xlabel('lambda'), ylabel('G(lambda)')
                title('GCV function')
                HoldState = ishold; hold on;
                loglog([lambda, lambda], [Glambda / 1000, Glambda], ':')
                loglog(lambda, Glambda, '*');
                title(['GCV function, minimum at ', num2str(lambda)])
                if (~HoldState), hold off; end
                drawnow; pause
            end

            No_Ok = 0;

        end

    else
        Glambda = -1;
    end

    % \ begin{gathered}
    % Y = U \ Sigma V ^ {*}X \ \
    % \ frac{1}{N} \ sum_{n = 1} ^ {N}Y_{n}Y_{n} ^ {H} = \ frac{1}{N} \ sum_{n = 1} ^ {N}U \ Sigma V ^ {*}(U \ Sigma V ^ {*}X) ^ {*} \ \
    % V \ Sigma ^ {*}U \ sum_{n = 1} ^ {N}Y_{n}Y_{n} ^ {H}U(\ Sigma ^ {*}) ^ {-1}V ^ {*} = \ sum_{n = 1} ^ {N}XX ^ {*}
    % \ end{gathered}

    XtX = left_T * YtY * right_T;
end
