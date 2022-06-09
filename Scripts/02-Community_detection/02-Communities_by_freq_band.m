%----------------------------------------------------
% This script finds the mean number of communities of all network for each 
% frequency band (i.e. the mean across all subjects, time windows and
% optimisations for each band).

%----------------------------------------------------
%--- load data ------------------------------------------------------------
clear; clc;
load('dyngraph-pain/Data/02-Community_detection/Threshold_func_3/modules.mat')
n_iter = size(modules,1)
n_lay = size(modules,3)
n_freq = size(modules,4)
n_sub = size(modules,5)

n_communities = zeros(n_iter,n_lay,n_freq,n_sub); % initialise variable

%--- Calculate no. of communities for each network ------------------------
for iter = 1:n_iter
    for freq = 1:n_freq
        for sub = 1:n_sub
            for win = 1:n_lay
            n_communities(iter,win,freq,sub) = length(unique(modules(iter,:,win,freq,sub)'));
            end
        end
    end
end

%--- Mean no. of communities for each frequency band ----------------------
% find mean across 100 optimisations, 28 time windows and 30 subjects
% i.e. the mean n of communities of all networks for each frequency band
communities_mean = squeeze(mean(mean(mean(n_communities, 1),2),4));
communities_mean

%save('dyngraph-pain/Subject_data_and_analysis/Community_detection/communities_mean.mat','communities_mean')
