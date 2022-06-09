%----------------------------------------------------
% This script joins the raw subject data for all subjects into one matrix.

%----------------------------------------------------
clear;clc;

%--- Initialise variable --------------------------------------------------
n_roi = 98;
n_lay = 28;
n_freq = 6;
n_sub = 30;
M = zeros(n_roi,n_roi,n_lay,n_freq,n_sub);


%--- Load data and add to variable ----------------------------------------
load('dyngraph-pain/Data/00-Raw data/Subject_1_100307/sbj1_HCP.mat')
M(:,:,:,:,1) = squeeze(adjmat);
load('dyngraph-pain/Data/00-Raw data/Subject_2_102816/sbj2_HCP.mat')
M(:,:,:,:,2) = squeeze(adjmat);
load('dyngraph-pain/Data/00-Raw data/Subject_3_104012/sbj3_HCP.mat')
M(:,:,:,:,3) = squeeze(adjmat);
load('dyngraph-pain/Data/00-Raw data/Subject_4_106521/sbj4_HCP.mat')
M(:,:,:,:,4) = squeeze(adjmat);
load('dyngraph-pain/Data/00-Raw data/Subject_5_108323/sbj5_HCP.mat')
M(:,:,:,:,5) = squeeze(adjmat);
load('dyngraph-pain/Data/00-Raw data/Subject_6_133019/sbj6_HCP.mat')
M(:,:,:,:,6) = squeeze(adjmat);
load('dyngraph-pain/Data/00-Raw data/Subject_7_140117/sbj7_HCP.mat')
M(:,:,:,:,7) = squeeze(adjmat);
load('dyngraph-pain/Data/00-Raw data/Subject_8_153732/sbj8_HCP.mat')
M(:,:,:,:,8) = squeeze(adjmat);
load('dyngraph-pain/Data/00-Raw data/Subject_9_156334/sbj9_HCP.mat')
M(:,:,:,:,9) = squeeze(adjmat);
load('dyngraph-pain/Data/00-Raw data/Subject_10_177746/sbj10_HCP.mat')
M(:,:,:,:,10) = squeeze(adjmat);
load('dyngraph-pain/Data/00-Raw data/Subject_11_181232/sbj11_HCP.mat')
M(:,:,:,:,11) = squeeze(adjmat);
load('dyngraph-pain/Data/00-Raw data/Subject_12_189349/sbj12_HCP.mat')
M(:,:,:,:,12) = squeeze(adjmat);
load('dyngraph-pain/Data/00-Raw data/Subject_13_105923/sbj13_HCP.mat')
M(:,:,:,:,13) = squeeze(adjmat);
load('dyngraph-pain/Data/00-Raw data/Subject_14_162026/sbj14_HCP.mat')
M(:,:,:,:,14) = squeeze(adjmat);
load('dyngraph-pain/Data/00-Raw data/Subject_15_175237/sbj15_HCP.mat')
M(:,:,:,:,15) = squeeze(adjmat);
%load('dyngraph-pain/Data/00-Raw data/Subject_16_100307/sbj16_HCP.mat')
%M(:,:,:,:,16) = squeeze(adjmat);
%load('dyngraph-pain/Data/00-Raw data/Subject_17_100307/sbj17_HCP.mat')
%M(:,:,:,:,17) = squeeze(adjmat);
%load('dyngraph-pain/Data/00-Raw data/Subject_18_100307/sbj18_HCP.mat')
%M(:,:,:,:,18) = squeeze(adjmat);
%load('dyngraph-pain/Data/00-Raw data/Subject_19_100307/sbj19_HCP.mat')
%M(:,:,:,:,19) = squeeze(adjmat);
%load('dyngraph-pain/Data/00-Raw data/Subject_20_100307/sbj20_HCP.mat')
%M(:,:,:,:,20) = squeeze(adjmat);
%load('dyngraph-pain/Data/00-Raw data/Subject_21_100307/sbj21_HCP.mat')
%M(:,:,:,:,21) = squeeze(adjmat);
%load('dyngraph-pain/Data/00-Raw data/Subject_22_100307/sbj22_HCP.mat')
%M(:,:,:,:,22) = squeeze(adjmat);
%load('dyngraph-pain/Data/00-Raw data/Subject_23_100307/sbj23_HCP.mat')
%M(:,:,:,:,23) = squeeze(adjmat);
%load('dyngraph-pain/Data/00-Raw data/Subject_24_100307/sbj24_HCP.mat')
%M(:,:,:,:,24) = squeeze(adjmat);
load('dyngraph-pain/Data/00-Raw data/Subject_25_146129/sbj25_HCP.mat')
M(:,:,:,:,16) = squeeze(adjmat);
load('dyngraph-pain/Data/00-Raw data/Subject_26_109123/sbj26_HCP.mat')
M(:,:,:,:,17) = squeeze(adjmat);
load('dyngraph-pain/Data/00-Raw data/Subject_27_111514/sbj27_HCP.mat')
M(:,:,:,:,18) = squeeze(adjmat);
load('dyngraph-pain/Data/00-Raw data/Subject_28_112920/sbj28_HCP.mat')
M(:,:,:,:,19) = squeeze(adjmat);
load('dyngraph-pain/Data/00-Raw data/Subject_29_113922/sbj29_HCP.mat')
M(:,:,:,:,20) = squeeze(adjmat);
load('dyngraph-pain/Data/00-Raw data/Subject_30_158136/sbj30_HCP.mat')
M(:,:,:,:,21) = squeeze(adjmat);
load('dyngraph-pain/Data/00-Raw data/Subject_31_166438/sbj31_HCP.mat')
M(:,:,:,:,22) = squeeze(adjmat);
load('dyngraph-pain/Data/00-Raw data/Subject_32_175540/sbj32_HCP.mat')
M(:,:,:,:,23) = squeeze(adjmat);
load('dyngraph-pain/Data/00-Raw data/Subject_33_182840/sbj33_HCP.mat')
M(:,:,:,:,24) = squeeze(adjmat);
load('dyngraph-pain/Data/00-Raw data/Subject_34_205119/sbj34_HCP.mat')
M(:,:,:,:,25) = squeeze(adjmat);
load('dyngraph-pain/Data/00-Raw data/Subject_35_223929/sbj35_HCP.mat')
M(:,:,:,:,26) = squeeze(adjmat);
load('dyngraph-pain/Data/00-Raw data/Subject_36_233326/sbj36_HCP.mat')
M(:,:,:,:,27) = squeeze(adjmat);
load('dyngraph-pain/Data/00-Raw data/Subject_37_352738/sbj37_HCP.mat')
M(:,:,:,:,28) = squeeze(adjmat);
load('dyngraph-pain/Data/00-Raw data/Subject_38_116524/sbj38_HCP.mat')
M(:,:,:,:,29) = squeeze(adjmat);
load('dyngraph-pain/Data/00-Raw data/Subject_39_116726/sbj39_HCP.mat')
M(:,:,:,:,30) = squeeze(adjmat);

