function [d_IM] = dIM(G, G_bar, gamma)
%----------------------------------------------------
% This function takes two adjacency matrices, forms their Laplacians and 
% then calculates the Ipsen-Mikheailov distance between them, as described in:
% 'Tracking network dynamics: a survey of distances and similarity metrics'
% https://arxiv.org/abs/1801.07351

% Code adapted from:
% https://github.com/netsiphd/netrd/blob/master/netrd/distance/ipsen_mikhailov.py

%----------------------------------------------------
n_roi = length(G);

%--- Form Laplacian's from adjacency matrices -----------------------------
L_G = diag(sum(G,2)) - G;
L_G_bar = diag(sum(G_bar,2)) - G_bar;


%--- Find sqrt eigenvalues (+ omega's) ------------------------------------
[U,S,V] = svd(L_G);
w_G = sqrt(diag(S));

[U,S,V] = svd(L_G_bar);
w_G_bar = sqrt(diag(S));


%--- Determine normalization constant K -----------------------------------
K_G = 1 / (((n_roi-1)*pi/2) + sum(atan(w_G/gamma)));
K_G_bar = 1 / (((n_roi-1)*pi/2) + sum(atan(w_G_bar/gamma)));


%--- Define spectral densities --------------------------------------------
density_1 = @(w) K_G * sum(gamma ./ (gamma^2 + (w - w_G).^2));
density_2 = @(w) K_G_bar * sum(gamma ./ (gamma^2 + (w - w_G_bar).^2));


%--- Determine IM 'distance' ----------------------------------------------
func = @(w) (density_1(w) - density_2(w))^2;
d_IM = sqrt(integral (func, 0, inf, 'ArrayValued', true));

end
