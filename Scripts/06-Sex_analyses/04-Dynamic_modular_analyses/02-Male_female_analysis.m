%----------------------------------------------------
% Network community toolbox analysis
% Author: Ben Griffin
% Last edited: 07-10-2020

% This script compares the recruitment, integration, flexibility, and
% promiscuity for males and females

%----------------------------------------------------

clear; clc;
load('dyngraph-pain/Data/04-Dynamic_modular_analyses/Network_community_toolbox/All_Subjects/recruitment_all_subjects.mat');
load('dyngraph-pain/Data/04-Dynamic_modular_analyses/Network_community_toolbox/All_Subjects/integration_all_subjects.mat');
load('dyngraph-pain/Data/04-Dynamic_modular_analyses/Network_community_toolbox/All_Subjects/flexibility_all_subjects.mat');
load('dyngraph-pain/Data/04-Dynamic_modular_analyses/Network_community_toolbox/All_Subjects/promiscuity_all_subjects.mat');
n_measure = 4;
n_freq = size(Recruitment,2);

%--- Load system data -----------------------------------------------------
% Note that the systems have been arranged in alphabetical order when
% calculating the measures, so we order the list
systemByNode = load('dyngraph-pain/Data/04-Dynamic_modular_analyses/Functional_system_data/Original/AAL_module_assigned_numbers.txt');
systemByNode = sort(systemByNode);
n_systems = length(unique(systemByNode));


%--- Store and average out over the 15 females and males ------------------
mal_measures = {mean(Recruitment(:,:,1:15),3); mean(Integration(:,:,1:15),3);...
    mean(prom_mean(:,:,1:15),3); mean(flex_mean(:,:,1:15),3)};
fem_measures = {mean(Recruitment(:,:,16:30),3); mean(Integration(:,:,16:30),3);...
    mean(prom_mean(:,:,16:30),3); mean(flex_mean(:,:,16:30),3)};


%--- Intialise variables --------------------------------------------------
mal_sum_store = zeros(n_measure,n_freq);
mal_sys_store = zeros(n_systems, n_freq, n_measure);
fem_sys_store = zeros(n_systems, n_freq, n_measure);


for mes = 1:n_measure
    % --- Sum each of the measures over the 98 nodes ----------------------
    % This allows us to compare total recr/int/flex/prom
    mal_sum_store(mes,:) = squeeze(sum(mal_measures{mes},1));
    fem_sum_store(mes,:) = squeeze(sum(fem_measures{mes},1));
    
    %--- Sum at the system level ------------------------------------------
    for sys = 1:n_systems
        mal_sys_store(sys,:,mes) = sum((systemByNode==sys).*mal_measures{mes});
        fem_sys_store(sys,:,mes) = sum((systemByNode==sys).*fem_measures{mes});
    end
end



