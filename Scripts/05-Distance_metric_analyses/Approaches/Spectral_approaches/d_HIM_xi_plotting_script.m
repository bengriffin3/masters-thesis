%----------------------------------------------------
% HIM plotter
%
% This script plots the graph of the HIM distance as we change xi for 
% a selected network. We compare the same graphs for all 6 frequency bands
% to see how the distances change with respect to xi.
%----------------------------------------------------
clear; clc;
load('dyngraph-pain/Subject_data_and_analysis/Distance_metrics/Threshold_func_3/d_hamming.mat')
load('dyngraph-pain/Subject_data_and_analysis/Distance_metrics/Threshold_func_3/d_IM.mat')
n_freq = size(d_hamming,3); % number of frequency bands

%--- Average distance over 30 subjects ------------------------------------
d_hamming_mean = mean(d_hamming,4);
d_IM_mean = mean(d_IM,4);

%--- Choose values of xi to plot ------------------------------------------
xi_vec = [0:0.1:50];
len_xi = length(xi_vec);
xi_vec_len = [0:len_xi-1];

d_HIM = zeros( n_freq, len_xi); % initialise HIM distance

for freq = 1:n_freq
    freq_band = freq;
    for ii = 1:len_xi
        xi = xi_vec(ii);
        %--- Calculate Hamming-Ipsen-Mikhailov distances ------------------
        % We calculate the distance between time window 1 and 2
        d_HIM(freq,ii) = sqrt(d_IM_mean(2,1,freq)^2 + (xi* d_hamming_mean(2,1,freq)^2)) / sqrt(1+xi);
       
    end
end
% --- Plot HIM distance as xi changes -------------------------------------
figure(1)
plot(xi_vec_len,d_HIM(1,:),xi_vec_len,d_HIM(3,:),xi_vec_len,d_HIM(3,:),...
    xi_vec_len,d_HIM(4,:),xi_vec_len,d_HIM(5,:),xi_vec_len,d_HIM(6,:),'LineWidth',1.5)
hold on
xlabel('\eta', 'FontSize', 16); ylabel('HIM_{\eta}', 'FontSize', 16);
lgd = legend('Delta','Theta','Alpha','Beta','Low gamma','High gamma');
lgd.FontSize = 16;
set(gca,'XTick',[])
set(gca,'FontSize',20)
grid on


