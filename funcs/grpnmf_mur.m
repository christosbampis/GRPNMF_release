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

function H = grpnmf_mur(X, H, lambda, D, W)

h1 = X' * H;
h2 = H' * H;
h3 = h1' * h1;
h4 = h1 * h2;

if lambda == 0
    
    A = 2 * X * h1;
    B = H * h3 + X * h4;
    
else
    
    A = 2 * X * h1 + lambda * W * H;
    B = H * h3 + X * h4 + lambda * D * H;
    
end;

%%% slower convergence
% H = H .* sqrt(sqrt(A ./ (B + 10^(-9))));

%%% converges faster but may be unstable in some cases
H = H .* A ./ (B + 10^(-9));

end

