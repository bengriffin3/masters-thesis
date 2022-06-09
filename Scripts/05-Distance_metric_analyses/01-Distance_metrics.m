%----------------------------------------------------
% Calculating 'distance' metrics as found in the paper 'Tracking Network
% Dynamics: A Survey Using Graph Distances' by C. Donnat and S. Holmes
% https://arxiv.org/abs/1801.07351

% This script takes an adjacency matrix of size n_roi x n_roi x n_lay x
% n_freq and calculates the 'distance' metrics between every layer (or time
% window).

% The output for each 'distance' metric is an n_lay x n_lay x n_freq array,
% where for each frequency band, the element i,j of the n_lay x n_lay
% matrix represents the 'distance' between time window i and time window j.

%----------------------------------------------------
clear; clc;

%--- Load and store adjacency matrices ------------------------------------
thresh = 'Threshold_func_3'; % set threshold function choice
load(strcat('dyngraph-pain/Data/01-Adjacency_matrices/',thresh,'/adj_mat_func_3.mat'))
M = adj_mat_func_3;

n_roi = size(M,1); % number of ROI
n_lay = size(M,3); % number of layers
n_freq = size(M,4); % number of frequency bands
n_sub = size(M,5); % number of subjects


%% LOCAL APPROACHES
%--- Initialise storage arrays --------------------------------------------
d_hamming = zeros(n_lay, n_lay, n_freq, n_sub);
d_jaccard = zeros(n_lay, n_lay, n_freq, n_sub);

for sub = 1:n_sub
    subject = sub
    for freq = 1:n_freq
        for lay_row = 1:n_lay
            for lay_col = 1:n_lay
                %--- Calculate local distances ------------------------------------
                d_hamming(lay_col,lay_row,freq, sub) = hamming(M(:,:,lay_col,freq, sub),M(:,:,lay_row,freq, sub));
                d_jaccard(lay_col,lay_row,freq, sub) = jaccard(M(:,:,lay_col,freq, sub),M(:,:,lay_row,freq, sub));

        
            end
        end
    end
    end
    
d_hamming;
d_jaccard;


%% SPECTRAL APPROACHES

%--- Initialise storage arrays --------------------------------------------
d_st = zeros(n_lay, n_lay, n_freq, n_sub);
%d_lp = zeros(n_lay, n_lay, n_freq, n_sub);
d_IM = zeros(n_lay, n_lay, n_freq, n_sub);
d_HIM = zeros(n_lay, n_lay, n_freq, n_sub);

%--- Choose function for l_p distance and parameters p and xi -------------
p = 2;
gamma = 0.08;
%func = @(x) x % identity function
%func = @(x) exp(-1.2*x);
xi = 1;

for sub = 1:n_sub
    subject = sub
    for freq = 1:n_freq
        for lay_row = 1:n_lay
            for lay_col = 1:n_lay
            %--- Calculate spanning tree dissimlarity -------------------------
            d_st(lay_col,lay_row,freq,sub) = spanning_tree(M(:,:,lay_col,freq,sub),M(:,:,lay_row,freq,sub));
        
        
            %--- Calculate lp distances on eigenvalues ------------------------
            %d_lp(lay_col,lay_row,freq,sub) = dlp(M(:,:,lay_col,freq,sub),M(:,:,lay_row,freq,sub),p, func); % compare adjacency matrices
            %d_lp(lay_col,lay_row,freq,sub) = dlp(L(:,:,lay_col,freq,sub),L(:,:,lay_row,freq,sub),p, func); % compare Laplacian matrices
            %d_lp(lay_col,lay_row,freq,sub) = dlp(L_norm(:,:,lay_col,freq,sub),L_norm(:,:,lay_row,freq,sub),p, func); % compare normalised Laplacians
        
        
            %--- Calculate Ipsen-Mikhailov distances --------------------------
            % We input adj matrices but the IM distance is measured from the Laplacian matrices
            d_IM(lay_col,lay_row,freq,sub) = dIM(M(:,:,lay_col,freq,sub),M(:,:,lay_row,freq,sub),gamma);
        
        
            %--- Calculate Hamming-Ipsen-Mikhailov distances ------------------
            d_HIM(lay_col,lay_row,freq,sub) = (1/sqrt(1+xi))*sqrt(d_IM(lay_col,lay_row,freq,sub)^2 + xi* d_hamming(lay_col,lay_row,freq,sub)^2);
        
        
            end
        end
    end
