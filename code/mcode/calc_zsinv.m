function ZSinv_j = calc_zsinv(Sinv_j, indfreq_in_Z, indnorm, cur_freq, SIMedia, SISigma);

    if indfreq_in_Z(cur_freq) > 0
        ZSinv_j = (Sinv_j - SIMedia(:, indnorm(cur_freq))) ./ SISigma(:, indnorm(cur_freq));
    else
        ZSinv_j = -1;
    end

end
