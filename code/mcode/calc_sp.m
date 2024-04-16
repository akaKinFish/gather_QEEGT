function Spect = calc_sp(ffteeg, nder)

    %ffteeg son los coef. de Fourier calculados a partir de los segmentos de EEG por la funcion FFTCALC. Es una
    %matriz de nder*nvt x nfreq

    nfreq = size(ffteeg, 2);
    nvt = ceil(size(ffteeg, 1) ./ nder);

    Spect = zeros(nder, nfreq);

    for i = 1:nvt
        f = ffteeg((i - 1) * nder + 1:i * nder, :);
        Spect = Spect + abs(f) .^ 2;
    end

    % Spect=Spect./nvt;
end
