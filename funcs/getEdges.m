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

function [edges, PixelRegionList2ind, PixelRegionList1ind, ...
    points, new_erasezeroList, ...
    SpecialzeroList, BIG] = getEdges(f)

% creates edges from an oversegmentation map

a = histc(f(:), unique(f));
[~, newindexes] = sort(f(:));
newList = mat2cell(newindexes, a', 1);

[k, l] = cellfun(@(x) ind2sub(size(f), x),...
        newList, 'UniformOutput', false);
    
snew = mat2cell(cell2mat([l k]), a', 2);
    
points = cell2mat(cellfun(@(x) mean(x), ...
    [l k], 'UniformOutput', false));
points(1, :)=[];

erasezeroList = newList(1);
grammes = size(f, 1);
erasezeroList = erasezeroList{:};
[erasezeroListgr, erasezeroListst] = ind2sub(size(f), erasezeroList);

t1 = and(erasezeroListgr > 1, ...
    erasezeroListgr < size(f, 1));
t2 = and(erasezeroListst > 1, ...
    erasezeroListst < size(f, 2));
new_erasezeroList = erasezeroList(and(t1, t2));

BIG = [new_erasezeroList-grammes-1 new_erasezeroList-1 ...
    new_erasezeroList+grammes-1 new_erasezeroList-grammes...
    new_erasezeroList+grammes new_erasezeroList-grammes+1 ...
    new_erasezeroList+1 new_erasezeroList+grammes+1];

edges = [f(BIG(:, 1)) f(BIG(:, 5)); ...
        f(BIG(:, 1)) f(BIG(:, 7)); ...
        f(BIG(:, 1)) f(BIG(:, 8)); ...
        f(BIG(:, 2)) f(BIG(:, 6)); ...
        f(BIG(:, 2)) f(BIG(:, 7)); ...
        f(BIG(:, 2)) f(BIG(:, 8)); ...
        f(BIG(:, 3)) f(BIG(:, 4)); ...
        f(BIG(:, 3)) f(BIG(:, 7)); ...
        f(BIG(:, 3)) f(BIG(:, 6)); ...
        f(BIG(:, 4)) f(BIG(:, 8)); ...
        f(BIG(:, 4)) f(BIG(:, 5)); ...
        f(BIG(:, 5)) f(BIG(:, 6))];
  
edges(edges(:, 1) == 0, :) = [];
edges(edges(:, 2) == 0, :) = [];
edges(edges(:, 1) == edges(:,2), :) = [];
W = adjacency(edges);
edges = adjtoedges(W);
edges(edges(:, 1) == edges(:, 2), :) = [];
[~, edges2] = RegionAdjacencyGraph(f, 1);
edges = union(edges, edges2, 'rows');
PixelRegionList2ind= snew(2 : end);
PixelRegionList1ind = newList(2 : end);
SpecialzeroList = setdiff(erasezeroList, new_erasezeroList);

end

