clc;
close all;
clear;

%%
%% Plotting stat by selected frequencies
%%
if (~isfolder('Figures')); mkdir('Figures'); end
freq_range = 0.78:0.39:19.14;
delta = find(freq_range >= 0 & freq_range <= 4); % delta 0 - 4 Hz
theta = find(freq_range >= 4 & freq_range <= 8); % theta 4 - 8 Hz
alpha = find(freq_range >= 8 & freq_range <= 12.5); % alpha 8 - 12.5 Hz
beta = find(freq_range >= 12.5 & freq_range <= 20); % beta 12.5 - 20 Hz

cm = bipolar(201, 0.3);

% load("bigbrain_MNI_327684xyz.mat")

% load("derivatives\FNVCWM2BPFCQ.mat");
% load('derivatives\test.mat')
% vectors = qeegt_struct.ZET;

[nd, ~, nf] = size(Sinv);
A = zeros(nd, nf);

for i = 1:nf
    A(:, i) = diag(Sinv(:, :, i));
end

%% interpolant

ncoor = load("nors_MNI_3244xyz.txt", "ascii");
load("bigbrain_MNI_327684xyz.mat")

metric_interp = zeros(length(Vertices), 49);

% loop frequencies
for freq = 1:49
    % test
    metric_tmpe = A(:, freq);
    interp = scatteredInterpolant(ncoor, metric_tmpe);
    metric_interp(:, freq) = interp(Vertices);
    display(strcat("Interpolating metric frequency ", num2str(freq * 0.39), 'Hz'))
end

figure;

X = ncoor(:, 1);
Y = ncoor(:, 2);
Z = ncoor(:, 3);
figure;
scatter3(X, Y, Z, 36, A(:, 27), 'filled');
colorbar;
% aH = axes('Units', 'Centimeters', ...
%     'Color', 'none', 'XColor', 'none', 'Ycolor', 'none');

% patch(aH, ...
%     'Faces', Faces, ...
%     'Vertices', Vertices, ...
%     'FaceVertexCData', metric_interp(:, 27), ...
%     'FaceColor', 'interp', ...
%     'EdgeColor', 'none', ...
%     'AlphaDataMapping', 'none', ...
%     'EdgeColor', 'none', ...
%     'EdgeAlpha', 1, ...
%     'BackfaceLighting', 'lit', ...
%     'AmbientStrength', 0.5, ...
%     'DiffuseStrength', 0.5, ...
%     'SpecularStrength', 0.2, ...
%     'SpecularExponent', 1, ...
%     'SpecularColorReflectance', 0.5, ...
%     'FaceLighting', 'gouraud', ...
%     'EdgeLighting', 'gouraud', ...
%     'FaceAlpha', .99);

% axis off;
% rotate3d on;
% axis tight;
% view(90, 90)
% max_val = max(abs(metric_interp));
% currentAxes.CLim = [(-max_val - 0.01) (max_val + 0.01)];
% colormap(cm)

% %% vis

% fig = figure;

% % data = load("F:\\Brain_Conectivity\\Brain_Conectivity\\test.mat");

% for freq = 1:size(metric_interp, 2) - 1
%     metric_temp = metric_interp(:, freq);
%     template = load('axes.mat');
%     currentAxes = template.axes;

%     patch(currentAxes, ...
%         'Faces', Faces, ...
%         'Vertices', Vertices, ...
%         'FaceVertexCData', metric_temp, ...
%         'FaceColor', 'interp', ...
%         'EdgeColor', 'none', ...
%         'AlphaDataMapping', 'none', ...
%         'EdgeColor', 'none', ...
%         'EdgeAlpha', 1, ...
%         'BackfaceLighting', 'lit', ...
%         'AmbientStrength', 0.5, ...
%         'DiffuseStrength', 0.5, ...
%         'SpecularStrength', 0.2, ...
%         'SpecularExponent', 1, ...
%         'SpecularColorReflectance', 0.5, ...
%         'FaceLighting', 'gouraud', ...
%         'EdgeLighting', 'gouraud', ...
%         'FaceAlpha', .99);
%     axis off;
%     rotate3d on;
%     axis tight;
%     view(90, 90)
%     max_val = max(abs(metric_temp));
%     currentAxes.CLim = [(-max_val - 0.01) (max_val + 0.01)];
%     colormap(cm)
%     plot_tmpe = subplot(6, 8, freq, currentAxes);
% end
