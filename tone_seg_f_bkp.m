function g=tone_seg_f_bkp(f,work_strok, imgDirname, outputDir)

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

% m0_replace=m0;
m0_replace=m0;
mode = '';


%% 概率白噪声 RBWN
% k =1;
% m0=double(rand(sx,sy)>k*(1-m0));%（概率白噪声）
%------------------test1:RBWN k=1时的同等乘性噪声----------------

% x2 = sqrt(m0_replace .*(1-m0_replace));
% m1=normrnd(m0_replace, x2, sx, sy);
% m0_replace=m1;

% x2 = sqrt(m0 .*(1-m0));
% m1=normrnd(m0, x2, sx, sy);
% m0=m1;

%% 概率白噪声-1：0 替换为 f(i,j)
% k =0.9;
% m0_=double(rand(sx,sy)>k*(1-m0));%（概率白噪声）
% m0=(1-(1-m0_).*(1-m0));

%% 概率白噪声-2：255 替换为 f(i,j)
% k =0.3;
% m0_=double(rand(sx,sy)>k*(1-m0));%（概率白噪声）
% m0=m0_.*m0;

%% 泊松噪声
%  x=poissrnd((1-m0)*4);
% m0=1-x/max(max(x));
% m0=poissrnd(m0);

% 泊松噪声替换公式
% mu_poisson = m0;
% sigma_poisson = m0;   %这个目前可能不准，有待确认
% m0 = normrnd(mu_poisson, sigma_poisson, sx, sy);



%% 乘性噪声
% m1=m0+normrnd(0.2, 0.76, sx, sy).*(1-m0);%乘性噪声（加性形式表示）
% m0=m1;

%% 乘性噪声替换公式
mode = 'multi';
mean1 = 0.1;     %  0.7    0.4
sig1 = 1.4;    %  1.4
options.mean = mean1;
options.sig = sig1;
% u = normrnd(0.2, 0.76, sx, sy);
miu_ = m0 + mean1 * m0;
sigma_ = sqrt(sig1^2 * (1-m0).^2);
m0 = normrnd(miu_, sigma_, sx, sy);

miu_ = m0_replace + mean1 * (1-m0_replace);
sigma_ = sqrt(sig1^2 * (1-m0_replace).^2);
m0_replace = normrnd(miu_, sigma_, sx, sy);

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
%-----------------------不同分布的对比------------------
% tmp = normrnd(0.1, 0.212, sx, sy);
% tmp = exprnd(miu, sx, sy);   %指数分布
% tmp = betarnd(0.1, 0.9, sx, sy);   %beta分布
% tmp = gamrnd(0.22, 0.45, sx, sy);
%---------------------------------------------------
% k = 1;
% m0_ = double(rand(sx,sy) < k*(1-m0));%（概率白噪声）
% m0_tmp1 = (1-m0_) .* m0;
% % m1 = m0 + normrnd(0.2, 0.76, sx, sy).*(1-m0);%乘性噪声（加性形式表示）生成随机正态分布的随机数
% m1 = m0 + tmp.*(1-m0);
% m0_tmp2 = m0_ .* m1;%结合噪声模型
% m0 = m0_tmp1 + m0_tmp2;
%-----------------------不同分布的对比------------------
% tmp = normrnd(0.1, 0.212, sx, sy);
% tmp = exprnd(miu, sx, sy);   %指数分布
% tmp = betarnd(0.1, 0.9, sx, sy);   %beta分布
% tmp = gamrnd(0.22, 0.45, sx, sy);
%---------------------------------------------------

%混合噪声3的替换噪声
% u = normrnd(0.2, 0.76, sx, sy);
% miu_ = m0 + u .* (1-m0).^2;
% sigma_ = sqrt(u.^2 .* m0 .*(1-m0).^3);
% m0 = normrnd(miu_, sigma_, sx, sy);

%混合噪声3的替换噪声2
% mean1 = 0.2; 
% sig1 = 0.76;
% % u = normrnd(mean1, sig1, sx, sy);
% miu_ = m0 + mean1 * (1-m0).^2;
% sigma_ = sqrt(mean1^2 * m0 .*(1-m0).^3 + sig1^2 * (1-m0).^3);
% m0 = normrnd(miu_, sigma_, sx, sy);