end

%% POLYNOMIAL APPROACH
%--- Set parameters --------------------------------------------
power_iter = 20;
alpha = 0.9;

%--- Initialise storage arrays --------------------------------------------
P = zeros(n_roi,n_roi,n_lay,n_freq,n_sub);
d_poli = zeros(n_lay, n_lay, n_freq,n_sub);
norm = zeros(n_lay-1,n_freq,n_sub);
    
for sub = 1:n_sub
    subject = sub
    for freq = 1:n_freq
        for lay = 1:n_lay
            %--- Calculate P(A) for all adjacency matrices --------------------
            P(:,:,lay,freq,sub) = polynomial_A(M(:,:,lay,freq,sub),power_iter,alpha);
        end
    
        for lay_row = 1:n_lay
            for lay_col = 1:n_lay
                %--- calculate the polynomial 'distance' ----------------------
                norm = norm_2_2(P(:,:,lay_col,freq,sub),P(:,:,lay_row,freq,sub));
                d_poli(lay_col,lay_row,freq,sub) = norm/(n_roi*n_roi);
            
 
            end
        end
    end
end


%% MESOSCALE APPROACH
%--- Set parameters and centrality measure --------------------------------
p = 2;
tau = 1.2;
centrality_measure = 'betweenness';

%--- Initialise storage arrays --------------------------------------------
d_centrality = zeros(n_lay, n_lay, n_freq,n_sub);
normalised_centrality_col_lay = zeros(n_roi,n_lay, n_lay, n_freq,n_sub);
normalised_centrality_row_lay = zeros(n_roi,n_lay, n_lay, n_freq,n_sub);
d_hsw = zeros(n_lay, n_lay, n_freq,n_sub);
    
for sub = 1:n_sub
    subject = sub
    for freq = 1:n_freq
        for lay_row = 1:n_lay
            for lay_col = 1:n_lay
                %--- Calculate the centrality 'distance' ----------------------                
                % Calculate centrality
                centrality_col_lay = centrality(graph(M(:,:,lay_col,freq,sub)),centrality_measure);
                centrality_row_lay = centrality(graph(M(:,:,lay_row,freq,sub)),centrality_measure);
                
                % Normalise centrality
                normalised_centrality_col_lay(:,lay_col,lay_row,freq,sub) = 2*centrality_col_lay./((n_roi-2)*(n_roi-1));
                normalised_centrality_row_lay(:,lay_col,lay_row,freq,sub) = 2*centrality_row_lay./((n_roi-2)*(n_roi-1));
                
                % Calculate distance
                d_centrality(lay_col,lay_row,freq,sub) = (sum((normalised_centrality_row_lay(:,lay_col,lay_row,freq,sub) - normalised_centrality_col_lay(:,lay_col,lay_row,freq,sub)).^p)).^(1/p);
        
            
                %--- Calculate the heat spectral wavelet 'distance' -----------
                d_hsw(lay_col,lay_row,freq,sub) = heat_spectral_wavelets(M(:,:,lay_col,freq,sub),M(:,:,lay_row,freq,sub));
            
            
            
            end
        end
    end
end

%% Save all calculated metrics
save(strcat('dyngraph-pain/Data/05-Distance_metrics_analyses/',thresh,'/d_hamming.mat'),'d_hamming')
save(strcat('dyngraph-pain/Data/05-Distance_metrics_analyses/',thresh,'/d_jaccard.mat'),'d_jaccard')
save(strcat('dyngraph-pain/Data/05-Distance_metrics_analyses/',thresh,'/d_st.mat'),'d_st')
%save(strcat('dyngraph-pain/Data/05-Distance_metrics_analyses/',thresh,'/d_lp.mat'),'d_lp')
save(strcat('dyngraph-pain/Data/05-Distance_metrics_analyses/',thresh,'/d_IM.mat'),'d_IM')
save(strcat('dyngraph-pain/Data/05-Distance_metrics_analyses/',thresh,'/d_HIM.mat'),'d_HIM')
save(strcat('dyngraph-pain/Data/05-Distance_metrics_analyses/',thresh,'/d_poli.mat'),'d_poli')
save(strcat('dyngraph-pain/Data/05-Distance_metrics_analyses/',thresh,'/d_centrality.mat'),'d_centrality')
save(strcat('dyngraph-pain/Data/05-Distance_metrics_analyses/',thresh,'/d_hsw.mat'),'d_hsw')
