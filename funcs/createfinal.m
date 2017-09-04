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

function Ifinal = createfinal(I, c, PixelRegionList,...
    colors, BIG, f, new_erasezeroList, ...
    SpecialzeroList, colorsgray)

Ifinal = zeros(size(I));
I1D = zeros(size(I, 1), size(I, 2));

for k = 1 : numel(PixelRegionList)
    
    which = c(k);
    ps = PixelRegionList{k};
    xs = ps(:, 2);
    ys = ps(:, 1);
    
    if size(I, 3) > 1
        for l = 1 : length(xs)
            Ifinal(xs(l), ys(l), :) = colors(which, :);
            I1D(xs(l), ys(l)) = which;
        end;
    else
        for l = 1 : length(xs)
            Ifinal(xs(l), ys(l)) = colorsgray(which);
            I1D(xs(l), ys(l)) = which;
        end;
    end;
end;

tmp = I1D(BIG);
[xCoordofzeros, yCoordofzeros]=...
    ind2sub(size(f), new_erasezeroList);

for i = 1 : size(tmp,1)
    
    removezeros = tmp(i, :);
    removezeros(removezeros==0) = [];
    
    if length(removezeros) > 1
        
        unv = unique(removezeros);
        a = [unv ; histc(removezeros, unv)];
        [~, indx] = max(a(2, :));
        
        if a(1, indx) > 0 && size(Ifinal,3) > 1
            
            Ifinal(xCoordofzeros(i), ...
                yCoordofzeros(i), :) = colors(a(1, indx), :);
            
        elseif a(1, indx) > 0 && size(Ifinal, 3) == 1
            
            Ifinal(xCoordofzeros(i), ...
                yCoordofzeros(i), :) = colorsgray(a(1, indx));
            
        end;
        
    end;
    
end;

[xCoordofzeros, yCoordofzeros]=...
    ind2sub(size(f), SpecialzeroList);

team1 = find(xCoordofzeros == size(f, 1));
team2 = find(yCoordofzeros == size(f, 2));
team3 = find(xCoordofzeros == 1);
team4 = find(yCoordofzeros == 1);

for i = 1 : length(team1)
    
    Ifinal(xCoordofzeros(team1(i)), yCoordofzeros(team1(i)), :) = ...
        Ifinal(xCoordofzeros(team1(i)) - 1, yCoordofzeros(team1(i)), :);
    
end;

for i = 1 : length(team2)
    
    Ifinal(xCoordofzeros(team2(i)), yCoordofzeros(team2(i)), :)=...
        Ifinal(xCoordofzeros(team2(i)), yCoordofzeros(team2(i)) - 1, :);
    
end;

for i = 1 : length(team3)
    
    Ifinal(xCoordofzeros(team3(i)), yCoordofzeros(team3(i)), :) = ...
        Ifinal(xCoordofzeros(team3(i)) + 1, yCoordofzeros(team3(i)), :);
    
end;

for i = 1 : length(team4)
    
    Ifinal(xCoordofzeros(team4(i)), yCoordofzeros(team4(i)), :) = ...
        Ifinal(xCoordofzeros(team4(i)), yCoordofzeros(team4(i)) + 1, :);
    
end;

end

