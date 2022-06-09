function [d_hsw] = heat_spectral_wavelets(A_2,A_3,tau)
%----------------------------------------------------
% This function takes two adjacency matrices, A_2 and A_3 and calculates 
% the heat spectral wavelet distance between them as described in:
% 'Tracking network dynamics: a survey of distances and similarity metrics'
% https://arxiv.org/abs/1801.07351


%----------------------------------------------------
n_roi = size(A_2,1); % number of ROI

if nargin<3
    tau = 1.2;
end

%--- Calculate Laplacian's and store their eigenvalues --------------------
L_2 = diag(sum(A_2,2)) - A_2;
L_3 = diag(sum(A_3,2)) - A_3;
[V_2,D_2] = eig(L_2);
[V_3,D_3] = eig(L_3);
eig_diag_2 = diag(D_2);
eig_diag_3 = diag(D_3);


%--- Calculate e^-tau*Lambda ----------------------------------------------
mat_2 = diag(exp(-(tau*eig_diag_2)));
mat_3 = diag(exp(-(tau*eig_diag_3)));


%--- Calculate Delta matrix -----------------------------------------------
wavelet_2 = V_2*mat_2*V_2';
wavelet_3 = V_3*mat_3*V_3';
Delta = wavelet_2 - wavelet_3;


%--- Calculate heat spectral wavelet distance -----------------------------
d_hsw = (trace(Delta'*Delta))/n_roi;

end

