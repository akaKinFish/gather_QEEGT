function [mont, montage] = get_montage(montage);
    % Return:
    %  1 for average reference
    %  2 for record
    %  3 standard 1020 19 channels Laplace
    %  1 unknown

    montage = setstr(montage);

    [m, n] = size(montage);

    if (m == 7) | (n == 7)

        if n == 7
            montage = montage';
            transp = 1;
        else
            transp = 0;
        end

        cmp = montage(4:7, 1)';

        if strcmp('-AVR', cmp) > 0
            mont = 1;
        elseif strcmp('-A1 ', cmp) > 0
            mont = 2;
        elseif strcmp('-A2 ', cmp) > 0
            mont = 2;
        elseif strcmp('-A12', cmp) > 0
            mont = 2;
        elseif strcmp('-REF', cmp) > 0
            mont = 2;
        elseif strcmp('-L19', cmp) > 0
            mont = 3;
        else
            mont = -1;
        end

        montage = montage(1:3, :);

        if transp
            montage = montage';
        end

    else
        mont = -1;
    end

end
