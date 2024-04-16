function Coh = coherence(crossM)

    %COHERENCE Calculates the coherence matrix from a cross-spectral matrix.
    %
    %   Coh = coherence(crossM) computes the coherence matrix for a given
    %   square cross-spectral matrix 'crossM'. The coherence is a normalized
    %   measure of the linear correlation between signals at each frequency,
    %   with values ranging from 0 to 1. This function assumes that 'crossM'
    %   is a Hermitian matrix representing the cross-spectral density between
    %   different signals or components. The coherence is calculated by
    %   dividing each element of 'crossM' by the square root of the product
    %   of the corresponding elements on the diagonal.
    %
    %   Parameters:
    %       crossM - A square cross-spectral matrix (Hermitian) from which
    %                the coherence is to be computed.
    %
    %   Returns:
    %       Coh - A coherence matrix of the same size as 'crossM', with values
    %             between 0 and 1 representing the degree of linear correlation
    %             between the signals.
    %
    %   Example:
    %       crossM = rand(4, 4) + 1i * rand(4, 4);
    %       crossM = crossM * crossM'; % Creating a Hermitian matrix
    %       Coh = coherence(crossM);
    %
    %   Notes:
    %       The input matrix 'crossM' is expected to be Hermitian, i.e., it is
    %       equal to its own conjugate transpose. Non-Hermitian matrices may
    %       lead to incorrect results.
    %
    %   See also: abs, sqrt, kron, diag, reshape

    nder = size(crossM, 1);
    d = reshape(diag(crossM), nder, 1);
    denom = sqrt(reshape(kron(d, d), nder, nder));
    Coh = abs(crossM ./ denom);
end
