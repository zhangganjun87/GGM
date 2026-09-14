function result=pencilsketch_1(filename)
% pencilsketch
% Convert one photo or picture to a pencil-sketch-like image.
% example: pencilsketch_1
% result=pencilsketch('DFC001.jpg');
% copy right of pencilsketch @2013 Lei liu

%------------------遍历文件夹下每一张图片------------------
imgPath='D:/MatlabTest/test_one_D/solo2/';  % 图像库路径 input_RBWN_compare/ input_11 input_20
directory='D:/MatlabTest/test_one_I/copare_with_others50/';
imgDir=dir([imgPath, '*.*p']);  % 遍历所有 jpg/png 等图片文件
directory_tmp=[cd,'\result\'];

if ~exist(directory, 'dir')
    mkdir(directory);
end

for i = 1:length(imgDir)
%     try
        M=imread([imgPath, imgDir(i).name]);

        %% ------------------亮度通道提取------------------
        if size(M,3)==3
            M_lab=rgb2ntsc(M);
            work_im=M_lab(:,:,1);
            %imwrite(M_lab(:,:,2),[directory,'r.jpg']);
            %imwrite(M_lab(:,:,3),[directory,'v.jpg']);
        else
            work_im=M;
        end

        M_gray = rgb2gray(M);

        imwrite(M_gray, [directory, imgDir(i).name,'_gray.png']);

        % [L,centers] = imsegkmeans(M_gray,5);
        % B = labeloverlay(M_gray, L);

        %% %------------------轮廓提取------------------

        work_im=im2double(work_im);
        h=[1/9,1/9,1/9;1/9,1/9,1/9;1/9,1/9,1/9];
        work_strok=imfilter(work_im,h,'replicate');
        imwrite(work_strok,[directory_tmp,'src_withoutL0.png']);

        work_strok_withoutL0 = de_filter(work_strok);
        work_strok=L0Smoothing(work_strok,0.0003,12);   % (work_strok,0.003,2)，0.0003,6
        imwrite(work_strok,[directory_tmp,'src_L0.png']);
        %imwrite(work_strok,[directory,'L0.png']);

        strok=de_filter(work_strok);   % 轮廓提取
        imwrite(strok,[directory_tmp,'edge.png']);
        imwrite(work_strok_withoutL0,[directory_tmp,'edge_withoutL0.png']);

        %work_strok=double(im2uint8(work_strok));
        %strok=im2double(uint8(cld_main(work_strok)));
        strok=imfilter(strok,h,'symmetric','same');
        %strok=imadjust(strok,[],[0.4,1]);
        %figure;imshow(strok);
        %imwrite(strok,[directory,'strok.jpg']);

        %% ------------------色调处理预处理------------------
%         load('stand.mat'); % 标准素描直方图
%         tone=histeq(work_im,stand); % 直方图匹配
        tone=work_im;
        h3=fspecial('gaussian',[5,5],0.5);
        %tone=imfilter(tone,h3);

        tone=imadjust(tone,[],[0,1]);
        imwrite(tone,[directory_tmp,'low-pass.png']);

%         tone=tone_f(tone); % 色调处理，线积分卷积，正常调用时

        %******************************* paper texture ******************
%         size_f=size(work_strok);
%         sx = max(size_f(1),size_f(2));
%         perlinNoise = im2double(perlinNoise_2(sx)) * 1.7 + 0.9;   % 生成 paper texture
        %****************************************************************

        %% ------------------参数遍历------------------
%         mius = [ -0.2, 0, 0.2, 0.5];
%         vs = [0.5, 1, 2];
        mius = [0,];
        vs = [1];  %, 0.25, 0.1, 0.08,1, 0.8

        size_of_mius = size(mius);
%         display(fprintf('size_of_mius: %f', size_of_mius));
        size_of_vs = size(vs);

        for miu = 1:size_of_mius(2)
            for j = 1:size_of_vs(2)
                %% ------------------算法切换区------------------
%               tone_re=tone_seg_f(tone, work_strok, mius(miu), vs(j), imgDir(i).name);

%               tone_re = tone_seg_f_bkp(tone, work_strok, imgDir(i).name, directory);
%               tone_re = tone_kmeans_f_mine(tone, work_strok, imgDir(i).name, directory);
                tone_re = tone_kmeans_f_mine_two(tone, work_strok, imgDir(i).name, directory);
%               tone_re = tone_seg_f_compare(tone, work_strok, imgDir(i).name, directory);
%               tone_re = tone_seg_f_pencil_grading(tone, work_strok, imgDir(i).name, directory);
%               tone_re = tone_seg_f_noSeg(tone, work_strok, imgDir(i).name, directory);

%               tone_re = tone_kmeans_f_mine(tone, work_strok, imgDir(i).name);
%               tone=tone_seg_f(tone, work_strok, perlinNoise);  % 色调处理，线积分卷积，使用其他线型
%               imhist(tone);
%               tone_re=tone_cross_f_mytest(tone, work_strok); % 色调处理，线积分卷积，使用其他线型
%               tone = tone_cross_f(tone);
%               imwrite(tone,[directory_tmp,'tone_re.jpg']);
%               imwrite(strok,[directory_tmp,'strok_re.jpg']);
                %tone=grading(tone,7);

                %******************************* paper texture ******************
%               perlinNoise=perlinNoise(1:size_f(1),1:size_f(2));
%               strok=(1-(1-strok).*(1-perlinNoise));
%               strok=(1-(1-strok).* perlinNoise);   % 使用这个！
                %****************************************************************

                %% ------------------结果输出------------------
                result=strok.*tone_re;
                imwrite(strok,[directory, imgDir(i).name ,'_strok.png']);
                imwrite(tone_re,[directory,imgDir(i).name , '_tone_LIC.png']);
                imwrite(result,[directory,imgDir(i).name , '_result.png']);

                % 直方图曲线测试
%               m0_xx = double(int32(tone_re.*255));
%               Value = unique(m0_xx(:));
%               Count=[hist(m0_xx(:),Value)];
%               plot(Value,Count, 'Color', [1 0 0]); % 曲线图
%               axis([0, 255,-inf,inf]);
%               l1 = legend({'noise degraded image','hatching result'},'Location','Best');
%               set(l1, 'FontSize', 22);
%               hold off;
%               saveas(gcf,[directory,imgDir(i).name ,'_noise_hist_line.png']);

                % 显示直方图测试
%               result_hist = tone_re.*255;
%               [sx1,sy1]=size(result_hist);
%               result_hist = reshape(result_hist, [], 1);
%               hist(result_hist, -100:355)
%               imhist(result);
%               result_hist_name = [imgDir(i).name, '(', num2str(mius(miu)),',', num2str(vs(j)), ')hist.png'];
%               saveas(gcf,[directory, result_hist_name]);

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
