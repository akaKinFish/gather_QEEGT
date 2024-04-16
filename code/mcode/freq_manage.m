function [data, freqrange, nfreq, freqindex] = freq_manage(data, fmin, fmax, freqres, real_freqres, real_fmax);

    %%%%%OJO: SI SE HACE ALGUN CAMBIO EN ESTE PROCEDIMIENTO, ACORDARSE QUE ESTE PROCED. SE USA TAMBIEN
    %%%%%     EN CALCMCRO. VER COMO LO AFECTA

    freqrange = [fmin:freqres:fmax];
    freqrange = freqrange(:);
    nfreq = length(freqrange);

    %Buscar el indice de cada frecuencia en freqrange en el arreglo original de frecuencias
    freqindex = zeros(nfreq, 1);
    real_freqrange = [real_freqres:real_freqres:real_fmax];

    for k = 1:nfreq
        ii = find(abs(freqrange(k) - real_freqrange) < 0.1);

        if ~isempty(ii),

            if length(ii) == 1
                freqindex(k) = ii;
            else
                [mm, ii] = min(abs(freqrange(k) - real_freqrange));
                freqindex(k) = ii;
            end

        else
            error('Invalid frequency range')
        end

    end

    %Quedarse con las frecuencias seleccionadas por parametro para los datos
    data = data(:, freqindex);
end
