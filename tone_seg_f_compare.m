function g=tone_seg_f_compare(f,work_strok, imgDirname, outputDir)

size_f=size(f);
directory=[cd,'\result\'];
if size_f(1)>size_f(2) 
    d = size_f(2) * 2 - size_f(1);  
    m0=zeros(size_f(1),size_f(1));
    m0(:,1:size_f(2))=f;
%     m0(:,size_f(2):end)=1;
    m0(:,size_f(2):end)=f(:,size_f(2):-1:d );
    w0=size_f(1)/70;
else
    d = size_f(1) * 2 - size_f(2);
    m0=zeros(size_f(2),size_f(2));
    m0(1:size_f(1),:)=f;
%     m0(size_f(1),:)=1;
    m0(size_f(1):end,:)=f(size_f(1):-1: d,:);
    w0=size_f(2)/70;
end
source=double(im2uint8(m0));
src = m0;
w=fspecial('gaussian',[5 5]);
source=imfilter(source,w);
[sx,sy]=size(m0);

m0_replace=m0;
mode = '';


%% 概率白噪声 RBWN
mode = 'RBWN';
k =1;
m0=double(rand(sx,sy) > k*(1-m0));%（概率白噪声）
% %------------------test1:RBWN k=1时的同等乘性噪声----------------

x2 = sqrt(m0_replace .*(1-m0_replace));
m1=normrnd(m0_replace, x2, sx, sy);
m0_replace=m1;

% % x2 = sqrt(m0 .*(1-m0));
% % m1=normrnd(m0, x2, sx, sy);
% % m0=m1;

%% 概率白噪声-1：0 替换为 f(i,j)
% k =0.9;
% m0_=double(rand(sx,sy)>k*(1-m0));%（概率白噪声）
% m0=(1-(1-m0_).*(1-m0));

%% 概率白噪声-2：255 替换为 f(i,j)
% k =0.3;
% m0_=double(rand(sx,sy)>k*(1-m0));%（概率白噪声）
% m0=m0_.*m0;

%% 泊松噪声
% mode = 'Poisson';
% scale = 60;
% options.po_scale = scale;
% x=poissrnd(m0 * scale);
% m0 = x/min(max(x));
% % m0 = x/max(x);

%% 泊松噪声替换公式

% mu_poisson = m0_replace * scale/min(max(x));  % 1 - 
% sigma_poisson = sqrt(m0_replace *scale) / min(max(x));
% m0_replace = normrnd(mu_poisson, sigma_poisson, sx, sy);


%% 乘性噪声
% mode = 'multi';
% mean1 = 0; 
% sig1 = 1.4;
% options.mean = mean1;
% options.sig = sig1;
% m1=m0+normrnd(mean1, sig1, sx, sy).*(1-m0);%乘性噪声（加性形式表示）
% m0=m1;

%% 乘性噪声替换公式

% miu_ = m0_replace + mean1 * (1-m0_replace);
% sigma_ = sqrt(sig1^2 * (1-m0_replace).^2);
% m0_replace = normrnd(miu_, sigma_, sx, sy);

%------------------test2:RBWN+SRC----------------
% miu_ = (2*m0 - m0.^2);  %.*(1-m0)
% sigma_ = sqrt((1-m0).^2 .* m0);
% m1=normrnd(miu_, sigma_, sx, sy);
% m0=m1;

%---------------test3:模拟混合噪声-----------------
% m1_ = m0 + normrnd(0, 1, sx, sy) .* (1-m0);
% miu_ = m1_.*m0 + m0.*(1-m0);
% sigma_ = sqrt((m1_ - miu_).^2 .* m0 + (m0 - miu_).^2 .*(1-m0));
% m0 = normrnd(miu_, sigma_, sx, sy);


%% 混合噪声
% k = 1;
% m0_=double(rand(sx,sy)>k*(1-m0));%（概率白噪声）
% m1=m0+normrnd(0, 0.8, sx, sy).*(1-m0);%乘性噪声（加性形式表示）生成随机正态分布的随机数
% m0=(1-(1-m0_).*(1-m1));%结合噪声模型

%% 混合噪声2
% k = 1.2;
% m0_ = double(rand(sx,sy) > k*(1-m0));%（概率白噪声）
% m0_tmp1 = (1-m0_) .* m0;
% m1 = m0 + normrnd(0.1, 2, sx, sy).*(1-m0);%乘性噪声（加性形式表示）生成随机正态分布的随机数
% m0_tmp2 = m0_ .* m1;%结合噪声模型
% m0 = m0_tmp1 + m0_tmp2;

%% 混合噪声3
%% -----------------------不同分布的对比------------------

% tmp = normrnd(0.1, 0.212, sx, sy);
% % tmp = exprnd(miu, sx, sy);   %指数分布
% % tmp = betarnd(0.1, 0.9, sx, sy);   %beta分布
% % tmp = gamrnd(0.22, 0.45, sx, sy);
% muL = -2.515;     % log空间均值
% sigmaL = 1.0;     % log空间方差开根号
% tmp = lognrnd(muL, sigmaL, sx, sy);
% 
% k = 1;
% a = 1/sqrt(2);
% b = 0.2 - 1/sqrt(2);
% tmp = a * chi2rnd(k, sx, sy) + b;
% % mean1 = 0.1; 
% % sig1 = 1;
% % tmp = normrnd(mean1, sig1, sx, sy);
% k = 1;
% m0_ = double(rand(sx,sy) < k*(1-m0));%（概率白噪声）
% m0_tmp1 = (1-m0_) .* m0;
% m1 = m0 + tmp.*(1-m0);
% m0_tmp2 = m0_ .* m1;%结合噪声模型
% m0 = m0_tmp1 + m0_tmp2;
% 
% 
% % tmp2 = betarnd(0.1, 0.9, sx, sy);
% tmp2 = gamrnd(0.22, 0.45, sx, sy);
% m0_re = double(rand(sx,sy) < k*(1-m0_replace));%（概率白噪声）
% m0_tmp1_re = (1-m0_re) .* m0_replace;
% m1 = m0_replace + tmp2.*(1-m0_replace);
% m0_tmp2_re = m0_re .* m1;%结合噪声模型
% m0_replace = m0_tmp1_re + m0_tmp2_re;


%% 混合噪声3  在用的比对方法
% mode = 'hybrid';
% k = 1;
% 
% mean1 = 0.0; 
% sig1 = 1.2;
% options.mean = mean1;
% options.sig = sig1;
% 
% m0_ = double(rand(sx,sy) < k*(1-m0));%（概率白噪声）
% m0_tmp1 = (1-m0_) .* m0;
% m1 = m0 + normrnd(mean1, sig1, sx, sy).*(1-m0);%乘性噪声（加性形式表示）生成随机正态分布的随机数
% m0_tmp2 = m0_ .* m1;%结合噪声模型
% m0 = m0_tmp1 + m0_tmp2;
% 
% %混合噪声3的替换噪声2   在用的比对方法
% 
% miu_ = m0_replace + mean1 * (1-m0_replace).^2;
% sigma_ = sqrt(mean1^2 * m0_replace .*(1-m0_replace).^3 + sig1^2 * (1-m0_replace).^3);
% m0_replace = normrnd(miu_, sigma_, sx, sy);


%% -----------------Perlin噪声---------------------------
% m0 = im2double(perlinNoise_2(sx)) + 0.4; 
% 
% 
% miu = mean(m0(:));
% sigma = std(m0(:));
% m0_replace = normrnd(miu, sigma, sx, sy);

%% -------------------Worley噪声----------------------------
% m0 = im2double(generateWorleyNoise(sx, sx, 350));
% 
% miu = mean(m0(:));
% sigma = std(m0(:));
% m0_replace = normrnd(miu, sigma, sx, sy);

%% -------------------Simplex噪声----------------------------
% m0 = im2double(simplex_noise(sx));

% [X, Y] = meshgrid(linspace(0, 5, sx), linspace(0, 5, sx));
% m0 = arrayfun(@simplex_noise, X, Y);
% m0 = im2double(m0);

% miu = mean(m0(:));
% sigma = std(m0(:));
% m0_replace = normrnd(miu, sigma, sx, sy);

%% ---------------------------------直方图曲线------------------

        label1 = 'RBWN';   % RBWN  Hybrid noise-degraded image  Multiplicative noise-degraded image  Poisson noise-degraded image
        label2 = 'GGM';   % GGM    U_{R}  Specified Gaussian distribution    generic representation  U_{H}  U_{P}  U_{M}
        l1_font_size = 25;
        gca_font_size = 30;
        title_font_size = 44;
        xlabel_font_size = 30;
        ylabel_font_size = 30;
        %噪声的曲线
%        clf;
       scale_num = 1;    % RBWN:100   50; Others:1
       m0_part = m0(1:size_f(1),1:size_f(2));
       m0_xx = double(int32(m0_part.*255));
       Value = unique(m0_xx(:));
       Count=[hist(m0_xx(:),Value)] / scale_num;  % 
%        bar(Value, Count, 0.01, 'FaceColor', [0 0 1]); % 绘制柱状图   , 'BarWidth', 0.5
%        stem(Value, Count, 'Marker', 'none', 'Color', [0 0 1], 'LineWidth', 3);
       plot(Value,Count, 'Color', [0 0 1], 'LineWidth', 3); %曲线图
       hold on;
       
       m0_part_replace = m0_replace(1:size_f(1),1:size_f(2));
       m0_xx_replace = double(int32(m0_part_replace.*255));
       Value_replace = unique(m0_xx_replace(:));
       Count_replace=[hist(m0_xx_replace(:),Value_replace)];
       plot(Value_replace,Count_replace, 'Color', [1 0 0], 'LineWidth', 3); %曲线图
%        bar(Value_replace, Count_replace, 0.02, 'FaceColor', [1 0 0]); %绘制柱状图

       axis([0, 255,-inf,inf]);
       xticks(0:50:255);  % 设置刻度为0, 50, 100, 150, 200, 250
       xlabel('Pixel Intensity (0-255)', 'FontSize', xlabel_font_size);      % x轴名称
       ylabel('Frequency', 'FontSize', ylabel_font_size);                   % y轴名称
       title('Histogram of Images', 'FontSize', title_font_size); % 添加标题
       l1 = legend({label1,label2},'Location','Best');  %
       set(l1, 'FontSize', l1_font_size);
       set(gca, 'FontSize', gca_font_size);
       hold off;
       
        fig = gcf;
        fig.Units = 'centimeters';         % 或 'inches'
        fig.Position = [2, 2, 12, 10];     % [left bottom width height]
        saveas(fig, fullfile(outputDir, [imgDirname '_noise_hist_line.png']));
       %% --------------------------------------------------------


%%  noise_img1

% directory_re = 'D:/MatlabTest/test_one_B/';
imwrite(m0(1:size_f(1),1:size_f(2)),[outputDir, imgDirname, '_noise_src.png']);
imwrite(m0_replace(1:size_f(1),1:size_f(2)),[outputDir, imgDirname, '_noise_replace.png']);

%% generate a random irrotational vector field
% options.bound = 'per';
options.bound = 'sym';
sigma = 20;
[x,y]=meshgrid(1:sx,1:sy);
t=max(sx,sy);


%% 交叉直线
z=(y)*2.0-(x);    %input_1
% z=x-1.5*y;  %input_2
% z=x-7*y;  %input_7

%交叉弧线
z1=(y+t).^2+(x-2*t).^2*2;
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
     sigma = 3.8;%修改铅笔的宽度    1.8
     M0 = perform_blurring(m0, sigma, options);
     M0_replace = perform_blurring(m0_replace, sigma, options);
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

% for i=1:2
%     options.M0 = M;
%     M = perform_lic(v2, w, options);%v2、v1两个方向
    %options.M0 = M;
%     M = perform_lic(v2, w, options);
% end
% for i=1:2
%     options.M0 = M1;
%     M1 = perform_lic(v1, w, options);
% end

%% -----分割
% h=[1/9,1/9,1/9;1/9,1/9,1/9;1/9,1/9,1/9];
% work_strok=imfilter(f,h,'replicate');
% f=L0Smoothing(work_strok,0.003,2);
% f=imfilter(f,h,'replicate');
w = 35;  %35  长度
I=work_strok;
% [m, n, p] = size(I);
% k = 3;
% [C, label, J] = kmeans(I, k);
% I1 = reshape(C(label, :), m, n, p);
% t_s = im2bw(I1);
% level = graythresh(I1);
% t_s = im2bw(I1, level);
% t_s1=~t_s;
% t_s=threshold_segmentation(f);
% imwrite(t_s(r+1:size_f(1)-r-1,r+1:size_f(2)-r-1),[directory,'t_s.jpg']);
[imx,imy]=size(f);


%% ------------------------perform LIC  src noise------------------------------

tone=M0;
options.M0 = tone;

% tone3 = perform_lic(v2, w, options);  %原lic方法

M_out = perform_lic(v2, w, options);   %新lic方法
tone3 = M_out.M;
    %------------分割交叉线时添加-------------
%     tone4 = perform_lic(v1, w, options);
%     tone3 = (tone3 + tone4) / 2;
    %--------------------------------------
g1=tone3(1:size_f(1),1:size_f(2));

%% ------------------------perform LIC replace noise------------------------------

tone=M0_replace;
options.M0 = tone;
% tone3 = perform_lic(v2, w, options);   %原lic方法

M_out = perform_lic(v2, w, options);   %新lic方法
tone4 = M_out.M;

    %------------分割交叉线时添加-------------
%     tone4 = perform_lic(v1, w, options);
%     tone3 = (tone3 + tone4) / 2;
    %--------------------------------------
g2=tone4(1:size_f(1),1:size_f(2));

%-----------阈值分类---------
%% 分割
% options.M0 = M0;
%  M=1/2*(1.8*M0+0.2*MK1);
options.M0 = M0;


%% -------------------compare--------------------------
figure;
g1_xx = double(int32(g1.*255));
Value_src = unique(g1_xx(:));
Count_src =[hist(g1_xx(:),Value_src)];
plot(Value_src,Count_src, 'Color', [0 0 1], 'LineWidth', 3); %曲线图
hold on;

g2_xx = double(int32(g2.*255));
Value_replace = unique(g2_xx(:));
Count_replace =[hist(g2_xx(:),Value_replace)];
plot(Value_replace,Count_replace, 'Color', [1 0 0], 'LineWidth', 3); %曲线图
%        axis([-300, 400,-inf,inf])
axis([0, 255,-inf,inf]);
xlabel('Pixel Intensity (0-255)', 'FontSize', xlabel_font_size);      % x轴名称
ylabel('Frequency', 'FontSize', ylabel_font_size);                   % y轴名称
title('Histogram of Hatching Results', 'FontSize', title_font_size); % 添加标题
%        l1 = legend({'distribution of LIC image'},'Location','Best'); %'输入灰度图分布','噪声退化图分布',
l1 = legend({label1,label2},'Location','Best');   %multiplicative   'Perlin noise','GGM'   generic representation
set(l1, 'FontSize', l1_font_size);
set(gca, 'FontSize', gca_font_size);
% set(ylabel, 'FontSize', 16);
hold off;

% saveas(gcf,[outputDir,imgDirname ,'_hatching_hist_line.png']);
fig = gcf;
fig.Units = 'centimeters';         % 或 'inches'
fig.Position = [2, 2, 12, 10];     % [left bottom width height]
% saveas(fig, fullfile(outputDir, [imgDirname '_hatching_hist_line.png']));
exportgraphics(fig, fullfile(outputDir, [imgDirname '_hatching_hist_line.png']), ...
     'Resolution',300);


imwrite(g1,[outputDir, imgDirname, '_hatchingResult_src.png']);
imwrite(g2,[outputDir, imgDirname, '_hatchingResult_replace.png']);

% g=MK1(1:size_f(1),1:size_f(2));
g=g1;
% imwrite(g,[directory,'LIC1.jpg']);
% g2=M(1:size_f(1),1:size_f(2));
% g=(g+g2)/2;
% directory=[cd,'\sketch1\results\'];
% imwrite(g,[directory,'LIC.jpg']);
% imwrite(g2,[directory,'LIC2.jpg']);
% figure;imshow(g);




