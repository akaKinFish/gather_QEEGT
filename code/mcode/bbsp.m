function [PA, PR, MF, btotal] = bbsp(Spect, freqrange, freqres, nit, sp, wbands, gap)
    % bbsp - This function calculates spectral parameters within specified broad frequency bands.
    % It computes the absolute power (PA), relative power (PR), and mean frequency (MF)
    % for given EEG spectral data. It also identifies and potentially excludes total frequency bands
    % that always result in a relative power of 1.

    % INPUTS:
    % Spect      - A matrix of dimensions nder x nfreq, where nder is the number of EEG channels,
    %              and nfreq is the number of frequency points in the spectrum.
    % freqrange  - An array representing the frequency values corresponding to each column in Spect.
    % freqres    - Frequency resolution of the spectrum data.
    % nit        - A normalization factor, perhaps representing the number of trials or epochs.
    % sp         - A scaling factor, possibly related to the size of the analysis window.
    % wbands     - An n x 2 matrix where each row represents the start and end frequencies of a wide frequency band of interest.
    % gap        - An integer representing the step between frequency points to be considered in the calculations.

    % OUTPUTS:
    % PA         - Absolute Power: A matrix of power values for each EEG channel across each specified frequency band.
    % PR         - Relative Power: A matrix of power values relative to the total power within the specified frequency bands.
    % MF         - Mean Frequency: A matrix with the weighted average frequency for each EEG channel within each frequency band.
    % btotal     - An array containing the indices of frequency bands that were processed.
    %SPECT es una matriz de nder x nfreq

    % Map the broad band frequencies from wbands to freqrange to find corresponding indices
    nbandbb = size(wbands, 1);
    band_index = zeros(size(wbands));

    for k = 1:nbandbb

        for l = 1:size(wbands, 2)
            [mini, ii] = min(abs(wbands(k, l) - freqrange));

            if ~isempty(ii),
                band_index(k, l) = ii(1);
            else
                error('Invalid broad band frequency range')
            end

        end

    end

    nder = size(Spect, 1);
    nb = size(band_index, 1);
    bTotal = [min(band_index(:)) max(band_index(:))];

    PA = zeros(nder, nb);
    PR = zeros(nder, nb);
    MF = zeros(nder, nb);

    % Calculate total power across all frequency bands for each channel
    PTotal = sum(Spect(:, bTotal(1):gap:bTotal(2))')';

    for k = 1:nb
        wb = band_index(k, 1):gap:band_index(k, 2);
        PA(:, k) = sum(Spect(:, wb)')';
        ind = find(PTotal); % To guard against any PTotal that may be zero, which can occur with improper handling of EEG data
        PR(ind, k) = PA(ind, k) ./ PTotal(ind);
        wb_FM = round(freqrange(band_index(k, 1)) ./ freqres):gap:round(freqrange(band_index(k, 2)) ./ freqres);

        % save('c:\res1',wb_FM, freqrange, band_index, freqres, gap);
        wb_FM = round(wb_FM);
        %save('c:\res2',wb_FM);

        %%  MF(:,k)=sum((Spect(:,wb).*((freqres*gap)*wb(ones(ndt,1),:)))')' ./ (nit*sampper*PA(:,k));

        MF(:, k) = sum((Spect(:, wb) .* ((freqres * gap) * wb_FM(ones(nder, 1), :)))')';
        ind = find(PA(:, k)); %Para protegerse de que haya algun PTotal que sea cero. Esto puede ocurrir si algun comemierda se pone a jugar
        % Calculate mean frequency for each band and channel
        MF(ind, k) = MF(ind, k) ./ PA(ind, k);
    end

    indout = [];

    for k = 1:nb, %Find indices of frequency bands that result in a constant relative power of 1

        if (band_index(k, 1) == bTotal(1)) & (band_index(k, 2) == bTotal(2))
            indout = [indout k];
        end

    end

    if ~isempty(indout)
        PR(:, indout) = [];
    end

    btotal = indout;

    % Scale the Absolute Power by a factor considering the number of trials and scaling parameter
    factor = nit * sp;

    if factor > eps
        PA = PA ./ factor;
    end

end
