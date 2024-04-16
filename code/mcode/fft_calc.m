function [ffteeg, real_freqinterval] = fft_calc(eegdata, nt, sp)

    %sp es el periodo de muestreo
    %nt es la long de un segmento

    real_freqres = 1 ./ (sp * nt);
    real_fmin = real_freqres;
    real_fmax = 1 ./ (2 * sp);
    real_freqinterval = [real_fmin, real_freqres, real_fmax];

    nvt = floor(size(eegdata, 2) ./ nt); % numero de ventanas a procesar
    nder = size(eegdata, 1);

    ffteeg = zeros(nder * nvt, round(nt ./ 2));
    A = zeros(nt, nder);

    %hamm = hamming(nt);
    %WARNING: VENTANAS DE HAMMING DISABLED POR COMPATIBILIDAD CON EL TW2
    hamm = ones(nt, 1);

    for i = 1:nvt
        A = eegdata(:, (i - 1) * nt + 1:i * nt)' .* hamm(:, ones(nder, 1)); %Se multiplica por hamming
        f = fft(A)';
        f = f(:, 2:round(nt ./ 2) + 1); %quitar el primer coef porque es una linea de base y ademas, quedarse con
        %la mitad de los coeficientes por la frecuencia de Nyquist

        %%%%OJO: COMPATIBILIDAD CON EL TW2%%%%%%%
        f = f ./ sqrt(nt);
        %%%%OJO: COMPATIBILIDAD CON EL TW2%%%%%%%

        %  f(:,1) = f(:,2); %Esto es una cochinada aqui porque el primer coef. de la FFT sale mal
        ffteeg((i - 1) * nder + 1:i * nder, :) = f;
    end

    %%%%OJO: COMPATIBILIDAD CON EL TW2%%%%%%%
    SamplingFreqHz = 1 ./ sp;
    TWfactor = (1000 ./ (2 * pi * SamplingFreqHz * nvt * 100));
    ffteeg = ffteeg * sqrt(TWfactor);
    %%%%OJO: COMPATIBILIDAD CON EL TW2%%%%%%%
end
