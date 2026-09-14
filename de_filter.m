function sum=de_filter(f)


load('direction.mat');
load('direction0.mat');
    g1=imfilter(f,(direction(:,:,1)),'same');
    g1=imfilter(g1,(direction(:,:,1)),'same');
    g1=imadjust(g1,[],[0,1]);
    
    g2=imfilter(f,(direction(:,:,2)),'same');
    g2=imfilter(g2,(direction(:,:,2)),'same');
    g2=imadjust(g2,[],[0,1]);
    
    g3=imfilter(f,(direction(:,:,3)),'same');
    g3=imfilter(g3,(direction(:,:,3)),'same');
    g3=imadjust(g3,[],[0,1]);
    
    g4=imfilter(f,(direction(:,:,4)),'same');
    g4=imfilter(g4,(direction(:,:,4)),'same');
    g4=imadjust(g4,[],[0,1]);
    
    g5=imfilter(f,(direction(:,:,5)),'same');
    g5=imfilter(g5,(direction(:,:,5)),'same');
    g5=imadjust(g5,[],[0,1]);
    
    g6=imfilter(f,(direction(:,:,6)),'same');
   g6=imfilter(g6,(direction(:,:,6)),'same');
    g6=imadjust(g6,[],[0,1]);
    
    g7=imfilter(f,(direction(:,:,7)),'same');
    g7=imfilter(g7,(direction(:,:,7)),'same');
    g7=imadjust(g7,[],[0,1]);
    
    g8=imfilter(f,(direction(:,:,8)),'same');
    g8=imfilter(g8,(direction(:,:,8)),'same');
    g8=imadjust(g8,[],[0,1]);
  sum=(g1+g2+g3+g4+g5+g6+g7+g8)./8;
%   se=strel('disk',1);
%   sum=imerode(sum,se);
sum=imadjust(sum,[0,1],[1,0]);




