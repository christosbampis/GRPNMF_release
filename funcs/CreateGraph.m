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

function [f, points, edgesn, intens, nodes, e, newList, BIG, ...
    new_erasezeroList, SpecialzeroList] = ...
    CreateGraph(I, option, type, option2, imgS, orientations)

if size(I, 3) > 1
    Igray = rgb2gray(I);
else
    Igray = I;
end;

if option == 1
    
    f = double(watershed(imgradient(Igray)));
    
    [edgesn, newList, points, intens, e, BIG, new_erasezeroList, ...
        SpecialzeroList] = EdgesAdjacent(f, I, option2, imgS, orientations);
    
    nodes = size(intens, 1);
    
else
    
    [X, Y, Z]=size(I);
    
    if type == 8
        
        [points, edgesn] = lattice(X, Y, 1);
        
    else
        
        [points, edgesn] = lattice(X, Y, 0);
        
    end;
    
    if Z > 1
        tmp = I(:, :, 1);
        intens(:, 1) = tmp(:);
        tmp = I(:, :, 2);
        intens(:, 2) = tmp(:);
        tmp = I(:, :, 3);
        intens(:, 3) = tmp(:);
    else
        intens = Igray(:);
    end
    
    f = [];
    
    nodes = size(intens, 1);
    
    e = [];
     
    newList = [];
    
end;

end

