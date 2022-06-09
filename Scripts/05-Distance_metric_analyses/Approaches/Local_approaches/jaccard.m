function [d_jaccard] = jaccard(A, A_bar)
%----------------------------------------------------
% This function takes two adjacency matrices, A and A_bar and calculates 
% the Jaccard distance between them, as described in:
% 'Tracking network dynamics: a survey of distances and similarity metrics'
% https://arxiv.org/abs/1801.07351

%----------------------------------------------------

n_roi = size(A,1); % number of ROI

 %--- Calculate the union and intersecttion of adjacency matrices ---------
intersect = A & A_bar;
union = A | A_bar;

 %--- Calculate the jaccard index and distance ----------------------------
jaccardIndex = sum(intersect(:))/sum(union(:));
d_jaccard = 1 - jaccardIndex;

end