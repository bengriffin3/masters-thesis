function [M_adj] = threshold_func_2(M,x)
%----------------------------------------------------
% This function takes an n x n functional connectivity matrix and keeps the
% x% of edges with the strongest connection.

% Note that this method gives a disconnected graph in the sense that there
% does not exist a path from each node to all other nodes.

%----------------------------------------------------

%--- Ensure M has only 1 nonzero element for each edge --------------------
M = M .* (M > 0); % set negative elements to 0
M = M - diag(diag(M));
M = tril(M);

%--- Find the index of the x% strongest edges -----------------------------
threshold_percentage = x/100;
n_roi = size(M,1);
quantile_x = round(threshold_percentage*((n_roi-1)*(n_roi))/2);
[~, sortIndex] = sort(M(:), 'descend');
max_index = sortIndex(1:quantile_x);


%--- Form a new matrix with only the x% of strongest edges ----------------
M_adj = zeros(size(M));
for ii = 1:quantile_x
    M_adj(max_index(ii)) = M(max_index(ii));
end

%--- Form adjacency matrix ------------------------------------------------
M_adj = M_adj + M_adj';
M_adj = M_adj~=0;


%--- Plot the graph  ------------------------------------------------------
% G = graph(A);
% p = plot(G);
end

