%----------------------------------------------------
% Plotting the 'distance' metrics we have calculated for the dissertation,
% using the methods described in:
% 'Tracking network dynamics: a survey of distances and similarity metrics'
% https://arxiv.org/abs/1801.07351
%----------------------------------------------------
clear;clc;

n_roi = 98; % number of ROI
n_lay = 28; % number of layers
n_freq = 6; % number of frequency bands

top_dir = 'dyngraph-pain/Data/';
thresh = 'Threshold_func_3'; % set threshold function choice

%--- Load calculated metrics and matrix densities -------------------------
edge_density_adj = struct2cell(load(strcat(top_dir,'01-Adjacency_matrices/',thresh,'/edge_density_adj_func_3.mat')));

d_hamming = struct2cell(load(strcat(top_dir,'05-Distance_metrics_analyses/',thresh,'/d_hamming.mat'))); % Hamming distance
d_jaccard = struct2cell(load(strcat(top_dir,'05-Distance_metrics_analyses/',thresh,'/d_jaccard.mat'))); % Jaccard distance 
d_st = struct2cell(load(strcat(top_dir,'05-Distance_metrics_analyses/',thresh,'/d_st.mat'))); % dissimilarity using spanning trees
d_lp = struct2cell(load(strcat(top_dir,'05-Distance_metrics_analyses/',thresh,'/d_lp.mat'))); % lp distances on eigenvalues
d_IM = struct2cell(load(strcat(top_dir,'05-Distance_metrics_analyses/',thresh,'/d_IM.mat'))); % Ipsen-Mikhailov distance
d_HIM = struct2cell(load(strcat(top_dir,'05-Distance_metrics_analyses/',thresh,'/d_HIM.mat'))); % Hamming-Ipsen-Mikhailov distance with xi = 1
d_poli = struct2cell(load(strcat(top_dir,'05-Distance_metrics_analyses/',thresh,'/d_poli.mat'))); % polynomial distances
d_centrality = struct2cell(load(strcat(top_dir,'05-Distance_metrics_analyses/',thresh,'/d_centrality.mat'))); % centrality distance (using betweenness)
d_hsw = struct2cell(load(strcat(top_dir,'05-Distance_metrics_analyses/',thresh,'/d_hsw.mat'))); % heat spectral wavelets distance

n_metrics = 9;
metrics = ["Hamming distance","Jaccard distance","Dissimilarity using spanning trees","lp distance using f(x) = e^{(-1.2x)}",...
    "Ipsen-Mikhailov","Hamming-Ipsen-Mikhailov with \xi = 1","Polynomial distance","Centrality distance (using betweenness)", "Heat spectral wavelets"];
frequency_bands = ["[1-4] Delta","[4-8] Theta","[8-13] Alpha","[13-30] Beta","[30-60] Low Gamma","[60-150] High Gamma"];

%%
%--- Combine distances into a new cell array ------------------------------
C = cell(n_metrics,1);
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

for ii = 1:n_metrics
%     met = C{ii};
%     F_all{ii} = met(:,:,:,1:15);
%     M_all{ii} = met(:,:,:,16:30);
%     M{ii} = mean(M_all{ii},4);
%     F{ii} = mean(F_all{ii},4);
      edge_density_plot = mean(edge_density_adj{1},3);
      C{ii} = mean(C{ii},4)
end

%%
%--- Plot distance metrics as heatmaps ------------------------------------
for metric = 1:n_metrics
    figure('NumberTitle', 'off', 'Name', metrics(metric));
    measure_array = C{metric};
    for freq = 1:n_freq
        subplot(2,3,freq)
        %--- Set specific axis limits -------------------------------------
        %clims = [0 0.7];
        %imagesc(measure_array(:,:,freq),clims)
        
        %--- Plot heatmaps ------------------------------------------------
        imagesc(tril(measure_array(:,:,freq)))
        title(sprintf(frequency_bands(freq)))
        xlabel('Time window'); ylabel('Time window')
        set(gca,'FontSize',24)
        colorbar
    end
end
%% Plot the two Jaccard distance graphs for the dissertation
figure(2)
measure_array_plot = C{2};
for freq = 1:n_freq
    plot(1:27, measure_array_plot(1,2:28, freq),'x-','LineWidth',1.5);
    hold on
