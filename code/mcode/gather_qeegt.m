function gather_qeegt(data_struct, wbands, brain, pg_apply, flags, output_folder)

    %  data_struct: A gather format matlab struct
    %  lwin:      Length of epochs, in seconds. Example: 2.56 seg  ???
    %  wbands:    Broad Bands definition in string format. For example:
    %                 wbands='1.56 3.51; 3.9 7.41; 7.8 12.48; 12.87 19.11; 1.56 11';
    %  brain:     1 indicates to restrict the inverse solution to only gray matter
    %  pg_apply:  1 indicates to apply correction by the General Scale Factor
    %  flags: Options for calculations in string format. For example:
    %       flags='1 1 1 0 1 1 1 1 1 1 1 1';
    %  flags(1)- 1 for calculating the Broad Band Spectral Model
    %  flags(2)- 1 for calculating the Narrow Band Spectral Model
    %  flags(3)- 1 for calculating the Spectra at the EEG sources
    %  flags(4)- RESERVED, not used
    %  flags(5)- 1 for calculating the Broad Band Spectral Model Z values
    %  flags(6)- 1 for calculating the Narrow Band Spectral Model Z values
    %  flags(7)- 1 for calculating the Sources Spectra Z values
    %  flags(8)- 1 for calculating the correlations matrix bewteen all pairs of channels for each epoch
    %  flags(9)- 1 for calculating the coherence matrix bewteen all pairs of channels for each frequency
    % flags(10)- 1 for calculating the phase difference matrix bewteen all pairs of channels for each frequency
    % flags(11)- 1 for calculating the frequency domain correlations bewteen all pairs of channels for each frequency and each epoch
    % flags(12)- Store the XYZ components of the solutions at the sources
    % output_folder: Folder name where to store the results. It should end with the folder separation character.
    %            If empty, the results are saved in the same directory as the input data

    % gather format:
    % data_struct: Structure of:
    %     name   : data_code
    %     srate  : SAMPLING_FREQ
    %     nchan  : length(cnames)
    %     dnames : channels names in its final order (always the standardized order), cell
    %     ref    : reference
    %     data   : data used for cross-spectra calculation. Different from input if the data was down-sampled
    %            empty
    %     nt     : epoch size (# of instants of times in an epoch)
    %     age    : age
    %     sex    : sex
    %     site   : country
    %     EEGMachine : eeg_device
    %     nepochs : number of epochs
    %     fmin    : Minimum spectral frequency (according to the data recording maybe down-sampled if higher than the expected, or the original one if lower than the expected)
    %     freqres : frequency resolution (maybe down-sampled if higher than the expected, or the original one if lower than the expected)
    %     fmax    : Maximum spectral frequency (according to the data recording maybe down-sampled if higher than the expected, or the original one if lower than the expected)
    %     CrossM  : complex cross spectral matrix of nd x nd x nfreqs (nfreqs according to the spanning: fmin:freqres:fmax)
    %     ffteeg  : complex matrix of FFT coefficients of nd x nfreqs x nepochs (stored for possible needed further processing for calculating the
    %              cross-spectral matrix, like regularization algorithms in case of ill-conditioning)
    %              empty
    %     freqrange: the spanning of fmin:freqres:fmax
    %     Spec    : EEG spectra. Same as the diagonal of CrossM, or interpolated to satisfy the expected frequency range if the original frequency
    %               resolution was lower than needed.
    %     Spec_freqrange : Frequency range of the spectra. It will always be 0.390625:0.390625:(nfreqs*0.390625)

    SI_correction = 1;
    pathnrm = 'EEGnorms';
    pathbrain = 'leadfields';

    try
        wbands = str2num(wbands);
    catch
        error('Incorrect definition of the parameter "wbands"')
    end

    try
        flags = str2num(flags);
    catch
        error('Incorrect definition of the parameter "wbands"')
    end

    try
        if ~isnumeric(brain), brain = str2num(brain); end
    catch
        error('Incorrect definition of the parameter "brain"')
    end

    try
        if ~isnumeric(pg_apply), pg_apply = str2num(pg_apply); end
    catch
        error('Incorrect definition of the parameter "pg_apply"')
    end

    try

        if exist('output_folder', 'var')

            if ~isempty(output_folder) && (output_folder(end) ~= filesep)
                output_folder(end + 1) = filesep;
            end

        else
            output_folder = '';
        end

    catch
        output_folder = '';
    end

    if ~isempty(output_folder)

        if ~isdir(output_folder)

            try
                mkdir(output_folder);
            catch
                output_folder = '';
            end

        end

    end

    if isa(data_struct, 'struct')
        fmin = data_struct.fmin;
        freqres = data_struct.freqres;
        fmax = data_struct.fmax;
        Spec = data_struct.Spec;
        crossM = data_struct.CrossM;

        try
            sub_name = data_struct.name;
        catch
            error('eeg_fname should contain a field named "name"');
        end

        try
            montage = data_struct.dnames;
        catch
            error('eeg_fname should contain a field named "montage", with the name of channels, including the reference. Example: Fp1-REF. REF can also be "A12" for EAR LINKED, "Cz" foe Cz reference, etc');
        end

        try
            age = data_struct.age;
        catch
            error('eeg_fname should contain a field named "age", which the subject''s age');
        end

        try
            SAMPLING_FREQ = data_struct.srate;
        catch
            error('eeg_fname should contain a field named "SAMPLING_FREQ", which the sampling frequency in Hz of the data');
        end

        try
            epoch_size = data_struct.nt;
        catch
        end

    else
        error('data_struct variable is not of correct type');
    end

    lwin = 2.56;
    sp = 1 / SAMPLING_FREQ;
    nit = round(lwin ./ sp);

    indices = [1:19];
    montage = montage(indices);

    Spec = Spec(indices, :);
    crossM = crossM(indices, indices, :);

    qeegt_all(Spec, crossM, age, montage, nit, sp, ...
        fmax, fmin, freqres, wbands, flags, ...
        pathnrm, pathbrain, pg_apply, SI_correction, ...
        brain, output_folder, sub_name)

end
