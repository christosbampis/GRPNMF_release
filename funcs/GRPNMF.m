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

function labels_all = ...
    GRPNMF(H0, X, iter_grpnmf, lambda, D, W, store_inds)

H = H0;
u = 0;
labels_all = [];

while u <= iter_grpnmf
    
    u = u + 1;
    H = grpnmf_mur(X, H, lambda, D, W);
    
    [~, c] = max(H, [], 2);
    
    if ~isempty(intersect(u, store_inds))
        labels_all = [labels_all ; c'];
    end;

    u
    
end;

end

