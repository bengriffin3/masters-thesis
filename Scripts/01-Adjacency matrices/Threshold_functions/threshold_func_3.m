function [adj_matrix] = threshold_func_3(M,n_iter)
%----------------------------------------------------
% This function takes an n x n functional connectivity matrix and forms an
% adjacency matrix using the two stage algorithm found in 'A two-stage
% algorithm for extracting the multiscale backbone of complex weighted
% networks' (found here: https://www.pnas.org/content/106/26/E66).

%----------------------------------------------------

if nargin<2
    n_iter = 100;
end
M = M - diag(diag(M)); % Set digaonal elements to 0
M = M .* (M > 0); % Set negative elements to 0

%--- Stage 1 of algorithm -------------------------------------------------
% Form double stochastic table
for iter = 1:n_iter
   for ii = 1:length(M)
       M(ii,:) = M(ii,:)./sum(M(ii,:)); % normalise row
       M(:,ii) = M(:,ii)./sum(M(:,ii)); % normalise column
   end
end
M = tril(M);
adj_matrix = zeros(length(M),length(M));

%--- Stage 2 of algorithm--------------------------------------------------
% Add strongest edge until a connected graph is formed
for ii = 1:length(M(:))
    iter = ii;
    %--- Check if the graph is connected ----------------------------------  
    g = digraph(adj_matrix);
    bins = conncomp(g, 'Type', 'weak');
    isConnected = all(bins == 1);
    
    
    %--- If the graph is disconnected -------------------------------------
    if isConnected == 0
        %--- find index of the maximum element ----------------------------
        maximum = max(max(M(M<1)));
        [x,y] = find(M == maximum);
        
        
        for ii = 1:length(x)
            %--- Add edge to adjacency matrix -----------------------------
            adj_matrix(x(ii),y(ii)) = 1;
            adj_matrix(y(ii),x(ii)) = 1;
            
            
            %--- Set element to 0 so it won't be chosen again ------------
            M(x(ii),y(ii)) = 0;
            
            
        end
    else
    %--- If the graph is connected we are done-----------------------------
        break
    end
end
end

