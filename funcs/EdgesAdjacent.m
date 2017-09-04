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

function [allcol,snew,points,intens,e,BIG,new_erasezeroList,SpecialzeroList] = EdgesAdjacent(f,I,option2,imgS,orientations)
%EDGES_ADJACENT Summary of this function goes here
%   Detailed explanation goes here

a=histc(f(:),unique(f));
[~,newindexes]=sort(f(:));
newList=mat2cell(newindexes,a',1);
% 
% if size(I,3)>1
%     IHSI=colorspace('RGB->HSI',I);
%     H=IHSI(:,:,1);
%     S=IHSI(:,:,2);
% end;

if option2==1
    
    I=colorspace('RGB->Lab',I);
    I=I+abs(min(min(min(I))));
    
end;

if option2==2
    
    I=colorspace('RGB->Luv',I);
    I=I+abs(min(min(min(I))));
    
end;

if size(I,3)>1
    
    gr1=I(:,:,1);
    gr2=I(:,:,2);
    gr3=I(:,:,3);
    
    [k,l]=cellfun(@(x) ind2sub(size(f),x),...
        newList,'UniformOutput',false);
    snew=mat2cell(cell2mat([l k]),a',2);
    NL=newList(2:end); 
    
    points=cell2mat(cellfun(@(x) mean(x),...
        [l k],'UniformOutput',false));
    
    points(1,:)=[];
  
    intens1=cell2mat(cellfun(@(x) mean(gr1(x)),...
        NL,'UniformOutput',false));
    intens2=cell2mat(cellfun(@(x) mean(gr2(x)),...
        NL,'UniformOutput',false));
    intens3=cell2mat(cellfun(@(x) mean(gr3(x)),...
        NL,'UniformOutput',false));
    
%     e1=cell2mat(cellfun(@(x) median(gr1(x)),...
%         NL,'UniformOutput',false));
%     e2=cell2mat(cellfun(@(x) median(gr2(x)),...
%         NL,'UniformOutput',false));
%     e3=cell2mat(cellfun(@(x) median(gr3(x)),...
%         NL,'UniformOutput',false));
%     
%     v1=e1.^2;
%     
%     v2=e2.^2;
%     
%     v3=e3.^2;

    intens=[intens1 intens2 intens3];
    if option2==1
        intens=[intens2 intens3];
    end;
    
    if ~isempty(imgS)
        
        t=cell2mat(cellfun(@(x) mean(imgS(x)),...
        NL,'UniformOutput',false));
    
    end;
    
%     h=cell2mat(cellfun(@(x) mean(H(x)),...
%         NL,'UniformOutput',false));
%     
%     s=cell2mat(cellfun(@(x) mean(S(x)),...
%         NL,'UniformOutput',false));
    
%     t=[];

%     e=[e1 e2 e3];

%     e=t;
    
%     e=[h s];
    
    e=[];

else
       
    [k,l]=cellfun(@(x) ind2sub(size(f),x),...
        newList,'UniformOutput',false);
    snew=mat2cell(cell2mat([l k]),a',2);
    NL=newList(2:end); 
       
    if ~isempty(imgS)
        
%         c=sum(imgS,3);
        for i=1:size(imgS,3)
            c=imgS(:,:,i);
            t(:,i)=cell2mat(cellfun(@(x) mean(c(x)),...
                NL,'UniformOutput',false));
        end;
        
        e=t;
        
    else e=[];
        
    end;
    
    
    [k,l]=cellfun(@(x) ind2sub(size(f),x),...
        newList,'UniformOutput',false);
    
    points=cell2mat(cellfun(@(x) mean(x),...
        [l k],'UniformOutput',false));
    
    points(1,:)=[];
    r=regionprops(f,I,'MeanIntensity');
    intens=[r.MeanIntensity]';

end;

erasezeroList=newList(1);
grammes=size(f,1);
erasezeroList=erasezeroList{:};
[erasezeroListgr,erasezeroListst]=ind2sub(size(f),erasezeroList);

t1=and(erasezeroListgr>1,...
    erasezeroListgr<size(f,1));
t2=and(erasezeroListst>1,...
    erasezeroListst<size(f,2));
new_erasezeroList=erasezeroList(and(t1,t2));

SpecialzeroList=setdiff(erasezeroList,new_erasezeroList);

% tic
BIG=[new_erasezeroList-grammes-1 new_erasezeroList-1 ...
    new_erasezeroList+grammes-1 new_erasezeroList-grammes...
    new_erasezeroList+grammes new_erasezeroList-grammes+1 ...
    new_erasezeroList+1 new_erasezeroList+grammes+1];

allcol=[f(BIG(:,1)) f(BIG(:,5));...
        f(BIG(:,1)) f(BIG(:,7));...
        f(BIG(:,1)) f(BIG(:,8));...
        f(BIG(:,2)) f(BIG(:,6));...
        f(BIG(:,2)) f(BIG(:,7));...
        f(BIG(:,2)) f(BIG(:,8));...
        f(BIG(:,3)) f(BIG(:,4));...
        f(BIG(:,3)) f(BIG(:,7));...
        f(BIG(:,3)) f(BIG(:,6));...
        f(BIG(:,4)) f(BIG(:,8));...
        f(BIG(:,4)) f(BIG(:,5));...
        f(BIG(:,5)) f(BIG(:,6))];
  
allcol(allcol(:,1)==0,:)=[];
allcol(allcol(:,2)==0,:)=[];
allcol(allcol(:,1)==allcol(:,2),:)=[];
W=adjacency(allcol);
allcol=adjtoedges(W);
allcol(allcol(:,1)==allcol(:,2),:)=[];
% toc

% Coords=[k l];

end

