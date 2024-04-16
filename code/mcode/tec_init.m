function [flags, Sinv, ZSinv, SIMedia, SISigma, indnorm, indfreq_in_Z, indnozero] = tec_init(flags, ...
        montage, fn_eqreg_si, age, freqrange, ng)

    Sinv = -1;
    ZSinv = -1;
    SIMedia = -1;
    SISigma = -1;
    indnorm = -1;
    indfreq_in_Z = -1;
    indnozero = -1;

    nfreq = length(freqrange);

    fn_eqreg_si = setstr(fn_eqreg_si);

    newmont = match_montage(montage');
    indnozero = find(newmont ~= 0);

    if length(find(newmont(1:19) == 0)) > 0
        flags(3) = 0;
        flags(4) = 0;
        flags(7) = 0;
        msg3 = 'Invalid Channel differences for calculating inverse solution'
    end

    flags(4) = flags(4) & flags(3)

    if flags(7)
        [SIMedia, SISigma, si_state, si_pgcorrect, norm_freqres, norm_freqsHz] = readnrmcnb(fn_eqreg_si, age);
        [indnorm, indfreq_in_Z, nfreqs_norm] = match_freq_norm(freqrange, norm_freqsHz);

        if sum(indnorm) == 0
            flags(7) = 0;
            msg2 = 'Invalid freqence differences for calculating inverse solution'
        end

    end

    Sinv = zeros(ng, ng, nfreq);

    if flags(7)
        ZSinv = zeros(ng, ng, nfreqs_norm);
    end

end
