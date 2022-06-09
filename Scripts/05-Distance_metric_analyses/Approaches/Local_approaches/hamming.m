function [d_hamming] = hamming(A, A_bar)
%----------------------------------------------------
% This function takes two adjacency matrices, A and A_bar and calculates 
% the Hamming distance between them, as described in:
% 'Tracking network dynamics: a survey of distances and similarity metrics'
% https://arxiv.org/abs/1801.07351

%----------------------------------------------------

n_roi = size(A,1); % number of ROI

%--- Note the edges that are created/destroyed ----------------------------
dif_abs = abs(A - A_bar);

%--- Calculate Hamming distance -------------------------------------------
d_hamming = sum(sum(dif_abs))/(n_roi*(n_roi-1));
