% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%
% Author: Christos Bampis
% This code implements various methods described in:
% 
% C. G. Bampis, P. Maragos and A. C. Bovik, "Projective non-negative
% matrix factorization for unsupervised graph clustering," 2016 IEEE
% International Conference on Image Processing (ICIP), Phoenix, AZ, USA, 2016, 
% 
% If you use this code, please consider citing this work.
% 
% v1: Dec. 2016
% For any questions/comments: cbampis@gmail.com or bampis@utexas.edu
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

clear
close all
clc

addpath(genpath('texture_images'));
addpath(genpath('colorspace'));
addpath(genpath([pwd '/other_funcs']));
addpath(genpath('funcs'));
addpath(genpath('GraphAnalysisToolbox'));

%%% pick texture image example
img_ind = 4;

%%% number of segments (different for each demo texture image)
classes_texture = [2 5 2 2 4];
classes = classes_texture(img_ind);

%%% number of iterations
iter_grpnmf = 500;

store_inds = floor(linspace(1, iter_grpnmf - 1, 6));

%%% regularization parameter
lambda_grpnmf = 10;

%%% input image
I = im2double(imread(['t' num2str(img_ind) '.gif']));
I = I(:,:,1);

%%% Gabor setup
scales = 5;
orientations = 8;
siz1 = 39;
siz2 = siz1;
gaborArray = gaborFilterBank(scales, ...
    orientations, siz1, siz2);

%%% Gabor features
featureVector = gaborFeatures(I, gaborArray, 1, 1);

%%% rescale to positive values
MN = min(featureVector);
if MN < 0
    featureVector = featureVector + abs(MN);
end;

fvs = reshape(featureVector,size(I, 1), ...
    size(I,2), scales*orientations);

%%% 1 for RAG, 0 for regular grid
option = 1; 

%%% 0 for RGB, 1 for Luv
option2 = 0;

%%% 8-pixel neighborhood
type = 8;

%%% needed for display
colors = [1 0 0 ; 0 0 1 ; 0 1 0  ; 1 1 0 ; 0 0 0];
colorsgray = linspace(0, 1, classes);

%%% graph setup
[f, ~, ~, intens, nodes, e, newList] = CreateGraph(I, ...
    option, type, option2, fvs, orientations);

[edges, PixelRegionList2ind, PixelRegionList1ind, ... 
    points, new_erasezeroList, ...
    SpecialzeroList, BIG] = ...
    getEdges(f);

%%% texture features
X = e;

%%% rbf kernel weights
beta = 10;
weights = makeweights(edges, intens, beta);

%%% simpler weights
% weights = ones(size(edges,1),1);

%%% setup graph Laplacian
LaplacianVersion = 'unnormalized';
[L, D, W] = laplacian(edges, weights, LaplacianVersion);

X = normalize(X);
n = size(X, 1);

%%% random init to non-negative values
H = rand(n, classes);

%%% apply GRPNMF on texture image
tic
labels_all = GRPNMF(H, X, iter_grpnmf, ...
    lambda_grpnmf, D, W, store_inds);
time_took = toc;
disp(['GRPNMF took: ' num2str(time_took)])

%%% display results
figure

for plot_ind = 1 : 6
    
    subplot(2, 3, plot_ind)
    imshow(I), hold on
    for t = 1 : classes
        scatter(points(labels_all(plot_ind, :) == t, 1), ...
            points(labels_all(plot_ind, :) == t, 2), 10, ...
            'fill', 'MarkerFaceColor', colors(t, :))
    end;
    title(['Iteration #: ' num2str(store_inds(plot_ind))])
    
end;


Ifinal = createfinal(I, labels_all(plot_ind, :), PixelRegionList2ind,...
    colors, BIG, f, new_erasezeroList,...
    SpecialzeroList, colorsgray);

figure, imshow(Ifinal)
title('Pixel-based Result')