function [L, D, W]=laplacian(edges,weights,option,N)

%If weights are not specified, use unity weighting
if nargin == 1
    weights = ones(size(edges, 1), 1);
end

%If N is not specified, use maximum values of edges
if nargin < 4
    N = max(max(edges));
end

W = adjacency(edges, weights, N);
D = diag(sum(W));
L = D - W;

if strcmp(option, 'normalized')
    Dsqrt = diag(diag(D) .^ (-0.5));
    L = Dsqrt * L * Dsqrt;
    disp(option)
end;

end
