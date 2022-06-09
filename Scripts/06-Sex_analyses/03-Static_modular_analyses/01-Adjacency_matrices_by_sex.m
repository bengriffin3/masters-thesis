%----------------------------------------------------
% Adjacency matrix calcaultor (split by sex)
% Author: Ben Griffin
% Last edited: 06-10-2020

% This scripts calculates the adjacency matrices and divides the results 
% males and females.

%----------------------------------------------------
clear;clc;
%--- load and store female and male data ----------------------------------
load('dyngraph-pain/Data/00-Raw data/All_subject_correlation_matrices.mat')
Males = M(:,:,:,:,1:15);
Females = M(:,:,:,:,16:30);

n_freq = 6;
n_roi = 98;
n_sub = 15; % number subjects per group

%--- Average our correlation matrices over time windows -------------------
Males_mean = squeeze(mean(Males,3));
Females_mean = squeeze(mean(Females,3));


%--- Initialise variables -------------------------------------------------
Males_adj_matrices = zeros(n_roi,n_roi,n_freq,n_sub);
Females_adj_matrices = zeros(n_roi,n_roi,n_freq,n_sub);

%--- Apply threshold function ---------------------------------------------
for sub = 1:n_sub
    subject = sub
    for freq = 1:n_freq
        %--- Select threshold function to use -----------------------------
        Males_adj_matrices(:,:,freq,sub) = threshold_func_3(Males_mean(:,:,freq,sub));
        Females_adj_matrices(:,:,freq,sub) = threshold_func_3(Females_mean(:,:,freq,sub));
    end
end

%save('dyngraph-pain/Data/01-Adjacency_matrices/Threshold_func_3/Males_adj_matrices.mat', 'Males_adj_matrices')
%save('dyngraph-pain/Data/01-Adjacency_matrices/Threshold_func_3/Females_adj_matrices.mat', 'Females_adj_matrices')