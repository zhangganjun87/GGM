function img = simplex_noise(n)
% n: 噪声图像大小
cellsize = 8;  % 网格大小，不同的大小会产生不同尺度的噪声
old_n = n;

% 确保尺寸是cellsize的整数倍
if mod(n,cellsize) ~= 0
    n = ceil(n/cellsize) * cellsize;
end

% 初始化每个网格顶点的随机梯度
G = (rand(2,n/cellsize+2,n/cellsize+2)-0.5)*2; % 每个网格顶点的随机方向向量
img = zeros(n);

% 循环生成噪声
for i=1:n
    for j=1:n

        indi = i/cellsize + 1;        
        indj = j/cellsize + 1;
        
        floori = floor(indi);
        floorj = floor(indj);
        
        % 计算当前点到Simplex三角形的距离
        d00 = [indi indj] - [floori floorj];        % 当前点到格点[0,0]的偏移
        d10 = [indi indj] - [floori+1 floorj];      % 当前点到格点[1,0]的偏移
        d01 = [indi indj] - [floori floorj+1];      % 当前点到格点[0,1]的偏移
        d11 = [indi indj] - [floori+1 floorj+1];    % 当前点到格点[1,1]的偏移

        % 梯度点与点偏移的点积（对应权重）
        s = sum(G(:,floori,floorj).*d00');          % 当前点对应网格的梯度贡献
        t = sum(G(:,floori+1,floorj).*d10');
        u = sum(G(:,floori,floorj+1).*d01');
        v = sum(G(:,floori+1,floorj+1).*d11');
        
        % 计算x和y的差值，用于平滑插值
        dx = indi - floori;
        dy = indj - floorj;

        % 平滑插值函数（符合二阶连续性）
        sy = 6*dy.^5 - 15*dy.^4 + 10*dy.^3;   
        sx = 6*dx.^5 - 15*dx.^4 + 10*dx.^3;

        % 插值计算
        a = s + (t-s)*sx;
        b = u + (v-u)*sx;

        % 最终噪声值
        img(i,j) = a + (b-a)*sy;
    end
end

% 调整输出大小为初始设定大小
if old_n ~= n
    img = img(1:old_n, 1:old_n);
end

% 归一化
img = (img - min(img(:))) / (max(img(:)) - min(img(:)));
% imshow(img,[]); % 可视化噪声图像
end