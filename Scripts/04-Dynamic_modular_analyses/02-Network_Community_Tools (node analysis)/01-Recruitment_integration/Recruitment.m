function [Recruitment,recruitment_colours] = recruitment(MA,systemByNode)
%RECRUITMENT      Recruitment coefficient
%
%   R = RECRUITMENT(MA,systemByNode) calculates the recruitment coefficient
%   for each node of the network. The recruitment coefficient of a region
%   corresponds to the average probability that this region is in the same
%   network community as other regions from its own system.
%
%   Inputs:     MA,     Module Allegiance matrix, where element (i,j) 
%                       represents the probability that nodes i and j
%                       belong to the same community
%               systemByNode,	vector or cell array containing the system
%                       assignment for each node
%
%   Outputs:    I,              recruitment coefficient for each node
%   _______________________________________________
%   Code from: Marcelo G Mattar (08/21/2014)
%   See http://commdetect.weebly.com/ for more info
%% load systemByNode vector and allegiance matrix
systemByNode = load('dyngraph-pain/Data/04-Dynamic_modular_analyses/Functional_system_data/Original/AAL_module_assigned_numbers.txt');
systemByNode = sort(systemByNode);
load('dyngraph-pain/Data/04-Dynamic_modular_analyses/Modular_allegiance_matrix/allegiance_matrix_opt_mean.mat');
allegiance_mat = P;
n_roi = size(allegiance_mat,1);
n_freq = size(allegiance_mat,3);
n_sub = size(allegiance_mat,4);





%% Calculate the recruitment for each node
Recruitment = zeros(length(systemByNode),n_freq, n_sub);
R = zeros(length(systemByNode),1);
for sub = 1:n_sub
    for freq = 1 : n_freq
        MA = allegiance_mat(:,:,freq,sub); % for each frequency band
        MA(logical(eye(size(MA)))) = nan; % set diagonal to NaN
        if iscell(systemByNode)
            for i=1:length(systemByNode)
                thisSystem = systemByNode{i};
                R(i) = nanmean(MA(i,strcmp(systemByNode,thisSystem)));
            end
        else
            for i=1:length(systemByNode)
                thisSystem = systemByNode(i);
                R(i) = nanmean(MA(i,systemByNode==thisSystem));
            end
        end
        Recruitment(:,freq, sub) = R;
    end
end
%save('Recruitment_by_node','Recruitment')

% the recruitment R(i) gives the average probability that the ith brain
% region is in the same comunity as other regions in the same system as
% itself, say system S (see page 17 'A functional Cartography of Cognitive
% Systems' for more info).

%%
%--- Split into colours based on size of recruitment of each ROI ----------
number_colours = 6;
recruitment_colours = zeros(98,6);

for freq = 1:n_freq
    rec = Recruitment(:,freq);
    c = min(rec):(max(rec)-min(rec))/number_colours:max(rec);
    for ii = 1:n_roi
        for j = 1:number_colours
            if rec(ii) >= c(j) & rec(ii) < c(j+1)
            recruitment_colours(ii,freq) = j;
            end
        end
    end
end
%--- Set the colour of the largest element --------------------------------
recruitment_colours(recruitment_colours ==0) = number_colours;
recruitment_colours(:,1);
%save('Recruitment_colour_by_node','recruitment_colours')
end