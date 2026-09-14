function g=tone_seg_f_noSeg(f,work_strok, imgDirname, outputDir)

size_f=size(f);
directory=[cd,'\result\'];
if size_f(1) > size_f(2)
    % 行多列少
    m0 = zeros(size_f(1), size_f(1)); 
    m0(:, 1:size_f(2)) = f;

    % 计算需要填充的列数
    fill_cols = size_f(1) - size_f(2);
    mirror_source = f(:, size_f(2):-1:1); % 镜像整个列
    mirror_repeats = ceil(fill_cols / size_f(2)); % 重复次数
    mirror_full = repmat(mirror_source, 1, mirror_repeats); % 扩展镜像

    % 填充
    m0(:, size_f(2)+1:end) = mirror_full(:, 1:fill_cols);

    w0 = size_f(1)/70;

else
    % 列多行少
    m0 = zeros(size_f(2), size_f(2));
    m0(1:size_f(1), :) = f;

    % 计算需要填充的行数
    fill_rows = size_f(2) - size_f(1);
    mirror_source = f(size_f(1):-1:1, :); % 镜像整个行
    mirror_repeats = ceil(fill_rows / size_f(1)); % 重复次数
    mirror_full = repmat(mirror_source, mirror_repeats, 1); % 扩展镜像

    % 填充
    m0(size_f(1)+1:end, :) = mirror_full(1:fill_rows, :);

    w0 = size_f(2)/70;
end

source=double(im2uint8(m0));
src = m0;
% w=fspecial('gaussian',[5 5]);
% source=imfilter(source,w);
[sx,sy]=size(m0);

m0_replace=m0;
mode = '';


%% 1.概率白噪声 RBWN
% mode = 'RBWN';
% k =1;
% m0=double(rand(sx,sy)>k*(1-m0));%（概率白噪声）
% %------------------test1:RBWN k=1时的同等乘性噪声----------------
% x2 = sqrt(m0_replace .*(1-m0_replace));
% sigma_clt = x2;
% mu_clt = m0_replace;
% m1=normrnd(mu_clt, sigma_clt, sx, sy);
% m0_replace=m1;


%% 2.泊松噪声
% mode = 'Poisson';
% scale = 60;
% options.po_scale = scale;
% 
% x=poissrnd(m0 * scale);
% 
% scale_2 = min(max(x));
% options.po_scale_2 = scale_2;
% 
% m0 = x/scale_2;
% 
% % 泊松噪声替换公式
% 
% mu_clt = m0_replace * scale/scale_2;  % 1 - 
% sigma_clt = sqrt(m0_replace *scale) / scale_2;
% m0_replace = normrnd(mu_clt, sigma_clt, sx, sy);



%% 3.乘性噪声

mode = 'multi';
mean1 = -0.1; 
sig1 = 1.6;
options.mean = mean1;
options.sig = sig1;
miu_ = m0 + mean1 * (1 - m0);
sigma_ = sqrt(sig1^2 * (1-m0).^2);
m0 = normrnd(miu_, sigma_, sx, sy);
%% 乘性噪声替换公式
mu_clt = m0_replace + mean1 * (1-m0_replace);
sigma_clt = sqrt(sig1^2 * (1-m0_replace).^2);
m0_replace = normrnd(miu_, sigma_, sx, sy);



%% 4.混合噪声
% mode = 'hybrid';
% k = 1;
% mean1 = 0.0; 
% sig1 = 1.3;
% options.mean = mean1;
% options.sig = sig1;
% 
% m0_ = double(rand(sx,sy) < k*(1-m0));%（概率白噪声）
% m0_tmp1 = (1-m0_) .* m0;
% m1 = m0 + normrnd(mean1, sig1, sx, sy).*(1-m0);%乘性噪声（加性形式表示）生成随机正态分布的随机数
% m0_tmp2 = m0_ .* m1;%结合噪声模型
% m0 = m0_tmp1 + m0_tmp2;

%混合噪声的替换噪声（在用）
% mu_clt = m0_replace + mean1 * (1-m0_replace).^2;
% sigma_clt = sqrt(mean1^2 * m0_replace .*(1-m0_replace).^3 + sig1^2 * (1-m0_replace).^3);
% m0_replace = normrnd(mu_clt, sigma_clt, sx, sy);

%% 5.GGM
% mean1 = 0;     %  0.7    0.4
% sig1 = 0.1;    %  1.4
% miu_ = m0 + mean1 * m0;
% sigma_ = sqrt(sig1^2 * (1-m0).^2);
% m0 = normrnd(miu_, sigma_, sx, sy);


%% 混合噪声:不同分布的对比
% mode = 'hybrid';
% mu = 0.2;
% sigma = 1.0;  % 方差=1
% options.mean = mu;
% options.sig = sigma;

% tmp = normrnd(mu, sigma, sx, sy);

% % tmp = normrnd(0.5, 2, sx, sy);
% tmp = exprnd(0.5, sx, sy);   %指数分布
% tmp = betarnd(0.1, 0.9, sx, sy);   %beta分布
% tmp = gamrnd(0.22, 0.45, sx, sy);

% sigmaL = sqrt(log((sigma^2)/(mu^2) + 1));
% muL    = log(mu) - sigmaL^2/2;
% % tmp = lognrnd(muL, sigmaL, sx, sy);  %mean=0.2, std = 1
% 
% k = 1;
% a = 1/sqrt(2);
% b = 0.2 - 1/sqrt(2);
% tmp = a * chi2rnd(k, sx, sy) + b;
% 
% xx = tmp(:);
% mean(xx)
% std(xx)
% 
% k = 1;
% m0_ = double(rand(sx,sy) < k*(1-m0));%（概率白噪声）
% m0_tmp1 = (1-m0_) .* m0;
% m1 = m0 + tmp.*(1-m0);
% m0_tmp2 = m0_ .* m1;%结合噪声模型
% m0 = m0_tmp1 + m0_tmp2;

%---------------------------------------------------
%-----------------------不同分布的对比 第二套参数---------------
% tmp = normrnd(0.5, 0.469, sx, sy);
% tmp = exprnd(miu, sx, sy);   %指数分布
% tmp = betarnd(0.6818, 0.6818, sx, sy);   %beta分布
% tmp = gamrnd(1.13636, 2.2727, sx, sy);
%---------------------------------------------------


%-----------------------不同分布的对比-----------------
% tmp = normrnd(0.1, 0.212, sx, sy);
% tmp = exprnd(miu, sx, sy);   %指数分布
% tmp = betarnd(0.1, 0.9, sx, sy);   %beta分布
% tmp = gamrnd(0.22, 0.45, sx, sy);
%---------------------------------------------------


%% ---------------------------------直方图曲线------------------
% figure;
        %噪声的曲线
%        clf;
%         m0_part = m0(1:size_f(1),1:size_f(2));
%         m0_xx = double(int32(m0_part.*255));
%         m0_xx(m0_xx < 0) = 0;                  % 将小于0的值变为0
%         m0_xx(m0_xx > 255) = 255;              % 将大于255的值变为255
%         Value = unique(m0_xx(:));
%         Count=[hist(m0_xx(:),Value)];
%         plot(Value,Count, 'Color', [0 0 1], 'LineWidth', 3); %曲线图
%         hold on;

%         g1_xx = double(int32(tone(1:size_f(1),1:size_f(2)).*255));   %画Hatching result 曲线
%         Value_src = unique(g1_xx(:));
%         Count_src =[hist(g1_xx(:),Value_src)];
%         plot(Value_src,Count_src, 'Color', [0.1 0.8 0.1], 'LineWidth', 3); %曲线图
%         hold on;
        %----------------------画原图----------------------
%         Value_s = unique(source(:));
%         Count_s=[hist(source(:),Value_s)];
%         plot(Value_s,Count_s, 'Color', [0 1 1], 'LineWidth', 3); %曲线图
        %-------------------------------------------------
%         axis([0, 255,-inf,inf]);
%         xlabel('Pixel Intensity (0-255)', 'FontSize', 20);      % x轴名称
%         ylabel('Frequency', 'FontSize', 20);                   % y轴名称
%         title('Histogram of Images', 'FontSize', 34); % 添加标题    Histogram of NoiseGamma
%         hold off;
       
%         l1 = legend({'hatching result of Perlin noise','hatching result of GGM'},'Location','Best');
%         set(l1, 'FontSize', 14);
%         hold off;
%         saveas(gcf,[outputDir,imgDirname ,'_hatching_hist_line.png']);
%         imwrite(g1,[outputDir, imgDirname, '_hatchingResult_src.png']);
%         imwrite(g2,[outputDir, imgDirname, '_hatchingResult_replace.png']);
        
%        saveas(gcf,[directory_re,imgName ,'_noise_hist_line.png']);
       %% --------------------------------------------------------

%%  noise_img1

% directory_re = 'D:/MatlabTest/test_one_B/';
imwrite(m0(1:size_f(1),1:size_f(2)),[outputDir, imgDirname, '_noise.png']);

%% generate a random irrotational vector field
% options.bound = 'per';
options.bound = 'sym';
sigma = 20;
[x,y]=meshgrid(1:sx,1:sy);
t=max(sx,sy);


%% 交叉直线
z=(y)*2.0-(x); 
z1=-x+1.5*y;


%交叉弧线
% z=(y+t).^2+(x-2*t).^2*2;
% z1=(x+2*t).^2+(y-t).^2*5;

% z1=(x+t).^2+(y-2*t).^2*5;

v=zeros(sy,sx,2);
v1=zeros(sy,sx,2);
v2=zeros(sy,sx,2);
v3=zeros(sy,sx,2);

[v(:,:,1),v(:,:,2)]=gradient(z);
[v1(:,:,1),v1(:,:,2)]=gradient(z1);

v2(:,:,1)=(v(:,:,2)-1)./v(:,:,1);
v2(:,:,2)=-1;
v3(:,:,1)=(v1(:,:,2)-1)./v1(:,:,1);
v3(:,:,2)=-1;

v2 = perform_blurring(v2, sigma, options);
v2 = perform_vf_normalization(v2);

v1 = perform_blurring(v1, sigma, options);
v1 = perform_vf_normalization(v1);
v3 = perform_blurring(v3, sigma, options);
v3 = perform_vf_normalization(v3);

% options.histogram = 'gaussian';
options.histogram = 'linear';
options.verb = 1;
% size of the features
options.spot_size = 1.3;

%% original image

name = 'rand';
options.dt = 0.5;
w_list = [4 6 8 10 12 14];
if strcmp(name, 'rand')
     sigma = 3.8;%修改铅笔的宽度
     M0 = perform_blurring(m0, sigma, options);
%      figure;imshow(M0(1:size_f(1),1:size_f(2));
%    M0=m0;
    %M0 = perform_histogram_equalization(M0, options.histogram);
else
    options.dt = 1.0;
    w_list = w_list * 2;
    options.histogram = [];
    M0 = load_image(name,n);
    M0 = rescale( crop(M0,n) );
end

%% New options parameters for Lyapunov CLT test 20251102
options.src = src;
options.noise_mode = mode;

%% iterated lic
w = 180;  %35   长度
options.M0 = M0;

% tone = perform_lic(v2, w, options);  %临时注释

%------------test for CLT 20251102-------------
M_out = perform_lic(v2, w, options);
tone = M_out.M;

Means_sum = M_out.Means;
Sn = sqrt(M_out.Sig_sq_sum);
M_sum = M_out.M_sum;
Norm_result = (M_sum - Means_sum) ./ Sn;  %Lyapunov CLT 验证1  验证通过

Norm_result_v2 = (tone - M_out.Mean) ./ (Sn ./ (w*2));     %  Lyapunov CLT 验证2 验证通过

%----------------------------------------------

%% 尝试看看能否通过公式恢复成高斯分布
figure;
l1_font_size = 25;
gca_font_size = 30;
title_font_size = 44;
xlabel_font_size = 30;
ylabel_font_size = 30;

clt_dis = (w * 2)^0.5 * (tone - mu_clt) ./ (sigma_clt);   % 经验证，这种方式（传统的CLT性质）只对单色图验证可行
g1_clt = double(int32(clt_dis(1:size_f(1),1:size_f(2)).*255));
Value_clt = unique(g1_clt(:)); 

% axis([0, 255,-inf,inf]);
% xlabel('Pixel Intensity (0-255)', 'FontSize', 30);      % x轴名称
% ylabel('Frequency', 'FontSize', 30);                   % y轴名称
% 
% l1 = legend({'noise-degraded image','hatching result'},'Location','Best');
% set(l1, 'FontSize', 25);
% set(gca, 'FontSize', 30);
% title('Histogram of Images', 'FontSize', 40); % 添加标题    Histogram of NoiseGamma
% hold off;

Count_clt = hist(g1_clt(:), Value_clt); 
plot(Value_clt,Count_clt, 'Color', [0.3 0.85 0.4], 'LineWidth', 3);   %传统clt的验证曲线
hold on;

%-------------------------test for lic 20251102-------------------
test_clt = double(int32(Norm_result_v2(1:size_f(1),1:size_f(2)).*255));     % Norm_result

Value_test = unique(test_clt(:)); 
Count_test = hist(test_clt(:), Value_test); 
plot(Value_test,Count_test, 'Color', [0.2 0.2 0.9], 'LineWidth', 2);    % Lyapunov CLT 验证曲线
hold on;

%-----------------------------------------------------------------
% —— 关键：构造标准正态(N(0,1))对应的“理论计数” —— 
g1_tone = double(int32(tone(1:size_f(1),1:size_f(2)).*255));   %test
% Value_tone = unique(g1_tone(:)); 
N = numel(g1_tone);          % 总样本数   g1_clt
binw = 1;                   % 你的 Value_clt 相邻刻度间距=1
z = Value_clt / 255;        % 把横轴从 g1_clt 单位还原到 clt_dis 的连续刻度
pdf_std = normpdf(z, 0, 1); % 标准正态 pdf
theory_counts = N * pdf_std * (binw/255);  % 计数 = N * pdf * Δz，其中 Δz=binw/255
% 叠加参考曲线
plot(Value_clt, theory_counts, 'r-', 'LineWidth', 2);

xlabel('Value', 'FontSize', xlabel_font_size); 
ylabel('Frequency', 'FontSize', ylabel_font_size);
title('Distribution of Results', 'FontSize', title_font_size); % 添加标题
l1 = legend( 'Normalized Classical CLT','Normalized hatching result','Standard normal distribution');
xlim([-800 800]);
grid on;               % （可选）添加网格，方便观察

set(l1, 'FontSize', l1_font_size);
set(gca, 'FontSize', gca_font_size);


hold off;

%% -------------------show LIC hist--------------------------
% figure;
% g1_xx = double(int32(tone(1:size_f(1),1:size_f(2)).*255));
% Value_src = unique(g1_xx(:));
% Count_src =[hist(g1_xx(:),Value_src)];
% plot(Value_src,Count_src, 'Color', [1 0 0], 'LineWidth', 3); %曲线图

% axis([0, 255,-inf,inf]);
% 
% l1 = legend({'GGM','Input image', 'Hatching result'},'Location','Best');   %multiplicative
% set(l1, 'FontSize', 30);
% set(gca, 'FontSize', 30);
% 
% hold off;
% saveas(gcf,[outputDir,imgDirname ,'_hatching_hist_line.png']);
% imwrite(tone(1:size_f(1),1:size_f(2)),[outputDir, imgDirname, '_histResult_src.png']);

% imwrite(g2,[outputDir, imgDirname, '_hatchingResult_replace.png']);

g=tone(1:size_f(1),1:size_f(2));
% imwrite(g,[directory,'LIC1.jpg']);
% g2=M(1:size_f(1),1:size_f(2));
% g=(g+g2)/2;
% directory=[cd,'\sketch1\results\'];
% imwrite(g,[directory,'LIC.jpg']);
% imwrite(g2,[directory,'LIC2.jpg']);
% figure;imshow(g);




