function g=tone_kmeans_f_mine_three(f ,work_strok, imgName, outputDir)
size_f=size(f);

if size_f(1)>size_f(2) 
    d = size_f(2) * 2 - size_f(1);  
    m0=zeros(size_f(1),size_f(1));
    work_strok_=zeros(size_f(1),size_f(1));
    m0(:,1:size_f(2))=f;
    work_strok_(:,1:size_f(2))=work_strok;
%     m0(:,size_f(2):end)=1;
    m0(:,size_f(2):end)=f(:,size_f(2):-1:d );
    work_strok_(:,size_f(2):end)=work_strok(:,size_f(2):-1:d );
    w0=size_f(1)/70;
else
    d = size_f(1) * 2 - size_f(2);
    m0=zeros(size_f(2),size_f(2));
    work_strok_=zeros(size_f(2),size_f(2));
    m0(1:size_f(1),:)=f;
    work_strok_(1:size_f(1),:)=work_strok;
%     m0(size_f(1),:)=1;
    m0(size_f(1):end,:)=f(size_f(1):-1: d,:);
    work_strok_(size_f(1):end,:)=work_strok(size_f(1):-1: d,:);
    w0=size_f(2)/70;
end

% source=double(im2uint8(m0));
source=im2double(m0);
w=fspecial('gaussian',[5 5]);
source=imfilter(source,w,'symmetric','same');   %, 'same'
[sx,sy]=size(m0);


%% 乘性噪声
% m1=m0+normrnd(0,1.0,sx,sy).*(1-m0);%乘性噪声（加性形式表示）
% m0=m1;

%% 混合噪声
% k = 1;
% m0=double(rand(sx,sy)>k*(1-m0));%（概率白噪声）
% m1 = source +normrnd(0, 1, sx, sy).*(1 - source);%乘性噪声（加性形式表示）生成随机正态分布的随机数
% m0=(1-(1-m0).*(1-m1));%结合噪声模型

%% GGM
m0=m0+normrnd(0,1.0,sx,sy).*(1-m0);

% options.bound = 'per';
options.bound = 'sym';
%% generate a random irrotational vector field

sigma = 20;
[x,y]=meshgrid(1:sx,1:sy);
t=max(sx,sy);

%%交叉直线
z=(y)*1.8-(x); 
z1=-x+1.5*y;

v=zeros(sy,sx,2);
v1=zeros(sy,sx,2);
v2=zeros(sy,sx,2);
v3=zeros(sy,sx,2);

%-------------------------------------------
[v(:,:,1),v(:,:,2)]=gradient(z);
[v1(:,:,1),v1(:,:,2)]=gradient(z1);
% [v_(:,:,1),v_(:,:,2)]=gradient(z2);

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

%交叉弧线
% p=(y+t).^2+(x-2*t).^2*2;
% p1=(x+2*t).^2+(y-t).^2*7;

% options.histogram = 'gaussian';
options.histogram = 'linear';
options.verb = 1;
% size of the features
options.spot_size = 1.3;

%% ---------------------------------KMeans前移-------------------------------
I=work_strok_;  %work_strok
[m, n, p] = size(I);
k = 3;
[C, label, J] = kmeans(I, k);
[C_sorted, Idx_c] = sort(C);
% display(fprintf('C_sorted: %f', C_sorted));
x_test = reshape(label, m, n, p);
[imx,imy]=size(I);
x_disp = reshape(C(label, :), m, n, p);
imwrite(x_disp(1:size_f(1),1:size_f(2)),[outputDir, imgName, '_seg_with_C.png']);  %
%------------------test：对分割区域的边界进行均值滤波，模糊边界-------------------
x_tmp_miu = x_test;
x_tmp_sigma = x_test;
grading_name = ["9H", "8H", "7H", "6H", "5H", "4H", "3H", "2H", "H", "F", "HB", "B", "2B", "3B", "4B", "5B", "6B", "7B", "8B", "9B"];
miu_list = [0.86 0.8 0.78 0.73 0.71 0.66 0.6 0.53 0.46 0.4 0.33 0.29 0.26 0.22 0.18 0.13 0.09 0.06 0.03 0.01];
sigma_list = [1.48 1.45 1.40 1.35 1.30 1.25 1.20 1.15 1.10 1.05 1.0 0.95 0.92 0.90 0.88 0.86 0.84 0.82 0.80 0.78];

