function [data_freq] = get_data_freq(crossM, ndt, cur_freq, newmont)
    %Aqui viene el calculo de la solucion inversa

    %data es de (ndt*nvt,nfreq)
    nvt = ceil(size(crossM, 1) ./ ndt);
    data_freq = reshape(crossM(:, :, cur_freq), ndt, ndt, nvt);

    %Quedarse con las 19 deriv del 1020, y garantizar ponerlas en el orden usual del sistema 1020,
    %que es el que se espera para el calculo de las SI
    data_freq = data_freq(newmont(1:19), :);

    return;
end