%混合噪声3的泊松噪声
% k = 1;
% m0_ = double(rand(sx,sy) < k*(1-m0));%（概率白噪声）
% m0_tmp1 = (1-m0_) .* m0;
% m1=poissrnd(m0*2);
% m0_tmp2 = m0_ .* m1;%结合噪声模型
% m0 = m0_tmp1 + m0_tmp2;

%混合噪声3的薄膜颗粒噪声
% k = 1;
% m0_ = double(rand(sx,sy) < k*(1-m0));%（概率白噪声）
% m0_tmp1 = (1-m0_) .* m0;
% m1 = m0 + normrnd(0, 1, sx, sy).*(1-m0).^0.333;%乘性噪声（加性形式表示）生成随机正态分布的随机数
% m0_tmp2 = m0_ .* m1;%结合噪声模型
% m0 = m0_tmp1 + m0_tmp2;


%% ---------------------------------直方图曲线------------------
        %噪声的曲线
%        clf;
        m0_part = m0(1:size_f(1),1:size_f(2));
        m0_xx = double(int32(m0_part.*255));
        m0_xx(m0_xx < 0) = 0;                  % 将小于0的值变为0
        m0_xx(m0_xx > 255) = 255;              % 将大于255的值变为255
        Value = unique(m0_xx(:));
        Count=[hist(m0_xx(:),Value)];
        plot(Value,Count, 'Color', [0 0 1]); %曲线图
        axis([0, 255,-inf,inf]);
        xlabel('Pixel Intensity (0-255)');      % x轴名称
        ylabel('Frequency');                   % y轴名称
        title('Histogram of Pixel Intensity'); % 添加标题
       
%         l1 = legend({'hatching result of Perlin noise','hatching result of GGM'},'Location','Best');
%         set(l1, 'FontSize', 14);
%         hold off;
%         saveas(gcf,[outputDir,imgDirname ,'_hatching_hist_line.png']);
%         imwrite(g1,[outputDir, imgDirname, '_hatchingResult_src.png']);
%         imwrite(g2,[outputDir, imgDirname, '_hatchingResult_replace.png']);
        
        hold on;
%        saveas(gcf,[directory_re,imgName ,'_noise_hist_line.png']);
       %% --------------------------------------------------------

%% 对噪声中的超范围的值进行提前处理
% for o=1:sx
%     for p=1:sy
%         if m0(o,p)>1
%             m0(o,p) = 1;
%         elseif m0(o,p) < 0
%             m0(o,p) = 0;
%         end
%     end
% end

%% 比较两个噪声图像的KL散度
% noise_img1 = m0(1:size_f(1),1:size_f(2));
% noise_img_replace = m0_replace(1:size_f(1),1:size_f(2));
% kl_div_noise = computeKLDiv(noise_img1, noise_img_replace);
% display(fprintf('kl_div_noise: %f', kl_div_noise));
%%  noise_img1

% directory_re = 'D:/MatlabTest/test_one_B/';
imwrite(m0(1:size_f(1),1:size_f(2)),[outputDir, imgDirname, '_noise.png']);

%% ------------------显示直方图-----------------------

    m0_part = m0(1:size_f(1),1:size_f(2));
    m0_xx = double(int32(m0_part.*255));
%         m0_xx(m0_xx < 0) = 0;                  % 将小于0的值变为0
%         m0_xx(m0_xx > 255) = 255;              % 将大于255的值变为255
    Value = unique(m0_xx(:));
    Count=[hist(m0_xx(:),Value)];
    plot(Value,Count, 'Color', [0 0 1], 'LineWidth', 3); %曲线图
    axis([0, 255,-inf,inf]);
    xlabel('Pixel Intensity (0-255)', 'FontSize', 20);      % x轴名称
    ylabel('Frequency', 'FontSize', 20);                   % y轴名称
    title('Histogram of Images', 'FontSize', 34); % 添加标题    Histogram of NoiseGamma
    hold on;


% result_hist = m0.*255;
% [sx1,sy1]=size(result_hist);
% result_hist = reshape(result_hist, [], 1);
% hist(result_hist, -100:355)
% result_hist_name = [imgDirname, '_noise_hist.png'];
% saveas(gcf,[directory_re, result_hist_name]);

