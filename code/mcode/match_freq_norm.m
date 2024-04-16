function [indnorm, indfreq_in_Z, nfreq_norm] = match_freq_norm(freqrange, norm_freqsHz)

    % MATCH_FREQ_NORM - Find indices of frequencies with corresponding norm frequencies
    %
    % This function identifies which frequencies from a calculated frequency range
    % have corresponding norm frequencies defined (normative values).
    %
    % INPUTS:
    % freqrange      - The array of frequencies to be matched against norm frequencies.
    % norm_freqsHz - The array of norm frequencies in Hertz.
    %
    % OUTPUTS:
    % indnorm  - An array indicating the index of the matching norm frequency
    %                   for each frequency in freqrange. Zero indicates no match.
    % indfreq_in_Z - An array indicating the column index in matrix Z that corresponds
    %                      to the frequency k. Zero means there is no corresponding column in Z,
    %                      indicating no norm for that frequency.
    % nfreq_norm - The total number of matched frequencies.

    nfreq = length(freqrange);
    indnorm = zeros(nfreq, 1);
    indfreq_in_Z = zeros(nfreq, 1);

    current = 0;

    for k = 1:nfreq
        ind = find(abs(freqrange(k) - norm_freqsHz) < 0.1);

        if ~isempty(ind);
            indnorm(k) = ind;
            current = current + 1;
            indfreq_in_Z(k) = current;
        end

    end

    nfreq_norm = length(find(indnorm > 0));
end