end
    xlabel('Time window t');
    ylabel('Distance');
    set(gca,'FontSize',24);
    set(gca, 'YGrid', 'on', 'XGrid', 'off')
    
figure(3)
measure_array_plot = C{2};
for freq = 1:n_freq
    plot(1:27, diag(measure_array_plot(:,:,freq),-1),'x-','LineWidth',1.5);
    hold on
end
    xlabel('Time window t');
    ylabel('Distance');
    set(gca,'FontSize',24);
    set(gca, 'YGrid', 'on', 'XGrid', 'off')
    
    
   
%% Plot line graphs
%figure('NumberTitle', 'off', 'Name', 'Line plots');
%figure(2)
for metric = 6%:n_metrics
    %subplot(3,3,metric)
    figure
    measure_array = C{metric};
    for freq = 1:n_freq
        %--- Plot distance metrics as line graphs --------------------------------
        %%% Choose which distances you would like to plot. Two examples are given below:
        %%% (i) distance betwen time window 1 and time window t = 2,...,28. 
        %%% (ii) distance between time window t and time window t+1 for t = 1,...,27
        
        plot(1:27, measure_array(1,2:28, freq),'x-'); %(i)
        %plot(1:27, diag(measure_array(:,:,freq),-1)); %(ii)
        hold on
    end
    %legend('[1-4] Delta','[4-8] Theta','[8-13] Alpha','[13-30] Beta','[30-60] Low Gamma','[60-150] High Gamma')
    %legend('Delta','Theta','Alpha','Beta','Low Gamma','High Gamma')
    xlabel('Time window t');
    %ylabel(metrics(metric));
    ylabel('Distance')
    ylim ([0.1 0.25])
    %title(metrics(metric));
    set(gca,'FontSize',24);
    set(gca, 'YGrid', 'on', 'XGrid', 'off')
end

%% Plot densities

figure('NumberTitle', 'off', 'Name', 'Matrix densities/sparsities');

for freq = 1:n_freq
    plot(1:28, edge_density_plot(:,freq),'x-','linewidth',1.5);
    hold on
end
%legend('[1-4] Delta','[4-8] Theta','[8-13] Alpha','[13-30] Beta','[30-60] Low Gamma','[60-150] High Gamma')
%legend('Delta','Theta','Alpha','Beta','Low Gamma','High Gamma')
xlabel('Time window t');
ylabel('Edge density');
set(gca,'FontSize',44);
set(gca, 'YGrid', 'on', 'XGrid', 'off')
%title('Sparsity of adjacency matrices (mean across 30 subjects)');



        

%% Female vs male plot line graphs
%figure('NumberTitle', 'off', 'Name', 'Line plots');
%figure(2)
for metric = 1%:n_metrics
    measure_array_f = F{metric};
    measure_array_m = M{metric};
    for freq = 1:n_freq
        %--- Plot distance metrics as line graphs --------------------------------
        %figure
        %plot(1:27, measure_array_f(1,2:28, freq),'x-', 'Color','#0072BD','Marker','x','Linewidth',1.5);
        plot(1:27, measure_array_m(1,2:28, freq),'x-','Linewidth',1.5);
        hold on
        grid on
        %title('Females');
        xlabel('Time window 1 to time window t = 2,...,28');
        ylabel(metrics(metric))
        ylim([0.02 0.155])
        set(gca,'FontSize',20);
        
    end
end
%% Boxplots (mean across all subjects)
for metric = 1:n_metrics
    measure_array = C{metric};
    tw_to_plot = measure_array(1,2:28, :)
    figure(metric)
    boxplot([tw_to_plot(:,:,1)'  tw_to_plot(:,:,2)'  tw_to_plot(:,:,3)'  tw_to_plot(:,:,4)'  tw_to_plot(:,:,5)'  tw_to_plot(:,:,6)' ],'Labels',{'Delta','Theta','Alpha','Beta','Low Gamma','High Gamma'})
    %title(metrics(metric))
    %xlabel('Frequency band')
    ylabel('Distance')
    set(gca,'FontSize',2);
    xtickangle(45)
    set(gca, 'YGrid','on')
end

