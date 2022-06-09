function [adj_mat] = threshold_func_1(M)
%----------------------------------------------------
% This function takes an n x n functional connectivity matrix and removes
% 1 edge at a time, stopping just before the graph becomes disconnected.
% The function then forms an adjacency matrix of the remaining edges, and
% provides this as the ouput.

% Note: do we want to set negatives to 0 first?

%----------------------------------------------------



%--- Ensure M has only 1 nonzero element for each edge --------------------
M = M .* (M > 0); % remove negative correlations
M = M - diag(diag(M));
M = tril(M);


for j = 1:length(M(:))
    %--- Check if the graph is connected ----------------------------------  
    g = digraph(M);
    bins = conncomp(g, 'Type', 'weak');
    isConnected = all(bins == 1);
    
    
    %--- If graph is connected --------------------------------------------
    % find the index of the smallest nonzero element(s) and remove them
    if isConnected == 1
    min_vec = find(M == min(M(M>0)));
    val_store = zeros(length(min_vec),1);
        for ii = 1:length(min_vec)
            val_store(ii) = M(min_vec(ii));
            M(min_vec(ii)) = 0;
        end
        
    %--- If graph is disonnected ------------------------------------------
    % add the last edge(s) taken out back in and then stop the algorithm
    else
        for ii = 1:length(min_vec)
            M(min_vec(ii)) = val_store(ii);
        end
        break
    end
end

%--- Form adjacency matrix ------------------------------------------------
adj_mat=M~=0;
adj_mat = adj_mat + adj_mat';

end

