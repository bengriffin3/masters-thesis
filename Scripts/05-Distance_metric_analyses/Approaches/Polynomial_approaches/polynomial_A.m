function [P] = polynomial_A(A,power_iter,alpha)
%----------------------------------------------------
% This function takes an adjacency matrix and calculates the polynomial
% P(A) = QWQ^T, as described in:
% 'Tracking network dynamics: a survey of distances and similarity metrics'
% https://arxiv.org/abs/1801.07351

%----------------------------------------------------

n_roi = size(A,1); % number of ROI
Wsum = zeros(n_roi,n_roi);
%--- eigenvalue decomposition ---------------------------------------------
[Q,lambda_A] = eig(A);

for iter = 1:power_iter
    
            %--- calculate P(A) = QWQ^T -----------------------------------
            lambda_A_powers = lambda_A^iter;
            W = lambda_A_powers / ((n_roi-1)^(alpha*(iter-1)));
            Wsum = Wsum + W;
end
P = Q*Wsum*Q';
        
        
        
end