%% --------------画像素分布的饼状图--------------------
% size_f=size(m0(1:size_f(1),1:size_f(2)));
% m0_tmp = m0(1:size_f(1),1:size_f(2));
% h_static = [0.0, 0.0, 0.0, 0.0, 0.0];
% label={'小于0','大于255','0~255之间', '等于0', '等于255'};%输入标签
% for o=1:size_f(1)
%     for p=1:1:size_f(2)
%         if m0_tmp(o,p) < 0.0
%            h_static(1) = h_static(1) + 1;
%         elseif m0_tmp(o,p) > 0.0 && m0_tmp(o,p) < 1
%            h_static(3) = h_static(3) + 1;
%         elseif m0_tmp(o,p) > 1.0
%            h_static(2) = h_static(2) + 1;
%         elseif m0_tmp(o,p) == 1.0
%            h_static(5) = h_static(5) + 1;
%         elseif m0_tmp(o,p) == 0.0
%            h_static(4) = h_static(4) + 1;
%         end
%     end
% end
% bili=h_static/sum(h_static);%计算比例
% baifenbi=num2str(bili'*100,'%1.2f');%计算百分比
% baifenbi=[repmat(blanks(2),length(h_static),1),baifenbi,repmat('%',length(h_static),1)];
% baifenbi=cellstr(baifenbi);
% Label=strcat(label,baifenbi');
% pie(h_static, Label);
% pieName = 'noise_pie.png';
% directory_re='D:/MatlabTest/test_one_B/';
% saveas(gcf,[directory_re, pieName]);
%----------------------------------------------------------------------

%% generate a random irrotational vector field
% options.bound = 'per';
options.bound = 'sym';
sigma = 20;
[x,y]=meshgrid(1:sx,1:sy);
t=max(sx,sy);


%% 交叉直线
z=(y)*1.8-(x); 
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

% 
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
     sigma = 1.8;%修改铅笔的宽度
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
M = M0;
M1 = M0;
w = 35;  %35
% for i=1:2
    options.M0 = M;
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

I=work_strok;
[m, n, p] = size(I);
k = 3;
% X = double(reshape(I, [], p));
% [idx, C] = kmeans(X, k, 'Replicates', 3, 'MaxIter', 200);
% I1 = reshape(C(idx, :), m, n, p);
% I1 = uint8(I1);

[C, label, J] = kmeans(I, k);
I1 = reshape(C(label, :), m, n, p);
% t_s = im2bw(I1);

%% 版本1 效果不好
% t_s = imbinarize(I1, ...
%                 'adaptive', ...              % 局部阈值
%                 'ForegroundPolarity','dark', ... % 针对暗前景/亮背景，反之用 'bright'  dark
%                 'Sensitivity',0.7);        % 0–1，越大越“宽松”（保留更多前景）

%% 版本2
% % 3) 轻微平滑，减少聚类后的小噪声
% Gf = imgaussfilt(I1, 0.8);
% % 4) 背景校正（适合亮背景上的暗笔触）
% bg = imopen(Gf, strel('disk', 15));   % 估计背景
% Gc = imsubtract(bg, Gf);              % 暗笔触增强；也可试 Gf - bg 看哪种更合适
% T = adaptthresh(Gc, 0.45, ...
%     'ForegroundPolarity', 'bright', ...   % 因为经过上一步后，笔触被增强成亮前景
%     'NeighborhoodSize', [31 31]);         % 可调大一点更平滑
% t_s = imbinarize(Gc, T);
% % 6) 后处理：去小噪点 + 连通
% t_s = bwareaopen(t_s, 20);                % 去掉小噪声
% t_s = imclose(t_s, strel('line', 3, 0));  % 横向连通，可按笔触方向调
% t_s = imfill(t_s, 'holes');

%% 版本3
% if size(I1,3) == 3
%     G = rgb2gray(I1);
% else
%     G = I1;
% end
% % 局部对比度增强
% G = adapthisteq(G, 'NumTiles', [8 8], 'ClipLimit', 0.01);
% % 轻微平滑
% G = imgaussfilt(G, 0.6);
% % 自适应阈值
% T = adaptthresh(G, 0.52, ...
%     'ForegroundPolarity', 'dark', ...
%     'NeighborhoodSize', [25 25]);
% t_s = imbinarize(G, T);
% % 去小噪声
% t_s = bwareaopen(t_s, 10);
% % 适当闭运算，避免细线断裂
% t_s = imclose(t_s, strel('disk', 1));