grading_map = struct('G9H', struct('miu', 0.86, 'sigma', 1.48),...
    'G8H', struct('miu', 0.80, 'sigma', 1.45),...
    'G7H', struct('miu', 0.78, 'sigma', 1.40),...
    'G6H', struct('miu', 0.73, 'sigma', 1.35),...
    'G5H', struct('miu', 0.71, 'sigma', 1.30),...
    'G4H', struct('miu', 0.66, 'sigma', 1.25),...
    'G3H', struct('miu', 0.60, 'sigma', 1.20),...
    'G2H', struct('miu', 0.53, 'sigma', 1.15),...
    'GH', struct('miu', 0.46, 'sigma', 1.10),...
    'GF', struct('miu', 0.40, 'sigma', 1.05),...
    'GHB', struct('miu', 0.33, 'sigma', 1.00),...
    'GB', struct('miu', 0.29, 'sigma', 0.95),...
    'G2B', struct('miu', 0.26, 'sigma', 0.92),...
    'G3B', struct('miu', 0.22, 'sigma', 0.90),...
    'G4B', struct('miu', 0.18, 'sigma', 0.88),...
    'G5B', struct('miu', 0.13, 'sigma', 0.86),...
    'G6B', struct('miu', 0.09, 'sigma', 0.84),...
    'G7B', struct('miu', 0.06, 'sigma', 0.82),...
    'G8B', struct('miu', 0.03, 'sigma', 0.80),...
    'G9B', struct('miu', 0.01, 'sigma', 0.78));
    
grading_key = 'G7B';

for o=1:imx
    for p=1:imy
        %% -----原始方法：根据不同的centroid值，自动调整------------------
        if x_test(o,p)== Idx_c(1)
            x_tmp_miu(o,p)=C_sorted(1) - 0.1 ;
            x_tmp_sigma(o,p)=1-C_sorted(1)+0.6;
        elseif x_test(o,p)== Idx_c(2)
            x_tmp_miu(o,p)=C_sorted(2) - 0.2;
            x_tmp_sigma(o,p)=1-C_sorted(2)+0.6;
        elseif x_test(o,p)== Idx_c(3)
            x_tmp_miu(o,p)=C_sorted(3) - 0.4;
            x_tmp_sigma(o,p)=1-C_sorted(3) +0.6;
        end
        
         %% -----新方法：按照不同的pencilgrading来设置------------------
%         if x_test(o,p)== Idx_c(1)
%             grading_key = 'G3B';   %8B   3B  H  9B
%             x_tmp_miu(o,p)= grading_map.(grading_key).miu;
%             x_tmp_sigma(o,p)= grading_map.(grading_key).sigma;
%         elseif x_test(o,p)== Idx_c(2)
%             grading_key = 'GHB';   %5B   HB  3H  8B
%             x_tmp_miu(o,p)= grading_map.(grading_key).miu;
%             x_tmp_sigma(o,p)= grading_map.(grading_key).sigma;
%         elseif x_test(o,p)== Idx_c(3)
%             grading_key = 'G2H';     %2B  2H  5H  6B
%             x_tmp_miu(o,p)= grading_map.(grading_key).miu;
%             x_tmp_sigma(o,p)= grading_map.(grading_key).sigma;
%         elseif x_test(o,p)== Idx_c(4)
%             grading_key = 'G5H';    %2H  5H  8H 5B
%             x_tmp_miu(o,p)= grading_map.(grading_key).miu;
%             x_tmp_sigma(o,p)= grading_map.(grading_key).sigma;
%         elseif x_test(o,p)== Idx_c(5)
%             grading_key = 'G9H';    %8H  9H  9H  3B
%             x_tmp_miu(o,p)= grading_map.(grading_key).miu;
%             x_tmp_sigma(o,p)= grading_map.(grading_key).sigma;
%         end
    end
end

h = fspecial('average', [23,23]);
x_tmp_miu = imfilter(x_tmp_miu, h,'symmetric','same');
miu_mat_ = x_tmp_miu;
sig_mat = x_tmp_sigma;
mode = 'GGM';
options.mean = miu_mat_;
options.sig = sig_mat;
options.src = source;
options.noise_mode = mode;
% sig_mat = sig_mat .* 0.762;
sig_mat(sig_mat < 0.1) = 0.1;
%----------------------------------------

% k = 1;
% m0=double(rand(sx,sy)>k*(1-m0));%（概率白噪声）
options.dt = 0.5;
sigma = 1.8;    %修改铅笔的宽度1.8
w_ = 40;    %修改铅笔影线长度 35
MK1=ones(sx,sy);

