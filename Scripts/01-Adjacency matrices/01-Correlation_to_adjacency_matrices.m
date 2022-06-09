%----------------------------------------------------
% This script takes the raw subject data, made up of functional 
% connectivity matrices, and forms adjacency matrices for each one.

%----------------------------------------------------
%--- Load and prepare data ------------------------------------------------
clear; clc;
load('dyngraph-pain/Data/00-Raw data/All_subject_correlation_matrices.mat')
n_roi = size(M,1);
n_lay = size(M,3);
n_freq = size(M,4);
n_sub = size(M,5);

%--- Set negative elements to 0 and make symmetric ------------------------
M = round(M,11);
M = M .* (M > 0);

%--- Initialise variables -------------------------------------------------
adj_mat_func_1 = zeros(size(M));
adj_mat_func_2 = zeros(size(M));
adj_mat_func_3 = zeros(size(M));

for sub = 1:n_sub
    subject = sub
    for freq = 1:n_freq
        for lay = 1:n_lay
            %--- Choose thresholding function -----------------------------
            %adj_mat_func_1(:,:,lay,freq,sub) = threshold_func_1(M(:,:,lay,freq,sub));
            %adj_mat_func_2(:,:,lay,freq,sub) = threshold_func_2(M(:,:,lay,freq),3); % Set threshold limit as strongest 3%
            adj_mat_func_3(:,:,lay,freq, sub) = threshold_func_3(M(:,:,lay,freq, sub));
        end
    end
end

%--- Check if the graphs are connected ------------------------------------
%  g = digraph(A);
%  bins = conncomp(g, 'Type', 'weak');
%  isConnected = all(bins == 1);
