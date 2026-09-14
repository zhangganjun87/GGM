function img = perlinNoise_2(n)
% clear all;close all;clc;

% n = 860;        %噪声图像大小

cellsize = 8;  %网格大小，不同的大小会产生不同尺度的噪声
old_n = n;
if mod(n,cellsize) ~= 0
    n = ceil(n/cellsize) * cellsize;
end
G = rand(2,n/cellsize+2,n/cellsize+2)-0.5; %每个网格顶点的随机方向向量

img = zeros(n);
% display(fprintf('img_size: %f', size(img)));
for i=1:n
    for j=1:n

        indi = i/cellsize+1;        
        indj = j/cellsize+1;
        
        floori = floor(indi);
        floorj = floor(indj);
        
        d00 = [indi indj] - [floori floorj];        %计算当前点到当前网格四个角点距离
        d10 = [indi indj] - [floori+1 floorj];
        d01 = [indi indj] - [floori floorj+1];
        d11 = [indi indj] - [floori+1 floorj+1];
        
        s = sum(G(:,floori,floorj).*d00');          %当前网格四个角点方向向量对当前点的方向权重
        t = sum(G(:,floori+1,floorj).*d10');
        u = sum(G(:,floori,floorj+1).*d01');
        v = sum(G(:,floori+1,floorj+1).*d11');
        
        dx = indi - floori;
        dy = indj - floorj;
        
        sy = 6*dy.^5-15*dy.^4+10*dy.^3;   %符合f(0) = 0,f(0.5)=0.5,f(1)=1的方程,满足二阶导数连续
        sx = 6*dx.^5-15*dx.^4+10*dx.^3;   %用于描述网格内的起伏
%         sy = 3*dy.^2-2*dy.^3;   %符合f(0) = 0,f(0.5)=0.5,f(1)=1的方程,满足二阶导数连续
%         sx = 3*dx.^2-2*dx.^3;  %用于描述网格内的起伏
        
        a = s + (t-s)*sx;
        b = u + (v-u)*sx;

        img(i,j) = a + (b-a)*sy;
%         img(i,j) = 0.8*(a + (b-a)*sy) + 0.2;
    end
end
if old_n ~= n
    img = img(1:old_n, 1:old_n);
end
% imshow(img,[]);   %
% imhist(img);
end