function [fmin, freqres, fmax, FEG, flags, crossM, indfreq_in_Z, newmont, montage, ZSpec, PA, PR, ...
              FM, ZPA, ZPR, ZFM, Sinv, ZSinv, lambda, Coh, Phase, Jxyz, indnozero] = qeegtker1_calc(Spec, crossM, age, montage, nit, sp, ...
    fmax, fmin, wbands, flags, pathnrm, pathbrain, pg_apply, SI_correction, brain, sub_name)

%%No flags(8) and flags(11)

% Spec: matrix, Spectra, channel * frequencies
% crossM: matrix, Cross Spectra, channel * channel * frequencies
% brain:
%   1: cortex
%   2: cortex + Ganglion base
% pg_apply:
%   0: do not apply PG
%   1: Apply PG
%  flags(1)- 1 for calculating the Broad Band Spectral Model
%  flags(2)- 1 for calculating the Narrow Band Spectral Model
%  flags(3)- 1 for calculating the Spectra at the EEG sources
%  flags(4)- RESERVED, not used
%  flags(5)- 1 for calculating the Broad Band Spectral Model Z values
%  flags(6)- 1 for calculating the Narrow Band Spectral Model Z values
%  flags(7)- 1 for calculating the Sources Spectra Z values
%  flags(8)- 1 for calculating the correlations matrix bewteen all pairs of channels for each epoch
%  flags(9)- 1 for calculating the coherence matrix bewteen all pairs of channels for each frequency
%  flags(10)- 1 for calculating the phase difference matrix bewteen all pairs of channels for each frequency
%  flags(11)- 1 for calculating the frequency domain correlations bewteen all pairs of channels for each frequency and each epoch
%  flags(12)- Store the XYZ components of the solutions at the sources

output = 'derivatives';
flags(4) = 0;

% transfer cell montage to char matrix
a = repmat(' ', 19, 7);

for i = 1:numel(montage)
    temp = montage{i};

    if length(temp) == 2
        a(i, :) = [temp ' -AVR'];
    elseif length(temp) == 3
        a(i, :) = [temp, '-AVR'];
    end

end

montage = a;

pathnrm = setstr(pathnrm);
pathbrain = setstr(pathbrain);

mont = get_montage(montage);

if mont == 1 % AVR
    delete_rp = 1;
    laplac = 0;
elseif mont == 2 % Record
    delete_rp = 0;
    laplac = 0;
elseif mont == 3 % Laplac
    delete_rp = 0;
    laplac = 1;
else
    delete_rp = 0; %unknown
    laplac = 0;
end

state = 'A';
fn_eqreg_nb = concat_nrm_fname(state, mont, pg_apply, 1, brain, SI_correction, pathnrm);
fn_eqreg_bb = concat_nrm_fname(state, mont, pg_apply, 2, brain, SI_correction, pathnrm);
fn_eqreg_si = concat_nrm_fname(state, mont, pg_apply, 3, brain, SI_correction, pathnrm);
fn_LF = concat_nrm_fname(state, mont, pg_apply, 4, brain, SI_correction, pathbrain);
fn_lambda = concat_nrm_fname(state, mont, pg_apply, 6, brain, SI_correction, pathnrm);

if laplac %  It only exists for topography. All inverse solution ones are disabled
    flags(4) = 0;
    flags(7) = 0;
    fname = pathname(:)';
    fname = [fname filesep 'Le_surf1020.mat'];

    try
        load(fname, 'Le');
    catch
        error(['Laplacian matrix ' fname ' not found'])
    end

end

if ~existsf(fn_eqreg_nb)
    flags(6) = 0;
    msg0 = 'There are no Narrow band norm for the state';
end

if ~existsf(fn_eqreg_bb)
    flags(5) = 0;
    msg2 = 'There are no broad band norm for the state';
end

if ~existsf(fn_eqreg_si)
    flags(7) = 0;
    msg1 = 'There are no norm for inverse solutions for the state';
end

