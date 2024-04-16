function MCross = fft2mcross(fftdata, ndt, avg_segs)

    %fftdata es de (ndt*nvt,nfreq)
    nfreq = size(fftdata, 2);

    nvt = ceil(size(fftdata, 1) ./ ndt);

    if avg_segs
        MCross = zeros(ndt * ndt, nfreq);
    else
        MCross = zeros(ndt * ndt, nfreq, nvt);
    end

    for cur_freq = 1:nfreq
        fftdata_freq = reshape(fftdata(:, cur_freq), ndt, nvt);

        if avg_segs
            M = (fftdata_freq * fftdata_freq');
            %         M = (fftdata_freq*fftdata_freq')./nvt;
            M = her2com(M);
            MCross(:, cur_freq) = M(:);
        else

            for h = 1:nvt
                M = (fftdata_freq(:, h) * fftdata_freq(:, h)');
                M = her2com(M);
                MCross(:, cur_freq, h) = M(:);
            end

        end

    end

end
