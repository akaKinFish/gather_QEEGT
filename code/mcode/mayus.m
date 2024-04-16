function y = mayus(x)

    % MAYUS - Convert lowercase letters to uppercase in a character matrix.
    %   y = mayus(x) takes a character matrix 'x' as input and returns a new
    %   character matrix 'y' where all lowercase letters in 'x' are converted
    %   to uppercase. Other characters in 'x' remain unchanged.
    %
    %   Input:
    %       x - Character matrix to be converted.
    %
    %   Output:
    %       y - Converted character matrix with lowercase letters converted to
    %           uppercase.
    %
    %   Example:
    %       x = ['Hello'; 'WorlD'];
    %       y = mayus(x);
    %       disp(y);
    %
    %   See also: upper, lower
    %#inbounds
    %#realonly

    y = zeros(size(x));
    [nf, nc] = size(x);

    st = abs(x);
    alphabet = [abs('a'):abs('z')];

    for k = 1:nf,

        for l = 1:nc,

            if ~isempty(find(st(k, l) == alphabet)),
                y(k, l) = x(k, l) - 32;
                else,
                y(k, l) = x(k, l);
            end;

        end

    end

    y = setstr(y);
end