if ~existsf(fn_LF)
    flags(3) = 0;
    flags(4) = 0;
    msg1 = 'There is no lead field for inverse solutions';
end

if ~delete_rp %    There are no standards without average reference. Therefore, the flags of the standards are disabled
    flags(3) = 0;
    flags(4) = 0;
    flags(7) = 0;
end

if flags(3) | flags(4) | flags(7)
    lambda = loadmat1(fn_lambda);
else
    lambda = 0;
end

if (age < 4) | (age > 90) %The norms are disabled
    flags(5) = 0; flags(6) = 0; flags(7) = 0;
end

% Z measures are going to be calculated. TEMPORARILY, we are going to require the same frequency
% range as the one used to calculate the standards. This is until the issue of calculating the
% scaling factor is resolved, so it doesn't affect calculations at a different frequency resolution
if (flags(6) | flags(7))
    freqres = 0.3906;
    fmin = freqres;
    fmax = freqres * 49;
end

ndt = size(Spec, 1);

[newmont, indnozero] = match_montage(montage);

ndernorms = min([ndt 19]);

corrM = -1;

crossM = crossM;

% 从这个时候开始源代码的data已经变成了fft变换后的数据，
real_freqres = 0.3906;
real_fmin = 0.3906;
real_fmax = real_freqres * 49;
real_freqinterval = [real_fmin, real_freqres, real_fmax];

[data, freqrange, nfreq, freqindex] = freq_manage(Spec, fmin, fmax, freqres, real_freqres, real_fmax);
nfreq = size(freqrange, 1);

if flags(9)
    Coh = coherence_allfreq(crossM);
else
    Coh = -1;
end

if flags(10)
    Phase = phase_delay(crossM);
else
    Phase = -1;
end


CorrFreq = -1;

% crossM = new2old_str(crossM);

[iim nff] = min(abs(freqrange - 19.15));
ind = find(Spec > eps);
lSpec = zeros(size(Spec));
lSpec(ind) = log(Spec(ind));
lSpec = lSpec(1:ndernorms, 1:nff);

FEG = exp(sum(lSpec(:) ./ prod(size(lSpec))));

if FEG < eps
    FEG = 1.0;
end

if pg_apply
    Spec = Spec ./ FEG;
end

%calculate broad band
if flags(1) | flags(5)
    [PA, PR, FM, ZPA, ZPR, ZFM, flags] = broad_band(Spec, flags, wbands, ...
        fmin, freqres, fmax, nit, sp, montage, fn_eqreg_bb, age);
else
    PA = -1; PR = -1; FM = -1; ZPA = -1; ZPR = -1; ZFM = -1;
end

% log transfer to spectra
ind = find(Spec > eps);
Spec(ind) = log(Spec(ind));

%calculate z norm narrow band
if flags(6)
    [ZSpec, flags, indnorm, indfreq_in_Z] = z_nb(Spec, flags, fn_eqreg_nb, age, freqrange, montage);
else
    indnorm = -1; ZSpec = -1; indfreq_in_Z = -1; indnozero = -1;
end

% disable in this version
SpecR = -1;

if flags(3) | flags(7)
    load(fn_LF, 'Ui', 'si', 'Vis', 'rind');
    ng = round(size(Vis, 1) ./ 3);
    [flags, Sinv, ZSinv, SIMedia, SISigma, indnorma1, indfreq_in_Z1, indnozero] = tec_init(flags, montage, fn_eqreg_si, age, freqrange, ng);

    if ~flags(6)
        indnorma = indnorma1;
        indfreq_in_Z = indfreq_in_Z1;
    end

end

if length(lambda) < nfreq
    lambda = [lambda(:); lambda(length(lambda)) * ones(nfreq - length(lambda), 1)];
end

prueba = 1;

