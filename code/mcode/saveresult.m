function saveresult(output_folder, sub_name, mont, freqrange, FEG, Spec, crossM, ...
        indfreq_in_Z, newmont, ZSpec, PA, PR, FM, ZPA, ZPR, ZFM, Sinv, ZSinv, ...
        lambda, SI_correction, Coh, Phase, Jxyz, age)

    nd = size(crossM, 1);
    nf = size(crossM, 3);

    num = [];

    qeegt_struct = [];

    fsave = [output_folder filesep sub_name '.mat'];

    qeegt_struct.name = sub_name;
    qeegt_struct.age = age;
    qeegt_struct.FEG = FEG;
    qeegt_struct.montage = mont;
    qeegt_struct.freqrange = freqrange;

    if ~isequal(crossM, -1)
        crosstype = 'Cross Spectrum';
        qeegt_struct.crossM = crossM;
    end

    if ~isequal(Spec, -1)
        crosstype = 'Spectra';
        qeegt_struct.Spec = Spec;
    end

    if ~isequal(ZSpec, -1)
        crosstype = 'Z Cross Spectrum';
        qeegt_struct.ZSpec = ZSpec;
    end

    if ~isequal(PA, -1) && ~isequal(PR, -1) && ~isequal(FM, -1)
        crosstype = 'Broad Band';
        qeegt_struct.BBPA = PA;
        qeegt_struct.BBPR = PR;
        qeegt_struct.BBFM = FM;
    end

    if ~isequal(ZPA, -1) && ~isequal(ZPR, -1) && ~isequal(ZFM, -1)
        crosstype = 'Z Broad Band';
        qeegt_struct.BBZPA = ZPA;
        qeegt_struct.BBZPR = ZPR;
        qeegt_struct.BBZFM = ZFM;
    end

    if ~isequal(Sinv, -1)
        crosstype = 'Source cross Spectrum';
        qeegt_struct.SCrossM = Sinv;
    end

    if ~isequal(ZSinv, -1)
        crosstype = 'Z Source cross Spectrum';
        qeegt_struct.ZSCrossM = ZSinv;
    end

    if ~isequal(Coh, -1) && ~isempty(Coh)
        crosstype = 'Coherence';
        qeegt_struct.Coh = Coh;

    end

    if ~isequal(Phase, -1) && ~isempty(Phase)
        crosstype = 'phase_delay';
        qeegt_struct.Phase = Phase;

    end

    save(fsave, 'qeegt_struct', '-v7.3');

end
