function g=tone_seg_f_pencil_grading(f,work_strok, imgDirname, outputDir)

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
w=fspecial('gaussian',[5 5]);
source=imfilter(source,w);
[sx,sy]=size(m0);
m0_src = m0;


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

v1 = perform_blurring(v1, sigma, options);
v1 = perform_vf_normalization(v1);
v3 = perform_blurring(v3, sigma, options);
v3 = perform_vf_normalization(v3);

% options.histogram = 'gaussian';
options.histogram = 'linear';
options.verb = 1;
% size of the features
options.spot_size = 1.3;
name = 'rand';
options.dt = 0.5;
w_list = [4 6 8 10 12 14];

I=work_strok;
[m, n, p] = size(I);
k = 3;
[C, label, J] = kmeans(I, k);
I1 = reshape(C(label, :), m, n, p);
t_s = im2bw(I1);
t_s1=~t_s;
[imx,imy]=size(f);
MK1=ones(sx,sy);

%% 乘性噪声

grading_name = ["9H", "8H", "7H", "6H", "5H", "4H", "3H", "2H", "H", "F", "HB", "B", "28", "3B", "4B", "5B", "6B", "7B", "8B", "9B"];
miu_list = [0.86 0.8 0.78 0.73 0.71 0.66 0.6 0.53 0.46 0.4 0.33 0.29 0.26 0.22 0.18 0.13 0.09 0.06 0.03 0.01];
sigma_list = [1.48 1.45 1.40 1.35 1.30 1.25 1.20 1.15 1.10 1.05 1.0 0.95 0.92 0.90 0.88 0.86 0.84 0.82 0.80 0.78];

for i = 1:length(miu_list)
    miu_ = miu_list(i);
    sigma_ = sigma_list(i);
    name_ = grading_name(i);
%     sigma_
    sigma_ = sigma_ / 2.0;
    
    m1= (m0_src - 0.15) + normrnd(miu_, sigma_, sx, sy).* (1 -m0_src);%乘性噪声（加性形式表示）  (1 -m0)  m0_src + 
    
    sigma = 1.8;%修改铅笔的宽度
    M0 = perform_blurring(m1, sigma, options);
    
    %% iterated lic
    w = 35;  %35
    options.M0 = M0;
    
%% -----------阈值分类---------
    tone = perform_lic(v2, w, options);
 
    hatching_result = tone(1:size_f(1),1:size_f(2));
    
    filePath = fullfile(outputDir, name_ + "_hatching_result.png");
    imwrite(hatching_result, filePath);
end


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


g=MK1(1:size_f(1),1:size_f(2));




