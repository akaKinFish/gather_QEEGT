function [PA, PR, FM, ZPA, ZPR, ZFM, flags] = broad_band(Spec, flags, ...
        wbands, fmin, freqres, fmax, nit, sp, montage, fn_eqreg_bb, age)

    wbands = freqres .* round(wbands ./ freqres);

    freqrange = [fmin:freqres:fmax];

    ndt = size(Spec, 1);

    if flags(5)
        [PAMedia, PASigma, PRMedia, PRSigma, FMMedia, FMSigma, ...
             bb_state, bb_pgcorrect, bb_freqres, nrm_band_index] = readnrmcbb(fn_eqreg_bb, age);

        if freqres - bb_freqres > 0.1
            flags(5) = 0;
            gap = 1;
        else
            gap = round(bb_freqres ./ freqres);

            nb = size(wbands, 1);
            nbnorm = size(nrm_band_index, 1);
            w_nrm_band_index = bb_freqres * nrm_band_index;
            posnorm = zeros(nb, 1);

            for i = 1:nb

                for j = 1:nbnorm

                    if (abs(wbands(i, 1) - w_nrm_band_index(j, 1) < 1.0e-1) & ...
                            abs(wbands(i, 2) - w_nrm_band_index(j, 2)) < 1.0e-1)
                        posnorm(i) = j;
                    end

                end

            end

            if sum(posnorm) == 0
                flags(5) = 0;
            end

        end

    else
        gap = 1;
    end

    [PA, PR, FM, btotal] = bbsp(Spec, freqrange, freqres, nit, sp, wbands, gap);

    ind = find(PA > 0);
    tPA = PA;
    tPA(ind) = log(tPA(ind));
    tPR = logit(PR);

    nbandbb = size(wbands, 1);

    if flags(5)
        newmont = match_montage(montage');
        indnozero = find(newmont ~= 0);
        nderZ = size(newmont, 1);

        for j = 1:nbandbb

            if (posnorm(j) > 0 & posnorm(j) <= nbandbb)
                ZPA(indnozero, j) = (tPA(newmont(indnozero), j) - PAMedia(indnozero, posnorm(j))) ./ PASigma(indnozero, posnorm(j));
                ZFM(indnozero, j) = (FM(newmont(indnozero), j) - FMMedia(indnozero, posnorm(j))) ./ FMSigma(indnozero, posnorm(j));
            end

        end

        nbandspr = size(PR, 2);

        if ~isempty(btotal)
            posnorm(btotal) = [];
        end

        for j = 1:nbandspr,

            if (posnorm(j) > 0 & posnorm(j) <= nbandspr)
                ZPR(indnozero, j) = (tPR(newmont(indnozero), j) - PRMedia(indnozero, posnorm(j))) ./ PRSigma(indnozero, posnorm(j));
            end

        end

    else
        ZPA = -1; ZPR = -1; ZFM = -1;

    end

end
