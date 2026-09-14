function [outputArg1,outputArg2] = test_JSDiv(inputArg1)
%TEST_JSDIV 此处显示有关此函数的摘要
%   此处显示详细说明

img_file = 'D:\\MatlabTest\\test_one_A\\jingwu35.jpg';
img = imread(img_file);
img = rgb2gray(img);
size_img=size(img);
width = size_img(1);
height = size_img(2);
img_double = im2double(img);

% m1=img_double+normrnd(0, 1, sx, sy).*(1-img_double);

miu1 = 0;
sigma1 = 2;
dist1 =img_double + normrnd(miu1, sigma1, width, height).*(1-img_double);

miu2 = 0;
sigma2 = 2;
dist2 = img_double + normrnd(miu2, sigma2, width, height).*(1-img_double);

%比较噪声的JSDiv
js_div = computeJSDiv(dist1, dist2, 1);
fprintf('The JS divergence between the two images is: %f\n', js_div);

%比较LIC结果的JSDiv  方式1
% [x,y]=meshgrid(1:width,1:height);
% sigma = 20;
% z=(y)*1.8-(x); 
% z1=-x+1.5*y;
% v=zeros(height,width,2);
% v2=zeros(height,width,2);
% [v(:,:,1),v(:,:,2)]=gradient(z);
% v2(:,:,1)=(v(:,:,2)-1)./v(:,:,1);
% v2(:,:,2)=-1;
% options.bound = 'sym';
% v2 = perform_blurring(v2, sigma, options);
% v2 = perform_vf_normalization(v2);
% w = 35;
% options.histogram = 'linear';
% options.verb = 1;
% options.spot_size = 1.3;
% name = 'rand';
% options.dt = 0.5;
% if strcmp(name, 'rand')
%      sigma = 1.8;%修改铅笔的宽度
%      options.M0 =perform_blurring(dist1, sigma, options);
% end
% tone1 = perform_lic(v2, w, options);
% 
% if strcmp(name, 'rand')
%      sigma = 1.8;%修改铅笔的宽度
%      options.M0 =perform_blurring(dist2, sigma, options);
% end
% tone2 = perform_lic(v2, w, options);
% js_div_lic = computeJSDiv(tone1, tone2, 1);
% fprintf('The JS divergence between the two LIC1 is: %f\n', js_div_lic);


%比较LIC结果的JSDiv  方式2
lic1 = tone_lic(dist1, dist1);
lic2 = tone_lic(dist2, dist2);
imshow(lic1);
imshow(lic2);
js_div_lic2 = computeJSDiv(lic1, lic2, 1);
fprintf('The JS divergence between the two LIC2 is: %f\n', js_div_lic2);


end

