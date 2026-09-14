function KL_divergence = computeKLDiv(img1, img2, varargin)

    if nargin < 3
        img_file1 = 'D:\\MatlabTest\\test_one_I\\RBWN_GAUSS_0710\\jingwu35.jpg_tone_LIC.png';
        img_file2 = 'D:\\MatlabTest\\test_one_I\\RBWN_0710\\jingwu35.jpg_tone_LIC.png';
        img1 = imread(img_file1);
        img2 = imread(img_file2);
    end
    
    % 如果图像是RGB图像，将其转换为灰度图像
    if size(img1, 3) == 3
        img1 = rgb2gray(img1);
    end
    if size(img2, 3) == 3
        img2 = rgb2gray(img2);
    end

    % 将图像转换为概率分布
%     img1 = double(img1) / 255;
%     img2 = double(img2) / 255;
    
    % 计算图像的直方图，并将其归一化为概率分布
    
    hist1 = imhist(img1) / numel(img1);
    hist2 = imhist(img2) / numel(img2);

    % 避免对数为零的问题，给直方图添加一个小常数
    epsilon = 1e-10;
    hist1 = hist1 + epsilon;
    hist2 = hist2 + epsilon;

    % 计算KL散度
    KL_divergence = sum(hist1 .* log(hist1 ./ hist2));

    fprintf('The KL divergence between the two images is: %f\n', KL_divergence);
end