%% 版本4
% if size(I,3) == 3
%     G = rgb2gray(I);
% else
%     G = I;
% end
% G = im2double(G);
% w = 25;          % 窗口大小
% k = 0.2;         % Sauvola参数
% R = 0.5;         % 动态范围（double图像一般可取0.5）
% meanG = imboxfilt(G, w);
% meanG2 = imboxfilt(G.^2, w);
% stdG = sqrt(max(meanG2 - meanG.^2, 0));
% T = meanG .* (1 + k * (stdG / R - 1));
% % 暗前景
% t_s = G < T;
% t_s = bwareaopen(t_s, 15);
% t_s = imclose(t_s, strel('disk',1));


% imwrite(t_s,[outputDir, imgDirname, '_binary.png']);

%% 版本5
% --- 1. 平滑后二值 ---
G = im2double(I);
G = imgaussfilt(G, 2.0);

T = graythresh(G);
t_s = imbinarize(G, T);

t_s = bwareaopen(t_s, 50);
t_s = imopen(t_s, strel('disk', 2));
t_s = imclose(t_s, strel('disk', 4));
t_s = imfill(t_s, 'holes');

% --- 2. 软mask ---
alpha = imgaussfilt(double(t_s), 3);   % 边界模糊成过渡带
alpha = mat2gray(alpha);


t_s1=~t_s;

% t_s=threshold_segmentation(f);
% imwrite(t_s(r+1:size_f(1)-r-1,r+1:size_f(2)-r-1),[directory,'t_s.jpg']);

[imx,imy]=size(f);
MK1=ones(sx,sy);

tone=M0;
tone2=M0;

%-----------阈值分类---------

tone(t_s) = 1;
options.M0 = tone;
% imwrite(tone(1:size_f(1),1:size_f(2)),[directory,'after_t_s1.jpg']);
M_out = perform_lic(v2, w, options);
tone3 = M_out.M;


tone2(~t_s) = 1;
options.M0 = tone2;
imwrite(tone2(1:size_f(1),1:size_f(2)),[directory,'after_t_s.jpg']);
M_out = perform_lic(v2, w, options);
tone4 = M_out.M;


%版本五之前
% MK1(~t_s) = tone3(~t_s);
% MK1(t_s)  = tone4(t_s);

%配合版本五
MK1 = (1 - alpha) .* tone3(1:size_f(1),1:size_f(2)) + alpha .* tone4(1:size_f(1),1:size_f(2));

%-----------阈值分类---------

%% 分割
% options.M0 = M0;

%  M=1/2*(1.8*M0+0.2*MK1);

options.M0 = M0;
 
g1_xx = double(int32(MK1(1:size_f(1),1:size_f(2)).*255));
Value_src = unique(g1_xx(:));
Count_src =[hist(g1_xx(:),Value_src)];
plot(Value_src,Count_src, 'Color', [1 0 0], 'LineWidth', 3); %曲线图
axis([0, 255,-inf,inf]);
l1 = legend({'GGM','hatching result'},'Location','Best');   %multiplicative
set(l1, 'FontSize', 30);
set(gca, 'FontSize', 30);
hold off;
saveas(gcf,[outputDir,imgDirname ,'_hatching_hist_line.png']);
imwrite(MK1(1:size_f(1),1:size_f(2)),[outputDir, imgDirname, '_histResult_src.png']);

%     M3 = perform_lic(v3, w, options);
%     M = perform_lic(v1, w, options);
     %options.M0 = M3;
      %M3 = perform_lic(v3, 5, options);
%      M2=1/2*(0.2*M+1.8*M3);
g=MK1(1:size_f(1),1:size_f(2));
% imwrite(g,[directory,'LIC1.jpg']);
% g2=M(1:size_f(1),1:size_f(2));
% g=(g+g2)/2;
% directory=[cd,'\sketch1\results\'];
% imwrite(g,[directory,'LIC.jpg']);
% imwrite(g2,[directory,'LIC2.jpg']);
% figure;imshow(g);




