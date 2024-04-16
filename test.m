clc;
clear all;

addpath(genpath('code'));
addpath(genpath('norm_coefficients'));

%%
source = 200;
freq_res = 0.3906;
srate = 100;
N = round(srate / freq_res);
lwin = 2.56;
sp = 1/ srate;
t = (0:N-1)'/freq_res;
nit = round(lwin ./ sp);
fmin = 0.3906;
fmax = 19.1394;

signal = zeros(source, size(t, 1));

for i = 1:source
    freq = randi([1, 48], 1, 1);
    amplitude = rand(1, 1);
    phase = rand(1, 1) * 2 * pi;
    signal(i, :) = amplitude * sin(2 * pi * freq * t + phase);
end
f = (0:N-1)' * (source / N);

[data, real_fextremos]  = fft_calc(signal, nit, sp);
real_fmin = real_fextremos(1);
real_freqres = real_fextremos(2);
real_fmax = real_fextremos(3);
if freq_res < real_freqres, freqres = real_freqres; end
if fmax > real_fmax, fmax = real_fmax; end
if fmin < real_freqres, fmin = real_freqres; end

freqres = real_freqres .* (round(freqres ./ real_freqres));
fmin = real_freqres .* (round(fmin ./ real_freqres));
% fmax = real_freqres .* (round(fmax ./ real_freqres));
data = data(:, 1:49);
freqrange = [0.3906:0.3906:19.1394];
freqindex = [1:49];
nfreq = 49;

Xspec = calc_sp(data, 200);
XtX = fft2mcross(data, 200, 1);


%%
leadfield = rand(19, source);
[Ui, si, Vis] = svd(leadfield, 'econ');
[U, S, V] = svd(leadfield);
Y = Ui * si * Vis' * data;
% Y2 = U * S * V' * data;
% 
% Y3 = leadfield * data;
% 
% 
% X_est = Vis * inv(si) * Ui' * Y3;
X_est2 = pinv(leadfield) * Y;
% 
% X_est = Vis * diag(1 ./ diag(si)) * Ui' * Y;
% UtY = Ui'*Y;
% X_est=(Vis*(inv(si)*UtY));

% residuals = leadfield * X_est2 - Y3;
% residual_norm = norm(residuals);
% 
XtX_est = zeros(source, source, nfreq);

Yspec = calc_sp(Y, 19);
YtY = fft2mcross(Y, 19, 1);
XtX_from_X_est = fft2mcross(X_est2, 200, 1);

for i = 1:nfreq
    YtY_test(:, :, i) = Y(:, i) * Y(:, i)';
end
%%
S2 = si .^ 2;

left_T = Vis * inv(si) * Ui';
right_T = Ui * inv(si') * Vis';
SigmaInv = diag(1 ./ diag(si));  


for i = 1:nfreq
    YtY_f = com2her(YtY(:, i));
    XtX_est(:, :, i) = left_T * YtY_test(:, :, i) * right_T;
end


for i = 1:nfreq
    XtX_cross(:, :, i) = com2her(XtX(:, i));
end

for i = 1:nfreq
    XtX_est_her(:, i) = her2com(XtX_est(:, :, i));
end