if flags(3) | flags(7)

    folder_path = [output filesep sub_name];

    if ~exist(folder_path, 'dir')
        mkdir(folder_path);
    end

    for cur_freq = 1:nfreq
        [data_freq] = get_data_freq(crossM, ndt, cur_freq, newmont);
        Js = invereg_c(Ui, si, Vis, data_freq, 0, lambda(cur_freq));

        if length(flags) >= 12 && flags(12)
            % Jxyz = zeros(size(Vis, 1), size(Vis, 1));
            % fsave = [folder_path filesep num2str(freqrange(cur_freq)) 'Hz.mat'];
            % Jxyz(:, :) = real(mean(Js, 3));
            % Jxyz = triu(Jxyz);
            % save(fsave, "Jxyz", '-v7.3');
            % clear Jxyz;
        end
        
        n = size(Js, 1);
        m = size(Js, 1) ./ 3;
        B = zeros(m, m);

        if prueba == 1
            Js = abs(Js) .^ 2;
            Js = mean(Js, 3); 

            % for i = 1:m
            % 
            %     for j = 1:m
            %         row_start = (i - 1) * 3 + 1;
            %         row_end = min(i * 3, n);
            %         col_start = (j - 1) * 3 + 1;
            %         col_end = min(j * 3, n);
            % 
            %         sub_matrix = Js(row_start:row_end, col_start:col_end);
            %         B(i, j) = mean(sub_matrix(:));
            %     end
            % 
            % end
            kernel = ones(3, 3) /9;
            filtered_Js = conv2(Js, kernel, 'same');
            B = filtered_Js(2:3:end-1, 2:3:end-1);

            % Js = reshape(Js, ng, ng, 3, 3);
            % Js = reshape(Js, 3, ng);
            Js = log(B);

        elseif prueba == 2
        elseif prueba == 3
            Js = abs(Js) .^ 2;
            Js = mean(Js, 2); %aqui antes habia puesto sum
            Js = reshape(Js, 3, ng);
            Js = log(mean(Js));

            Oper = invreg_c(Ui, si, Vis, eye(ndernormas), 0, lambda(cur_freq));
            Oper = abs(Oper) .^ 2;
            Oper = reshape(Oper, 3, ng);
            Oper = log(mean(Oper));
            Js = Js - Oper;

        elseif prueba == 4
            Oper = invreg_c(Ui, si, Vis, eye(ndernormas), 0, lambda(cur_freq));
            J = zeros(ng, 1);

            for kk = 1:ng
                indd = (kk - 1) * 3 + 1:kk * 3;
                gen = Oper(indd, :);
                gen = pinv(gen * gen');

                for ss = 1:size(Js, 2)
                    J(kk) = J(kk) + Js(indd, ss)' * gen * Js(indd, ss);
                end

            end

            Js = log(abs(J));
        end

        % Js = Js(:);
        Sinv(:, :, cur_freq) = Js;
    end

    switch SI_correction
        case 1
            factor = mean(Sinv(:)); 
            Sinv = Sinv - factor; 
        case 2
            factor = mean(Sinv); 
            Sinv = Sinv - repmat(factor, ng, 1);
        otherwise
            factor = 1;
    end

    if length(flags) >= 12 && flags(12)

        % for cur_freq = 1:nfreq
        %     fsave = [folder_path filesep num2str(freqrange(cur_freq)) 'Hz.mat'];
        %     load(fsave);
        %     Jxyz = Jxyz ./ factor;
        %     save(fsave, "Jxyz", '-v7.3');
        %     clear Jxyz;
        % end
        Jxyz = -1;

    end

    
    if flags(7), %Calcular la ZSinv

        % for cur_freq = 1:nfreq,
        %
        %     if indfreq_in_Z(cur_freq) > 0
        %         ZSinv_j = calc_zsinv(Sinv(:, :, cur_freq), indfreq_in_Z, indnorm, cur_freq, SIMedia, SISigma);
        %         ZSinv(:, :, indfreq_in_Z(cur_freq)) = ZSinv_j;
        %     end
        %
        % end
        ZSinv = -1;

    end

else
    Sinv = -1; ZSinv = -1; SpecR = -1; Jxyz = [];
end

Spec = Spec';
SpecR = SpecR';
ZSpec = ZSpec';

end
