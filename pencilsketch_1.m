function result=pencilsketch_1(filename)
%pencilsketch
%This function is used to convert one photo or picture to
%a picture just like pencilsketch
%example:pencilsketch_1
%result=pencilsketch('DFC001.jpg');
%copy right of pencilsketch @2013 Lei liu
%M=imread(filename);
%------------------遍历文件夹下每一张图片------------------
imgPath='D:/MatlabTest/test_one_A/input_Figure_9/animal/';  %图像库路径   input_RBWN_compare/     input_11   input_20   
directory='D:/MatlabTest/test_one_I/LyapunovCLT_4/';
imgDir=dir([imgPath, '*.*g']);%遍历所有jpg格式文件
directory_tmp=[cd,'\result\'];
if ~exist(directory, 'dir')
    % 如果不存在，则新建此文件夹
    mkdir(directory);
end
for i = 1:length(imgDir)
%     try
        M=imread([imgPath, imgDir(i).name]);
%% --------------------------直方图实验--------------------------------------
%         k = 1.6;
%         M = rgb2gray(M);
%         m0 =im2double(M);
% %         display(fprintf('source: %f', source));
%         [sx,sy]=size(M);
%         m0_ = double(rand(sx,sy) < k*(1-m0));%（概率白噪声）
%         m0_tmp1 = (1-m0_) .* m0;
%         m1 = m0 + normrnd(0, 0.08, sx, sy).*(1-m0);%乘性噪声（加性形式表示）生成随机正态分布的随机数
%         m0_tmp2 = m0_ .* m1;%结合噪声模型
%         m0 = m0_tmp1 + m0_tmp2;
%         imwrite(m0, [directory, imgDir(i).name,'hybridnoise.png']);
% %         x=poissrnd((1-source)*255*1);
% %         m0=x./max(max(x));
%         m0=double(rand(sx,sy)>k*(1-source));
%         m1 = source + normrnd(0, 0.1, sx, sy).* (1 - source);  
% %         imwrite(m1, [directory, imgDir(i).name,'m1_noise.png']);
%         m0=(1-(1-m0).*(1-m1));
% %         imwrite(m0, [directory, imgDir(i).name,'m0_noise.png']);
% %         nm = normrnd(0, 0.2, sx, sy).*source;
%         imhist(m0);
%         saveas(gcf,[directory, 'imhist_tmp_1.png']);
%         pause(5);
%-----------------------直方曲线--------------------------
%         m0_xx = double(int32(m1.*255));
%         Value = unique(m0_xx(:));
%         Count=[hist(m0_xx(:),Value)];
%         plot(Value,Count); %曲线图
%         hold on;
%         m0_xx = double(int32(m0.*255));
%         Value = unique(m0_xx(:));
%         Count=[hist(m0_xx(:),Value)];
%         plot(Value,Count); %曲线图
%         axis([-50, 300,-inf,inf])
%         legend({'乘性噪声退化值分布','混合噪声退化值分布'},'Location','Best');
%         hold off;
%         saveas(gcf,[directory,imgDir(i).name ,'test_noise_hist_line.png']);
%-------------------------------------------------------
%         %------------------显示直方图-----------------------
%         result_hist = m1.*255;
%         [sx1,sy1]=size(result_hist);
%         result_hist = reshape(result_hist, [], 1);
%         hist(result_hist, -1000:1000)
%         
% saveas(gcf,[directory, 'hist_tmp.png']);
% %         %--------------画像素分布的饼状图--------------------
%         size_f=size(M);
%         m0_tmp = m1;
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
% saveas(gcf,[directory, 'pie_tmp.png']);
% pause(5);
%----------------------------------------------------------------------
%         
%         saveas(gcf,[directory_tmp, 'xxx_(0.2,0.05).png']);
    %-----------------------单张图片-------------------------
    %-------------------------new Test------------------
%     k=1.6;
%     X = zeros(26,100);
%     X = X + 0.5;
%     [sx,sy]=size(X);
%     Z = zeros(sx,sy);
% %     TMP = ones(26, 100);
%     for o=1:sx
%         for p=1:sy
%             Z(o,p)= (1 - abs(sx/2 - o) / sx/2 * 8);
% %             if sy - p < sx
% %                 if o < sx/2 + p - sy
% %                     TMP(o,p) = 0;
% %                 elseif sx - o < sx/2 + p - sy
% %                     TMP(o,p) = 0;
% %                 end
% %             end
%         end
%     end
%     Y = normpdf(Z, 1, 0.5) + 1.2;
%     m0=double(rand(sx,sy)>Y.*(1-X));   %.*TMP
%     m0=(1-(1-m0).*(1-X));
%     
%     canvas_ = ones(600, 1000);
%     [sx_can,sy_can]=size(canvas_);
%     for i = 1:200
%         can_tmp = ones(600, 1000);
%         x_rnd = unidrnd(sx_can - 2*sx) + sx;
%         y_rnd = unidrnd(sy_can - 2*sy) + sy;
%         can_tmp(x_rnd:x_rnd + sx-1, y_rnd:y_rnd + sy-1) = m0;
%         canvas_ = canvas_.*can_tmp + (1 - can_tmp)*0.3;
%     end
%     figure;imshow(canvas_);
    %--------------------------------------------------
    %M=imread('000000000285.jpg');
    % -------------------------------------------------------
        
        if size(M,3)==3

            M_lab=rgb2ntsc(M); 
            work_im=M_lab(:,:,1); 
           %imwrite(M_lab(:,:,2),[directory,'r.jpg']);
           %imwrite(M_lab(:,:,3),[directory,'v.jpg']);
        else
            work_im=M;
        end
        %---------------测试kmeans的分割情况-----------------------
        M_gray = rgb2gray(M);
        
        %% ---------------------------------直方图曲线------------------
%         clf;
%         m0_xx = double(int32(M_gray.*1.0));
%         Value = unique(m0_xx(:));
%         Count=[hist(m0_xx(:),Value)];
%         plot(Value,Count, 'Color', [0 1 0]); %曲线图
%         hold on;
        
        imwrite(M_gray, [directory, imgDir(i).name,'_gray.png']);
%         M_gray_hist = M_gray;
%         [sx2,sy2]=size(M_gray_hist);
%         M_gray_hist = reshape(M_gray_hist, [], 1);
%         hist(M_gray_hist, -0:255)
%         gray_hist_name = [imgDir(i).name, 'gray_hist.png'];
%         saveas(gcf,[directory, gray_hist_name]);
        [L,centers] = imsegkmeans(M_gray,5);
        B = labeloverlay(M_gray, L);
%         imwrite(B, [directory,'imseg.png']);
%         imshow(B);
%         title('Labeled Image_imseg');
        %--------------------------------------------------------
        %figure;imshow(work_im);

        %imwrite(work_im,[directory,'gray.png']);
        work_im=im2double(work_im);
        h=[1/9,1/9,1/9;1/9,1/9,1/9;1/9,1/9,1/9];
        work_strok=imfilter(work_im,h,'replicate');
        imwrite(work_strok,[directory_tmp,'src_withoutL0.png']);
        work_strok_withoutL0 = de_filter(work_strok);
        work_strok=L0Smoothing(work_strok,0.0003,12);   %(work_strok,0.003,2)，，0.0003,6
        imwrite(work_strok,[directory_tmp,'src_L0.png']);
        %imwrite(work_strok,[directory,'L0.png']);
        strok=de_filter(work_strok);   %轮廓提取
        
        imwrite(strok,[directory_tmp,'edge.png']);
        imwrite(work_strok_withoutL0,[directory_tmp,'edge_withoutL0.png']);
        %work_strok=double(im2uint8(work_strok));
        %strok=im2double(uint8(cld_main(work_strok)));

        strok=imfilter(strok,h,'symmetric','same'); 
        %strok=imadjust(strok,[],[0.4,1]);

        %figure;imshow(strok);

        %imwrite(strok,[directory,'strok.jpg']);


%         load('stand.mat'); %标准素描直方图
%         tone=histeq(work_im,stand); %直方图匹配
        tone=work_im;
        h3=fspecial('gaussian',[5,5],0.5);
        %tone=imfilter(tone,h3);

        tone=imadjust(tone,[],[0,1]);
        imwrite(tone,[directory_tmp,'low-pass.png']);
        
%         tone=tone_f(tone); %色调处理 线积分卷积  正常调用时
        %*******************************!!!!paper texture******************
%         size_f=size(work_strok);
%         sx = max(size_f(1),size_f(2)); 
%         perlinNoise = im2double(perlinNoise_2(sx)) * 1.7 + 0.9;   %生成paper texture
        %******************************************************************
        %+++++++++++++添加不同数据的遍历++++++++++++++++++
%         mius = [ -0.2, 0, 0.2, 0.5];
%         vs = [0.5, 1, 2];
        mius = [0,];
        vs = [1];  %, 0.25, 0.1, 0.08,1, 0.8
        size_of_mius = size(mius);
%         display(fprintf('size_of_mius: %f', size_of_mius));
        size_of_vs = size(vs);       
        for miu = 1:size_of_mius(2)
            for j = 1:size_of_vs(2)
                
        %+++++++++++++++++++++++++++++++++++++++++++++
        
%           tone_re=tone_seg_f(tone, work_strok, mius(miu), vs(j), imgDir(i).name);

%             tone_re = tone_seg_f_bkp(tone, work_strok, imgDir(i).name, directory);
%           tone_re = tone_kmeans_f_mine(tone, work_strok, imgDir(i).name, directory);
%             tone_re = tone_kmeans_f_mine_two(tone, work_strok, imgDir(i).name, directory);
%           tone_re = tone_seg_f_compare(tone, work_strok, imgDir(i).name, directory);
%            tone_re = tone_seg_f_pencil_grading(tone, work_strok, imgDir(i).name, directory);
           tone_re = tone_seg_f_noSeg(tone, work_strok, imgDir(i).name, directory);
          

% tone_re = tone_kmeans_f_mine(tone, work_strok, imgDir(i).name);
%           tone=tone_seg_f(tone, work_strok, perlinNoise);  %色调处理 线积分卷积，使用其他线型
%         imhist(tone);
%         tone_re=tone_cross_f_mytest(tone, work_strok); %色调处理 线积分卷积，使用其他线型
%         tone = tone_cross_f(tone);
%         imwrite(tone,[directory_tmp,'tone_re.jpg']);
%         imwrite(strok,[directory_tmp,'strok_re.jpg']);
        %tone=grading(tone,7);
        %*******************************!!!!paper texture******************
%         perlinNoise=perlinNoise(1:size_f(1),1:size_f(2));
%           strok=(1-(1-strok).*(1-perlinNoise));
%           strok=(1-(1-strok).* perlinNoise);   %使用这个！
        %******************************************************************
        
%%  %--------------画像素分布的饼状图(LIC结果)--------------------
% size_f=size(M);
% m0_tmp = tone_re;0
% h_static = [0.0, 0.0, 0.0, 0.0, 0.0];
% label={'小于0','大于255','0~255之间', '等于0', '等于255'};%输入标签
% for o=1:size_f(1)
%     for p=1:1:size_f(2)
%         if m0_tmp(o,p) < 0.0
%            h_static(1) = h_static(1) + 1;
%         elseif m0_tmp(o,p) >= 0.0 && m0_tmp(o,p) <= 1
%            h_static(3) = h_static(3) + 1;
%         elseif m0_tmp(o,p) > 1.0
%            h_static(2) = h_static(2) + 1;
% %         elseif m0_tmp(o,p) == 1.0
% %            h_static(5) = h_static(5) + 1;
% %         elseif m0_tmp(o,p) == 0.0
% %            h_static(4) = h_static(4) + 1;
%         end
%     end
% end
% bili=h_static/sum(h_static);%计算比例
% baifenbi=num2str(bili'*100,'%1.2f');%计算百分比
% baifenbi=[repmat(blanks(2),length(h_static),1),baifenbi,repmat('%',length(h_static),1)];
% baifenbi=cellstr(baifenbi);
% Label=strcat(label,baifenbi');
% pie(h_static, Label);
% saveas(gcf,[directory,imgDir(i).name, 'LIC_result_pie_tmp.png']);
%----------------------------------------------------------------------
result=strok.*tone_re;
imwrite(strok,[directory, imgDir(i).name ,'_strok.png']);
imwrite(tone_re,[directory,imgDir(i).name , '_tone_LIC.png']);
imwrite(result,[directory,imgDir(i).name , '_result.png']);
%% ---------------------------------直方图曲线------------------
%        m0_xx = double(int32(tone_re.*255));
%        Value = unique(m0_xx(:));
%        Count=[hist(m0_xx(:),Value)];
%        plot(Value,Count, 'Color', [1 0 0]); %曲线图
% %        axis([-300, 400,-inf,inf])
%        axis([0, 255,-inf,inf]);
% %        legend({'乘性噪声值分布','0灰度值','255灰度值','LIC运算结果值分布'},'Location','Best');
% %        l1 = legend({'distribution of LIC image'},'Location','Best'); %'输入灰度图分布','噪声退化图分布',
%        l1 = legend({'noise degraded image','hatching result'},'Location','Best');
%        set(l1, 'FontSize', 22);
%        hold off;
%        saveas(gcf,[directory,imgDir(i).name ,'_noise_hist_line.png']);
%% --------------------------------------------------------
        %% ------------------显示直方图-----------------------
%                 result_hist = tone_re.*255;
%                 [sx1,sy1]=size(result_hist);
%                 result_hist = reshape(result_hist, [], 1);
%                 hist(result_hist, -100:355)
%                 imhist(result);
%                 result_hist_name = [imgDir(i).name, '(', num2str(mius(miu)),',', num2str(vs(j)), ')hist.png'];
%                 saveas(gcf,[directory, result_hist_name]);
%%------------------------------------------------------------------------------------                
                
        % result=imfilter(result,h,'same');
        %figure;imshow(result);
                
                M_lab(:,:,1)=result;
                resultName = [imgDir(i).name, '(', num2str(mius(miu)),',', num2str(vs(j)), ').png'];
                imwrite(result,[directory, resultName]);
                
            end
        end
        M=ntsc2rgb(M_lab);
%     catch
%         continue;
%     end
	%imwrite(M,[directory,'color.jpg']);
	%figure; imshow(M);
end