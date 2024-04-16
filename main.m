clc;
clear;

addpath(genpath('code'));
addpath(genpath('norm_coefficients'));
addpath(genpath('leadfields'));
addpath(genpath('EEGnorms'));


call_with_plg = 0;  %Set to 1 if you have an EEG recording in the PLG Neuronic format; set to 0 if if it is text format

basename = ['example' filesep 'MC0000001'];
state = 'A';
lwin = 2.56; %length of analysis window in seconds
fmin = 0.390625; %Min freq
freqres = fmin; %frequency resolution
fmax=19.11; %max frequency
wbands='1.56 3.51; 3.9 7.41; 7.8 12.48; 12.87 19.11; 1.56 30';
flags='1 1 1 0 1 1 1 1 1 1 1 1';

brain=1;
pg_apply=1;

output_folder = 'derivatives';

load('D:\Data_crossspectra\Cuba90\FNVCWM2BPFCQ.mat');

gather_qeegt(data_struct, wbands, brain, pg_apply, flags, output_folder);
