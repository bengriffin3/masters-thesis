function Integration = Integration(MA,systemByNode)
%INTEGRATION      Integration coefficient
%
%   I = INTEGRATION(MA,systemByNode) calculates the integration coefficient
%   for each node of the network. The integration coefficient of a region
%   corresponds to the average probability that this region is in the same
%   network community as regions from other systems.
%
%   Inputs:     MA,     Module Allegiance matrix, where element (i,j) 
%                       represents the probability that nodes i and j
%                       belong to the same community
%               systemByNode,	vector or cell array containing the system
%                       assignment for each node
%
%   Outputs:    I,              integration coefficient for each node
%   _______________________________________________
%   Marcelo G Mattar (08/21/2014) 

%% load systemByNode vector and allegiance matrix
systemByNode = load('dyngraph-pain/Data/04-Dynamic_modular_analyses/Functional_system_data/Original/AAL_module_assigned_numbers.txt');
systemByNode = sort(systemByNode);
load('dyngraph-pain/Data/04-Dynamic_modular_analyses/Modular_allegiance_matrix/allegiance_matrix_opt_mean.mat');


allegiance_mat = P;
n_roi = size(allegiance_mat,1);
n_freq = size(allegiance_mat,3);
n_sub = size(allegiance_mat,4);

%% Calculate the integration for each node
Integration = zeros(length(systemByNode),n_freq, n_sub);
I = zeros(length(systemByNode),1);

% Calculate the integration for each node
for sub = 1 : n_sub
    for freq = 1 : n_freq
        MA = allegiance_mat(:,:,freq, sub); % for each frequency band
        MA(logical(eye(size(MA)))) = nan; % set diagonal to NaN
        if iscell(systemByNode)
            for i=1:length(systemByNode)
                thisSystem = systemByNode{i};
                I(i) = nanmean(MA(i,~strcmp(systemByNode,thisSystem)));
            end
        else
            for i=1:length(systemByNode)
                thisSystem = systemByNode(i);
                I(i) = nanmean(MA(i,~(systemByNode==thisSystem)));
            end
        end
        Integration(:,freq, sub) = I;
    end
end
Integration;

%save('Integration_by_node','Integration')
% the integration I(i) gives the average probability that the ith brain
% region is in the same comunity as other regions from different systems
% to its own system (say system S) (see page 17 'A functional Cartography of Cognitive
% Systems' for more info).

%%
%--- Split into colours based on size of recruitment of each ROI ----------
number_colours = 6;
integration_colours = zeros(98,6);

for freq = 1:n_freq
    int = Integration(:,freq);
    c = min(int):(max(int)-min(int))/number_colours:max(int);
    for ii = 1:n_roi
        for j = 1:number_colours
            if int(ii) >= c(j) & int(ii) < c(j+1)
            integration_colours(ii,freq) = j;
            end
        end
    end
end
%--- Set the colour of the largest element --------------------------------
integration_colours(integration_colours ==0) = number_colours;
integration_colours
%save('Integration_colour_by_node','integration_colours')
end