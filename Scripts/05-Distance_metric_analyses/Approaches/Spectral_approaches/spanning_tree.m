function [d_st] = spanning_tree(A,A_bar)
%----------------------------------------------------
% This function takes two adjacency matrices, A and A_bar and calculates 
% the spanning tree distance between them, as described in:
% 'Tracking network dynamics: a survey of distances and similarity metrics'
% https://arxiv.org/abs/1801.07351

%----------------------------------------------------

%--- Calculate Laplacians -------------------------------------------------
L_A = diag(sum(A,2)) - A;
L_A_bar = diag(sum(A_bar,2)) - A_bar;
  

%--- Calculate number of spanning trees using Matrix-Tree theorem ---------
%  The number of spanning trees is a cofactor of the Laplacian matrix
% (Note that rounding "removes" numerical inaccuracies...)
N_spantree_A = round(det(L_A(2:end, 2:end)));
N_spantree_A_bar = round(det(L_A_bar(2:end, 2:end)));


%--- Calculate spanning tree 'distance' -----------------------------------
d_st = abs(log(N_spantree_A) - log(N_spantree_A_bar));

end