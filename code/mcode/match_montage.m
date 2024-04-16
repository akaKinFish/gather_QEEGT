function [newmont, indnozero] = match_montage(montage)

    % MATCH_MONTAGE - Match electrode montage to predefined standard montage.
    %   [newmont, indnozero] = match_montage(montage) takes an electrode montage
    %   as input and matches it to a predefined standard montage. It returns
    %   the matched montage indices in the 'newmont' vector and the indices of
    %   non-zero elements in 'newmont' in the 'indnozero' vector.
    %
    %   Input:
    %       montage - Character matrix representing the electrode montage to be
    %                 matched.
    %
    %   Output:
    %       newmont - Column vector of matched montage indices. Zero values
    %                 indicate unmatched leads.
    %       indnozero - Column vector of indices corresponding to non-zero
    %                   elements in 'newmont'.
    %
    %   Example:
    %       montage = ['F3-Cz'; 'Cz-P3'; 'P4-F4'];
    %       [newmont, indnozero] = match_montage(montage);
    %       disp(newmont);
    %       disp(indnozero);
    %
    %   See also: mayus

    if size(montage, 1) < size(montage, 2)
        montage = montage';
    end

    montage = setstr(montage);
    montage = mayus(montage);

    nder_norms = 119;
    newmont = zeros(nder_norms, 1);

    % Leads that have been normalized. Leads 56 and 57 are not normalized
    nderiv = cell(nder_norms, 2);

    for k = 1:55
        nderiv{k, 1} = num2str(k);
        nderiv{k, 2} = '';
    end

    for k = 58:120;
        nderiv{k, 1} = num2str(k);
        nderiv{k, 2} = '';
    end

    nderiv{1, 2} = 'FP1';
    nderiv{2, 2} = 'FP2';
    nderiv{3, 2} = 'F3';
    nderiv{4, 2} = 'F4';
    nderiv{5, 2} = 'C3';
    nderiv{6, 2} = 'C4';
    nderiv{7, 2} = 'P3';
    nderiv{8, 2} = 'P4';
    nderiv{9, 2} = 'O1';
    nderiv{10, 2} = 'O2';
    nderiv{11, 2} = 'F7';
    nderiv{12, 2} = 'F8';
    nderiv{13, 2} = 'T3';
    nderiv{14, 2} = 'T4';
    nderiv{15, 2} = 'T5';
    nderiv{16, 2} = 'T6';
    nderiv{17, 2} = 'FZ';
    nderiv{18, 2} = 'CZ';
    nderiv{19, 2} = 'PZ';

    mm = cell(size(montage, 1), 1);

    for k = 1:size(montage, 1)
        mm{k} = strtok(montage(k, :), '-');
        mm{k} = strtok(mm{k}, '_');
        mm{k} = deblank(mm{k});
    end

    for h = 1:size(nderiv, 1)

        for k = 1:size(montage, 1)

            if strcmp(nderiv{h, 1}, mm{k}) || strcmp(nderiv{h, 2}, mm{k})
                newmont(h) = k;
                break;
            end

        end

    end

    indnozero = find(newmont ~= 0);
    newmont = newmont(:);
    indnozero = indnozero(:);

end
