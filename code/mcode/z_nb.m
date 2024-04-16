function [ZSpec, flags, indnorm, indfreq_in_Z] = z_nb(Spec, flags, fn_eqreg_nb, age, freqrange, montage)

    nfreq = length(freqrange);

    [SpMedia, SpSigma, nb_state, nb_pgcorrect, norm_freqres, norm_freqsHz] = readnrmcnb(fn_eqreg_nb, age);

    [indnorm, indfreq_in_Z, nfreqs_norm] = match_freq_norm(freqrange, norm_freqsHz);

    if sum(indnorm) == 0
        flags(6) = 0;
        flags(7) = 0;
        msg2 = 'freqence ranges are different from the norm';
    end

    if flags(6)
        [newmont, indnozero] = match_montage(montage');
        nderZ = size(newmont, 1);

        ZSpec = zeros(nderZ, nfreqs_norm);

        for j = 1:nfreq

            if indnorm(j) > 0
                ZSpec(indnozero, indfreq_in_Z(j)) = (Spec(newmont(indnozero), j) - ...
                    SpMedia(indnozero, indnorm(j))) ./ SpSigma(indnozero, indnorm(j));
            end

        end

    else
        ZSpec = -1;
    end

end
