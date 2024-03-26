clear all
close all
clc
tic

% add directories
addpath("src");
addpath("test");

% MATPOWER Options
mpopt=mpoption('verbose',0,'out.all','0');

% Inputs
PARAM = [0,1,2,3,4];
pp = 1; %case study to be evaluated
mpc= eval(['case141_portate_' num2str(PARAM(pp,1))]);
fprintf(strcat('The analized case study will be :\n',strcat('case141_portate_', num2str(PARAM(pp,1)), '\n')))

% Constraints
F = 30 .* ones(length(mpc.bus(:,1)),1); % 30 %randi([0 100],BUS_N,1);
F(1,1) = 0;  %%% CABINA PRIMARIA
KC= 0.9; %%% FATTORE DI CONGESTIONE
Nq = [5, 7, 11]; % numero di "prese" dei carichi per quantile


% Main
[G] = group_nodes(mpc); % BUS GROUPS FUNCTION 
[OVf, OVt, OVm, P_OVR] = congestion_calc(mpc, KC, mpopt, F, G, Nq); %%% CONGESTION ANALYSIS WITH IDEAL MEASUREMENTS 
[ideal_solution, B_IN] = congestion_opt(mpc, KC, F, G, OVm, P_OVR, Nq); %%%%%% OTTIMIZZAZIONE  
[CONGESTIONS] = lf_final(mpc, ideal_solution, F, mpopt, KC, Nq); %%% LOAD FLOW FINALE 
res_show(mpc, F, B_IN, OVm, KC, P_OVR, Nq, ideal_solution); %Show Results

toc