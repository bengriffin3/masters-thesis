function [d_lp] = dlp(A, A_bar, p, func)
%----------------------------------------------------
% This function takes two matrices (typically its adjacency matric,
% combinatorial or normalized Laplacian, etc.), A and A_bar and calculates
% the l_p distances on their eigenvalues, as described in:
% 'Tracking network dynamics: a survey of distances and similarity metrics'
% https://arxiv.org/abs/1801.07351

%----------------------------------------------------

%--- Calculate differnce in eigenvalues for A, A_bar ----------------------
eig_diff = abs(func(eig(A)) - func(eig(A_bar)));


%--- Calculate the l_p disatnce -------------------------------------------
eig_diff_p = eig_diff.^p;
d_lp = sum(eig_diff_p);

end