function nrm_fname = concat_nrm_fname(state, mont, pg_apply, model, brain, SI_correction, path_file)
    %state          char (A, B, C...)
    %mont:          1-Referencia Promedio,       2-Record,      3-Laplaciano
    %pg_apply:      0-Do not apply PG,           1-Apply PG
    %model:         1-Narrow Band,               2-Broad Band,  3-Electrical Tomography
    %               4-ET LF,                     5-Operator for spectra reconstruction
    %               6-Lambda value
    %brain:         1-Just gray matter           2-Gray matter + Basal Ganglia
    %SI_correction: 1-Factor Global              2-Factor por frecuencias       0-No correction
    %path_file: directory where the file must be found

    if mont == 1, % % AVR
        mnt = 'AVR';
    elseif mont == 2, % % Record
        mnt = 'REC';
    elseif mont == 3, % % Laplac
        mnt = 'LAP';
    else
        mnt = '';
    end

    if pg_apply
        lpg = 'PG';
    else
        lpg = 'RD';
    end

    if model == 1 % %narrow band
        modelo = 'NB';
        ext = '.NRM';
    elseif model == 2 % %broad band
        modelo = 'BB';
        ext = '.NRM';
    elseif model == 3 % %Tomography
        modelo = 'ET';
        ext = '.NRM';
    elseif model == 4 % %Regularization operator
        modelo = 'LF';
        ext = '.mat';
    elseif model == 5 % %Spectral reconstruction operator
        modelo = 'SR';
        ext = '.OPR';
    elseif model == 6 % %Files with lambda
        modelo = 'LA';
        ext = '.DAT';
    end

    path_file = path_file(:)';

    if ~isempty(path_file)

        if path_file(length(path_file)) ~= '\'
            path_file = [path_file '\'];
        end

    end

    if model == 4 % %The situation of a Lead Field does not depend on the state or geometric power
        state = '_';
        lpg = '__';
    end

    nrm_fname = [path_file state '_' mnt '_' lpg '_' modelo '_'];

    if model > 2 %Tomography, LF, operator for reconstructing spectra or lambda

        if brain == 1 % %cortex
            tbrain = 'GM';
        elseif brain == 2 % cortex and basal ganglia
            tbrain = 'BG';
        end

        nrm_fname = [nrm_fname tbrain];
    end

    if model == 3 % %Tomography

        if SI_correction == 1
            correct = '_GF';
        elseif SI_correction == 2
            correct = '_FF';
        elseif SI_correction == 0
            correct = '_NC';
        else
            correct = '';
        end

        nrm_fname = [nrm_fname correct];
    end

    nrm_fname = [nrm_fname ext];
    nrm_fname = setstr(nrm_fname);
end
