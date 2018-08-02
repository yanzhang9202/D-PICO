%% PI Consensus Optimization
%  By Yan Zhang, 08/01/2018
clear;
close all;
clc;

PICO_start;

% Generate problem data
rnd_seed = 1;
rng(rnd_seed);

pb_type = 'randQP';
gen_problem;

% Algorithms
ind = [1,2,3];    % 1 - matlab;   2 - DD;     3 - C-DD
                % 4 - PIC-DD;   5 - EC-DD;
for ind_alg = ind                
    switch ind_alg
        case 1
            main_matlab;
        case 2
            main_dd;
        case 3
            main_cdd;
        case 4
            main_picdd;
        case 5
            main_ecdd;
        otherwise
            error('Undefined algorithm!')
    end
end

% makeplot;

% PICO_end;
