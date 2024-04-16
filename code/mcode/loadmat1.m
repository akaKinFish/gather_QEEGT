function [Mat1] = loadmat1(filename)

    fid = fopen(filename, 'r');
    if fid == -1, error(['File ' filename ' does not exist']); end

    %loading matrix 1
    [x, c] = fread(fid, 2, 'real*4');
    if c ~= 2, error(['File ' filename ' is invalid']); end
    Mat1 = zeros(x(1), x(2));
    [Mat1, c] = fread(fid, x', 'real*4');
    if c ~= prod(x), error(['File ' filename ' is invalid']); end

    c = fclose(fid);

    %#inbounds
    %#realonly
    %mbintscalar(c);

end
