%----------------------------------------------------
% Multilayer community detection algoritm
% Author: Ben Griffin
% Last edited: 07-10-2020
% Note that the code takes roughly 6 minutes to run per functional band, so
% 36 minutes in total (per subject).

% Adapted from:
% Karolina Finc | Centre for Modern Interdisciplinary Technologies,
% Nicolaus Copernicus University in Toruń, Poland
%
% Original code can be found:
% Lucas G. S. Jeub, Marya Bazzi, Inderjit S. Jutla, and Peter J. Mucha, "A
%generalized Louvain method for community detection implemented in MATLAB,"
%http://netwiki.amath.unc.edu/GenLouvain,
%https://github.com/GenLouvain/GenLouvain (2011-2019).


%----------------------------------------------------

% Here the input is a 5D matrix where:
% 1st and 2nd dim --> ROI
% 3rd dim --> layers/time windows
% 4th dim --> frequency bands
% 5th dim --> subjects
clc; clear;

%% Loading data
%load('dyngraph-pain/Data/00-Raw data/All_subject_correlation_matrices.mat');
load('dyngraph-pain/Data/01-Adjacency_matrices/Threshold_func_2/adj_mat_func_2.mat');

%%
n_roi = size(M,1); % number of ROI
n_lay = size(M,3); % number of layers
n_freq = size(M,4); % number of frequency bands
n_sub = size(M,5); % number of subjects
M = round(M,11);


%% Sparsity of matrices 
% Note that complete graphs have n(n-1)/2 edges
edge_density_M = zeros(n_lay, n_freq, n_sub);
max_edges = ((length(M(:,:,1,1,1))*(length(M(:,:,1,1,1))-1))/2);
for sub = 1:n_sub
    for freq = 1:n_freq
        for lay = 1:n_lay
            %--- set negative values and diag elements to 0 --------------------
            %M(:, :, lay, freq, sub) = M(:, :, lay, freq, sub) .* (M(:, :, lay, freq, sub) > 0);
            %M(:, :, lay, freq, sub) = M(:, :, lay, freq, sub) - diag(diag(M(:, :, lay, freq, sub)));
       
            number_edges = nnz(M(:,:,lay,freq, sub))/2;
            edge_density_M(lay,freq, sub) = number_edges/max_edges;
        end
    end
end
edge_density_M; %sparsity of matrices

%% Parameters
gamma = 1; % structural resolution paramter for slice s (see resolution limit for more info)
omega = 1; % connection strength between node j in slice s and node j in slice r
%n_rep = 100; % number of iterations for the optimisation

%% Initialise matrices to store data
modularity_mean = zeros(n_rep, n_freq, n_sub); % Mean modularity
modules = zeros(n_rep, n_roi, n_lay, n_freq, n_sub); % Module assigment labels

%% Run community detection algorithm
for sub = 1:n_sub
    subject = sub
    for freq = 1 : n_freq
        %--- define objects ---------------------------------------------------
            A = cell(1, n_lay);
            N = n_roi; T = n_lay;
            B = spalloc(N * T, N * T, N*N*T+2*N*T); 
            twomu = 0; % initialise 2mu
        
            %--- null model -------------------------------------------------------
            for lay = 1 : n_lay
                %--- copy network with positive weights thresholding --------------
                A{lay} = squeeze(M(:, :, lay, freq, sub) .* (M(:, :, lay, freq, sub) > 0));
                k = sum(A{lay});                              % node degree
                twom = sum(k);                                % mean network degree
                twomu = twomu + twom;                         % increment
                indx = [1:N] + (lay-1)*N;                     % find indices of layer
                B(indx,indx) = A{lay} - gamma * [k'*k]/twom;  % use configuration null model
            end
            twomu = twomu + 2*omega* N*(T-1);
            B = B + omega*spdiags(ones(N*T,2),[-N, N], N*T, N*T);

    %--- calculate multilayer modules -------------------------------------
            for rep = 1 : n_rep
                iteration = rep
                [S,Q] = genlouvain2012(B);
                Q = Q / twomu; % Rescale so Q <= 1
                S = reshape(S, n_roi, n_lay);
                modularity_mean(rep, freq, sub) = Q;
                modules(rep,:,:, freq, sub) = S;
            end
    end
end