m0_1 = source +normrnd(miu_mat_, sig_mat, sx, sy).*(1 - source);%乘性噪声（加性形式表示）生成随机正态分布的随机数 GGM
m_tmp_1 =  C_sorted(1) + normrnd(C_sorted(1)-0.1, 0.8, sx, sy).*(1 - C_sorted(1));
m0_1(x_test ~= Idx_c(1)) = m_tmp_1(x_test ~= Idx_c(1));
% imwrite(m0_1(1:size_f(1),1:size_f(2)),[outputDir, imgName, 'm0_1_tmp.png']);
M0_1 = perform_blurring(m0_1, sigma, options);
% imwrite(m0_1(1:size_f(1),1:size_f(2)),[directory_re, imgName, '_noise_C.png']);
options.M0 = M0_1;
M_out1 = perform_lic(v2, w_, options);
tone_1 = M_out1.M;

m0_2 = source +normrnd(miu_mat_, sig_mat, sx, sy).*(1 - source);%乘性噪声（加性形式表示）生成随机正态分布的随机数 
m_tmp_2 =  C_sorted(2) + normrnd(C_sorted(2)-0.1, 0.8, sx, sy).*(1 - C_sorted(2));
m0_2(x_test ~= Idx_c(2)) = m_tmp_2(x_test ~= Idx_c(2));
% imwrite(m0_2(1:size_f(1),1:size_f(2)),[outputDir, imgName, 'm0_2_tmp.png']);
M0_2 = perform_blurring(m0_2, sigma, options);
options.M0 = M0_2;
M_out2 = perform_lic(v2, w_, options);  %相同方向 单直线
tone_2 = M_out2.M;

m0_3 = source +normrnd(miu_mat_, sig_mat, sx, sy).*(1 - source);%乘性噪声（加性形式表示）生成随机正态分布的随机数 
m_tmp_3 =  C_sorted(3) + normrnd(C_sorted(3)-0.1, 0.8, sx, sy).*(1 - C_sorted(3));
m0_3(x_test ~= Idx_c(3)) = m_tmp_3(x_test ~= Idx_c(3));
% imwrite(m0_3(1:size_f(1),1:size_f(2)),[outputDir, imgName, 'm0_3_tmp.png']);
M0_3 = perform_blurring(m0_3, sigma, options);
options.M0 = M0_3;
M_out3 = perform_lic(v2, w_, options);   %相同方向  单抛物线  vp2
tone_3 = M_out3.M;

%----------------------------------------------------------------------

%% iterated lic

% for o=1:imx
%     for p=1:imy
%         if x_test(o,p)== Idx_c(1)
%             MK1(o,p)=tone_1(o,p);
%         elseif x_test(o,p)== Idx_c(2)
%             MK1(o,p)=tone_2(o,p);
%         else
%             MK1(o,p)=tone_3(o,p);
%         end
%     end
% end
% imshow(MK1);

%% 软融合
mask1 = double(x_test == Idx_c(1));
mask2 = double(x_test == Idx_c(2));
mask3 = double(x_test == Idx_c(3));

hmask = fspecial('gaussian', [15 15], 8);   % 可再调大
w1 = imfilter(mask1, hmask, 'symmetric', 'same');
w2 = imfilter(mask2, hmask, 'symmetric', 'same');
w3 = imfilter(mask3, hmask, 'symmetric', 'same');
gamma_w = 1.8;   % 1.5~2.5 可试
w1 = w1 .^ gamma_w;
w2 = w2 .^ gamma_w;
w3 = w3 .^ gamma_w;

wsum = w1 + w2 + w3 + eps;
w1 = w1 ./ wsum;
w2 = w2 ./ wsum;
w3 = w3 ./ wsum;
% MK1 = w1 .* tone_1 + w2 .* tone_2 + w3 .* tone_3;

%% 尝试2
hard1 = double(x_test == Idx_c(1));
hard2 = double(x_test == Idx_c(2));
hard3 = double(x_test == Idx_c(3));

soft_band = (w1 .* w2 + w1 .* w3 + w2 .* w3);
soft_band = mat2gray(soft_band);
soft_band = min(soft_band * 3, 1);   % 缩窄过渡带

MK1_hard = hard1 .* tone_1 + hard2 .* tone_2 + hard3 .* tone_3;
MK1_soft = w1   .* tone_1 + w2   .* tone_2 + w3   .* tone_3;

MK1 = (1 - soft_band) .* MK1_hard + soft_band .* MK1_soft;

%% lic for increasing times

g=MK1(1:size_f(1),1:size_f(2));

