clc;
clear;
close all;

noPlot = 0;

load CurveOne.mat profile;
% values of nTarg and T are determined by .mat file
nTarg = 1;
T = 2;
% assign values of other necessary parameters
densClt = 2e-7;
Pd = 0.9;
q = 500;
r = 50;
[state, meas, nStep] = ...
    FormatTrans(profile, nTarg, densClt, Pd, r, noPlot);

M = 3; % number of most probable hypos listed in each scan
N = 3; % height of the hypo tree. It seems scan depth = N-1
densNew = 0;
estmMHT = MHT(state, meas, T, nStep, nTarg, ...
    noPlot, densClt, densNew, Pd, q, r, M, N);
for i = 1 : length(estmMHT)
    estmMHT{i} = estmMHT{i}{3}; % extract the state
end
% calculate mean error
first = 2; % estmMHT includes accurate initial state
last = (nStep+1) - (N-1); 
[errRMS, lose] = Analyse(first, last, estmMHT, state, nTarg);
rstMHT = [errRMS lose]; % MHT tracking results
disp('    err_x     err_vx     err_y     err_vy     lose');
disp(rstMHT);
fprintf('MHT DONE\n\n');

