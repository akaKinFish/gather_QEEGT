function mat_H = com2her(Comp)

    if size(Comp, 2) > 1
        nd = size(Comp, 1);
    else
        nd = length(Comp);
        Comp = Comp(:);
    end

    [nd1, nd2, nf] = size(Comp);

    if nd1 - nd2 ~= 0
        error('Matrix can not be square')
    end

    mat_H = zeros(nd, nd, nf);

    for k = 1:nf
        mat_R = Comp(:, :, k);
        tri = tril(mat_R, -1);
        mat_H(:, :, k) = triu(mat_R) + triu(mat_R, 1)' +i .* (tri' - tri);
    end

    %#inbounds
    %mbreal(Comp); mbreal(mat_R); mbreal(tri);

end
