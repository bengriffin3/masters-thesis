%----------------------------------------------------
% Distance graph analysis
% Author: Ben Griffin
% Last edited: 06-10-2020

% This scripts calculates basic statistical measures of the distance 
% metric graphs, comparing male vs female

%----------------------------------------------------
clear; clc;

n_roi = 98; % number of ROI
n_lay = 28; % number of layers
n_freq = 6; % number of frequency bands

%--- Load calculated metrics ----------------------------------------------

d_hamming = struct2cell(load('dyngraph-pain/Data/05-Distance_metrics/threshold_func_3/d_hamming.mat')); % Hamming distance
d_jaccard = struct2cell(load('dyngraph-pain/Data/05-Distance_metrics/threshold_func_3/d_jaccard.mat')); % Jaccard distance
d_st = struct2cell(load('dyngraph-pain/Data/05-Distance_metrics/threshold_func_3/d_st.mat')); % dissimilarity using spanning trees
d_lp = struct2cell(load('dyngraph-pain/Data/05-Distance_metrics/threshold_func_3/d_lp.mat')); % lp distances on eigenvalues
d_IM = struct2cell(load('dyngraph-pain/Data/05-Distance_metrics/threshold_func_3/d_IM.mat')); % Ipsen-Mikhailov distance
d_HIM = struct2cell(load('dyngraph-pain/Data/05-Distance_metrics/threshold_func_3/d_HIM.mat')); % Hamming-Ipsen-Mikhailov distance with xi = 1
d_poli = struct2cell(load('dyngraph-pain/Data/05-Distance_metrics/threshold_func_3/d_poli.mat')); % polynomial distances
d_centrality = struct2cell(load('dyngraph-pain/Data/05-Distance_metrics/threshold_func_3/d_centrality.mat')); % centrality distance (using betweenness)
d_hsw = struct2cell(load('dyngraph-pain/Data/05-Distance_metrics/threshold_func_3/d_hsw.mat')); % heat spectral wavelets distance
n_metric = 9;
metrics = ["Hamming distance","Jaccard distance","Dissimilarity using spanning trees","lp distance using f(x) = e^{(-1.2x)}",...
    "Ipsen-Mikhailov","Hamming-Ipsen-Mikhailov with \xi = 1","Polynomial distance","Centrality distance (using betweenness)", "Heat spectral wavelets"];
frequency_bands = ["[1-4] Delta","[4-8] Theta","[8-13] Alpha","[13-30] Beta","[30-60] Low Gamma","[60-150] High Gamma"];



%%
%--- Combine distances into a new cell array ------------------------------
C = cell(n_metric,1);
C{1} = d_hamming{1};
C{2} = d_jaccard{1};
C{3} = d_st{1};
C{4} = d_lp{1};
C{5} = d_IM{1};
C{6} = d_HIM{1};
C{7} = d_poli{1};
C{8} = d_centrality{1};
C{9} = d_hsw{1};

%%
%--- Average distances over desired subjects (e.g. all 30, or m/f) --------
for ii = 1:n_metric
    a = C{ii};
    fem = a(:,:,:,1:14);
    mal = a(:,:,:,15:28);
    F{ii} = fem;
    M{ii} = mal;
    F_mean{ii} = mean(F{ii},4);
    M_mean{ii} = mean(M{ii},4);
end
%%
n_stat = 7;
%--- Initialise variables -------------------------------------------------
F_stats = zeros(n_lay-1,n_freq,n_metric);
M_stats = zeros(n_lay-1,n_freq,n_metric);
F_stats_analysis = zeros(n_freq,n_metric,n_stat);
M_stats_analysis = zeros(n_freq,n_metric,n_stat);

for metric = 1:n_metric
    measure_array_F = F_mean{metric};
    measure_array_M = M_mean{metric};
    for freq = 1:n_freq
        %--- Choose which distances to analyse ----------------------------
        %%% Two examples are given below:
        %%% (i) distance betwen time window 1 and time window t = 2,...,28
        %%% (ii) distance between time window t and time window t+1 for t = 1,...,27

        F_stats(:,freq,metric) = measure_array_F(1,2:28, freq, :); %(i)
        M_stats(:,freq,metric) = measure_array_M(1,2:28, freq, :); %(i)
        
        %F_stats(:,freq,metric) = diag(measure_array_F(:,:,freq),-1); %(ii)
        %M_stats(:,freq,metric) = diag(measure_array_F(:,:,freq),-1); %(ii)
        
        %--- Calculated desired statistics --------------------------------
        F_stats_analysis(freq,metric,1) = max(F_stats(:,freq,metric));
        M_stats_analysis(freq,metric,1) = max(M_stats(:,freq,metric));
        
        F_stats_analysis(freq,metric,2) = min(F_stats(:,freq,metric));
        M_stats_analysis(freq,metric,2) = min(M_stats(:,freq,metric));
        
        F_stats_analysis(freq,metric,3) = mean(F_stats(:,freq,metric));
        M_stats_analysis(freq,metric,3) = mean(M_stats(:,freq,metric));
        
        F_stats_analysis(freq,metric,4) = median(F_stats(:,freq,metric));
        M_stats_analysis(freq,metric,4) = median(M_stats(:,freq,metric));
        
        F_stats_analysis(freq,metric,5) = std(F_stats(:,freq,metric));
        M_stats_analysis(freq,metric,5) = std(M_stats(:,freq,metric));
        
        F_stats_analysis(freq,metric,6) = var(F_stats(:,freq,metric));
        M_stats_analysis(freq,metric,6) = var(M_stats(:,freq,metric));
        
        F_stats_analysis(freq,metric,7) = iqr(F_stats(:,freq,metric));
        M_stats_analysis(freq,metric,7) = iqr(M_stats(:,freq,metric));
        
    end
    %--- Female boxplots --------------------------------------------------
    figure(1)
    subplot(3,3,metric)
    boxplot(F_stats(:,:,metric),'Labels',{'Delta','Theta','Alpha','Beta','L gamma','H gamma'})
    xlabel('Frequency band'); ylabel('Distance');
    title(metrics(metric));
    
    
    %--- Male boxplots ----------------------------------------------------
	figure(2)
    subplot(3,3,metric)
    boxplot(M_stats(:,:,metric),'Labels',{'Delta','Theta','Alpha','Beta','L gamma','H gamma'})
    xlabel('Frequency band');ylabel('Distance');
    title(metrics(metric)); 
    
end
%%
%--- plot first metric for all 6 bands (m+f) ------------------------------
figure(3)
subplot(1,2,1)
box = F_stats(:,:,1);
boxplot(F_stats(:,:,1))

subplot(1,2,2)
box = M_stats(:,:,1);
boxplot(box)
%%
%--- T-tests comparing m + f means ----------------------------------------
% Done for first frequency band and 1st metric
% Note mean
mean_F = F_stats_analysis(1,1,3)
mean_M = M_stats_analysis(1,1,3)

% Note std
s_F = F_stats_analysis(1,1,5)
s_M = M_stats_analysis(1,1,5)

% Note number of time windows that we have measurements for
n_F = 27
n_M = 27

% Calculate standard error
SE = sqrt((s_F^2/n_F) + ((s_M^2)/n_M))

% Calculate degrees of freedom
DF = (n_M+n_F)/2

% Calculate test statistic
t = ((mean_F - mean_M) - 0) / SE
