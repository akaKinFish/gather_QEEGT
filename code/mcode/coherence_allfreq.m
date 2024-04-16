function Coh = coherence_allfreq(crossM)
    %COHERENCE_ALLFREQ Computes the coherence for each frequency slice of a 3D matrix.
    %
    %   Coh = coherence_allfreq(crossM) calculates the coherence for each 2D
    %   slice along the third dimension of a 3-dimensional complex matrix
    %   'crossM'. The input matrix 'crossM' should have its 2D slices in
    %   complex form and not necessarily in Hermitian form. The function uses
    %   the 'com2her' function to convert each slice into Hermitian form before
    %   computing the coherence. The coherence is calculated using a function
    %   named 'coherence', which is not defined within this code.
    %
    %   Parameters:
    %       crossM - A 3D complex matrix where each 2D slice along the third
    %                dimension represents a cross-spectral matrix from which
    %                coherence is to be computed.
    %
    %   Returns:
    %       Coh - A 3D matrix with the same size as 'crossM', containing the
    %             coherence computed for each corresponding frequency slice.
    %
    %   Example:
    %       crossM = rand(4, 4, 10) + 1i * rand(4, 4, 10);
    %       Coh = coherence_allfreq(crossM);
    %
    %   Dependencies:
    %       This function depends on 'com2her' for converting matrices to
    %       Hermitian form and 'coherence' for computing the coherence.
    %
    %   Note:
    %       The 'coherence' function must be defined elsewhere in your codebase.
    %
    %   See also: com2her

    [nd, ~, nf] = size(crossM);
    Coh = zeros(nd, nd, nf);

    for k = 1:nf
        % MC = com2her(crossM(:, :, k));
        Coh(:, :, k) = coherence(crossM(:, :, k));
    end

end
