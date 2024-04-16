function lmin = minloc(x)

    if ~isreal(x)
        x = real(x);
    end

    lmin = [];

    if size(x, 1) == 1
        x = x';

    end

    if size(x, 2) ~= 1
        return;
    end

    ll = size(x, 1);
    l = ll(1);

    for i = 2:l - 1

        if (x(i - 1) > x(i)) & (x(i) < x(i + 1))
            lmin = [lmin; i];
        end

    end

    if isempty(lmin)
        [kk, lmin] = min(x);
        return;
    end

    ratio = zeros(length(lmin), 1);

    for k = 1:length(lmin)
        ii = find((x(lmin(k) - 1:-1:1) - x(lmin(k))) < 0);

        if ~isempty(ii)
            nantes = ii(1) - 1;
        else
            nantes = lmin(k) - 1;
        end

        ii = find((x(lmin(k) + 1:end) - x(lmin(k))) < 0);

        if ~isempty(ii)
            ndesp = ii(1) - 1;
        else
            ndesp = length(x) - lmin(k);
        end

        ratio(k) = min(nantes, ndesp);
    end

    ii = find(ratio < 3);
    lim(ii) = [];

    if isempty(lmin)
        [kk, lmin] = min(x);
        return;
    end

end
