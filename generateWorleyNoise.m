function worley_noise = generateWorleyNoise(width, height, num_points)

    % Step 1: 随机生成种子点
    points = rand(num_points, 2) .* [width, height];

    % Step 2: 初始化噪声矩阵
    worley_noise = zeros(height, width);

    % Step 3: 对每个像素，计算与最近种子点的距离
    for y = 1:height
        for x = 1:width
            min_dist = inf;  % 设置初始最小距离为无穷大
            
            % 计算像素(x, y)与所有种子点的欧几里得距离
            for i = 1:num_points
                dist = sqrt((x - points(i, 1))^2 + (y - points(i, 2))^2);
                if dist < min_dist
                    min_dist = dist;
                end
            end
            
            % 记录最小距离作为噪声值
            worley_noise(y, x) = min_dist;
        end
    end

    % Step 4: 将噪声归一化到[0, 1]范围
    worley_noise = worley_noise - min(worley_noise(:));
    worley_noise = worley_noise / max(worley_noise(:));

    % Step 5: 显示结果
    imagesc(worley_noise);
    colormap(gray);
    axis off;
    axis equal;
end