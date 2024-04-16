function y = logit(x)
    y = zeros(size(x));
    i1 = find(x < eps);
    y(i1) = -36;
    i2 = find(x > 0.9999999999999999);
    y(i2) = 36;
    ind = setdiff(1:numel(x), [i1(:); i2(:)]);
    y(ind) = log(x(ind) ./ (1 - x(ind)));

end
