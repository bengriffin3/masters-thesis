function [norm] = norm_2_2(M_1, M_2)
%----------------------------------------------------
% This function takes two adjacency matrices, M_1 and M_2 and calculates 
% the norm ||M_1 - M_2||_2,2 as in:
% 'Tracking network dynamics: a survey of distances and similarity metrics'
% https://arxiv.org/abs/1801.07351

%----------------------------------------------------

norm = 0; % initialise norm
        
for ii = 1:size(M_1,1)
    for j = 1:size(M_1,1)
        norm_2_2_consecutive = abs(M_1(ii,j) - M_2(ii,j))^2;
        norm = norm + norm_2_2_consecutive;
    end
end
norm = sqrt(norm); % sqrt to get 2,2 norm
        
end

