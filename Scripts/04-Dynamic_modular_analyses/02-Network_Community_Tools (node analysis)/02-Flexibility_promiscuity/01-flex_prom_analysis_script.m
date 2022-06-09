%----------------------------------------------------
% Flexibility and promiscuity calculator
% Author: Ben Griffin
% Last edited: 01-07-2020

% This scripts calculates the flexibility and promiscuity coefficients for
% a provided subject data.

% Flexibility and promiscuity defined here: http://commdetect.weebly.com/

%----------------------------------------------------
%% load community detection matrices
load('dyngraph-pain/Data/02-Community_detection/Threshold_func_3/modules.mat');

%%
size(modules);
n_iter = size(modules,1);
n_roi = size(modules,2);
n_lay = size(modules,3);
n_freq = size(modules,4);
n_sub = size(modules,5);

%--- Initialise variables -------------------------------------------------
flex = zeros(n_iter,n_roi,n_freq,n_sub);
prom = zeros(n_iter,n_roi,n_freq,n_sub);
flex_mean = zeros(n_roi,n_freq,n_sub);
prom_mean = zeros(n_roi,n_freq,n_sub);

for sub = 1:n_sub
    subject_number = sub
    for freq = 1:n_freq

        for iter = 1:n_iter
            M = squeeze(modules(iter,:,:,freq, sub))';
            %--- Calculate flexibility and promiscuity ------------------------
            flex(iter, :,freq, sub) = flexibility(M);
            prom(iter, :,freq, sub) = promiscuity(M);

        end

        %--- Calculate mean flexibility and promiscuity over 100 iterations ---
        flex_mean = squeeze(mean(flex,1));
        prom_mean = squeeze(mean(prom,1));

    end
end
%%
% If we want to average out over all subjects
% flex_mean = mean(flex_mean,3)
% prom_mean = mean(prom_mean,3)

% If we want to average out over all frequency bands
% flex_mean = mean(flex_mean,2)
% prom_mean = mean(prom_mean,2)

%%
%--- Split into colours based on size of recruitment of each ROI ----------
number_colours = 6;
flexibility_colours = zeros(n_roi,n_freq);
promiscuity_colours = zeros(n_roi,n_freq);

for freq = 1:n_freq
    flex = flex_mean(:,freq);
    c_flex = min(flex):(max(flex)-min(flex))/number_colours:max(flex);
    for ii = 1:n_roi
        for j = 1:number_colours
            if flex(ii) >= c_flex(j) & flex(ii) < c_flex(j+1)
            flexibility_colours(ii,freq) = j;
            end
        end
    end
    
    prom = prom_mean(:,freq);
    c_prom = min(prom):(max(prom)-min(prom))/number_colours:max(prom);
     for ii = 1:n_roi
        for j = 1:number_colours
            if prom(ii) >= c_prom(j) & prom(ii) < c_prom(j+1)
            promiscuity_colours(ii,freq) = j;
            end
        end
    end
end


%--- Set the colour of the largest element --------------------------------
flexibility_colours(flexibility_colours ==0) = number_colours;
flexibility_colours(:,1)
promiscuity_colours(promiscuity_colours ==0) = number_colours;
promiscuity_colours(:,1);

