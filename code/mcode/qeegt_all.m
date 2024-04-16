function qeegt_all(Spec, crossM, age, montage, nit, sp, ...
        fmax, fmin, freqres, wbands, flags, ...
        pathnrm, pathbrain, pg_apply, SI_correction, ...
        brain, output_folder, sub_name)

    [fmin, freqres, fmax, FEG, flags, crossM, indfreq_in_Z, newmont, montage, ZSpec, PA, PR, ...
         FM, ZPA, ZPR, ZFM, Sinv, ZSinv, lambda, Coh, Phase, Jxyz, indnozero] = qeegtker1_calc(Spec, crossM, age, montage, nit, sp, ...
        fmax, fmin, wbands, flags, pathnrm, pathbrain, pg_apply, SI_correction, brain, sub_name);

    newmont = montage;

    if size(newmont, 1) == 1
        newmont = newmont';
    end

    indfreq_in_Z = indfreq_in_Z';
    lambda = lambda(:);
    freqrange = [fmin:freqres:fmax];

    mont = montage;
    mont(:, end - 2:end) = repmat('AVR', size(mont, 1), 1);
    ii = find(mont == '_');
    mont(ii) = ' ';
    ii = find(newmont == '_')
    newmont(ii) = ' ';

    if size(ZSpec, 2) > length(indnozero)
        ZSpec = ZSpec(:, indnozero);
    end

    if size(ZPA, 1) > length(indnozero)
        ZPA = ZPA(indnozero, :);

    end

    if size(ZPR, 1) > length(indnozero)
        ZPR = ZPR(indnozero, :);

    end

    if size(ZFM, 1) > length(indnozero)
        ZFM = ZPR(indnozero, :);

    end

    saveresult(output_folder, sub_name, mont, freqrange, FEG, Spec, crossM, indfreq_in_Z, newmont, ZSpec, PA, PR, FM, ZPA, ZPR, ZFM, Sinv, ZSinv, lambda, SI_correction, Coh, Phase, Jxyz, age);
end
