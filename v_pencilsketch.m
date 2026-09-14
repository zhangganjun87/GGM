function result=pencilsketch(filename)
% xs=0:1:255;
% ys=gaussmf(xs,[100 180])+100;
% plot(ys);
fid=fopen('.\results\GF_white.txt','wt');
for noi=1:1
    directory=[cd,'\results\'];str2=num2str(noi);str3='.jpg';str4='white';
    resultjpg=[directory,str4,str2,str3];
%单张统计曲线————————————————————————
M=imread('bird.jpg');
directory=[cd,'\results\'];
if size(M,3)==3
M_lab=rgb2ntsc(M); 
work_im=M_lab(:,:,1); 
% work_im=M(:,:,1); 
else
    work_im=M;
end
% figure;imshow(work_im);
work_im=im2double(work_im);

imwrite(work_im,[directory,'low-pass.jpg']);

% work_im=medfilt2(work_im);

h=[1/9,1/9,1/9;1/9,1/9,1/9;1/9,1/9,1/9];
work_strok=imfilter(work_im,h,'replicate');
work_strok=L0Smoothing(work_strok,0.003,2);
    
%  imwrite(work_strok,[directory,'L0.jpg']);
strok=de_filter(work_strok);   %轮廓提取
strok=L0Smoothing(strok,0.003,2);
g = imadjust(strok, [0, 220/255],[]);
strok=L0Smoothing(g,0.003,2);
g = imadjust(strok, [0, 220/255], []);
strok=g;
imwrite(strok,[directory,'strok.jpg']);

img_l=work_strok;
imwrite(img_l,[directory,'img_l.jpg']);

%    load('myhistdata.mat')
%    plot(hstand);%输出匹配直方图

% load('stand.mat'); %标准素描直方图
% tone=histeq(work_im,stand); %直方图匹配

% w     = 4;       % bilateral filter half-width  
% sigma = [3 0.1]; % bilateral filter standard deviations
% img_b=bfilter2(work_im,w,sigma); 
% imwrite(img_b,[directory,'img_b.jpg']);
%h3=fspecial('gaussian',[5,5],0.5);
%tone=imfilter(tone,h3);


% tone=work_im;
% tone=imadjust(tone,[],[0,1]);
% imwrite(tone,[directory,'low-pass.jpg']);
%--------------------------
tone=work_im;
%---------------
% tone1=mat_test(tone);
% tone2=mat_test(tone1);
% tone4=mat_test(tone2);
% tone5=mat_test(tone4);
% tone6=mat_test(tone5);
% tone7=mat_test(tone6);
% tone8=mat_test(tone7);
% tone9=mat_test(tone8);
% tone10=mat_test(tone9);
% tone11=mat_test(tone10);
% tone3=tone_f_m(tone11); %噪声
[m,n]=size(tone);
img=tone;
r=15;        %影线半长
imgn=ones(m+2*r+1,n+2*r+1);
imgn(r+1:m+r,r+1:n+r)=img;
imgn(1:r,r+1:n+r)=img(1:r,1:n);                 %扩展上边界
imgn(1:m+r,n+r+1:n+2*r+1)=imgn(1:m+r,n:n+r);    %扩展右边界
imgn(m+r+1:m+2*r+1,r+1:n+2*r+1)=imgn(m:m+r,r+1:n+2*r+1);    %扩展下边界
imgn(1:m+2*r+1,1:r)=imgn(1:m+2*r+1,r+1:2*r);       %扩展左边界
tone=imgn;
% for ti=1:2
%     tonetmp=tone;
%     tone=mat_test(tonetmp);
% end
% imwrite(tone,[directory,'tonef.jpg'])
tone3=tone_f_8v(tone,r);
tone3=tone3(r+1:m+r,r+1:n+r);

result=tone3.*strok;
imwrite(result,[directory,'result.jpg']);
% load('myhistdata.mat'); %标准素描直方图
% img=im2uint8(result);
% result2=hist_matching(img,hstand); %直方图匹配
%------------map------------
% map=imread('jingwu35_map.png');
% if size(map,3)==3
% map=rgb2ntsc(map); 
% map=map(:,:,1); 
% else
%     map=im2double(map);
% end
% map=ones(size(map))-map; 
% 
% IMG1 = ones(size(map));
% 
% IMG2 = double(result);
% h = size(IMG1,1);         % 读取图像高度
% 
% w = size(IMG1,2);         % 读取图像宽度
% 
% IMG3 = zeros(size(map)); 
% for i = 1 : h 
%     for j = 1 : w
%        IMG3(i,j) = IMG1(i,j,1)*map(i,j) + IMG2(i,j,1)*(1-map(i,j));
%     end
% end
% result_map=IMG3;
%------------map------------

% imshow(result_map);imwrite(result_map,[directory,'result_map.jpg']);
% imshow(result2);imwrite(result2,[directory,'result2.jpg']);
lic0=imread('.\results\LIC0.jpg'); lic0=im2double(lic0);imwrite(lic0.*strok,[directory,'result0.jpg']);

load('myhistdata.mat'); %标准素描直方图
img=im2uint8(result);
result2=hist_matching(img,hstand); %直方图匹配

%---伽马变换---
C = 1;
figure(1);
subplot(3,7,1);
imshow(tone3.*strok,[0 1])
GammaB=[221 204 199 187 183 170 153 136 119 102 85 74	68	58	51	42	34	26	17	0];
figure(2);
subplot(3,7,1);
hist_im=imhist(tone3); %计算直方图
bar(hist_im);%画直方图
for i=1:20
    Gamma(i)=(255-GammaB(i))/170;
g2 = C*(tone3.^Gamma(i));
figure(1);
subplot(3,7,i+1);
imshow(g2.*strok,[0 1]);
figure(2);
subplot(3,7,i+1)
hist_im=imhist(g2); %计算直方图
bar(hist_im);%画直方图
end 
figure;
x=1:1:20;
% plot(x,GammaB,'r*',x,Gamma,'b')
plot(x,Gamma,'b');
%---伽马变换---
figure(noi);%imshow(tone3,[]);%输出模拟素描结果图
set (gcf,'Position',[0,0,1366,500], 'color','w')
imwrite(tone3,[directory,'resultimg.jpg']);%保存模拟影线图
result=strok.*tone3;
% result=tone3;

M_lab(:,:,1)=result;
  imwrite(result,[directory,'result.jpg']);
  M=ntsc2rgb(M_lab);

imwrite(M,[directory,'color.jpg']);
%  figure; imshow(M);
% set(gcf,'color','w');
% subplot(2,3,1);imshow(tone3);
hre1=imhist(result);
subplot(2,5,5);plot(hre1);

load('myhistdata.mat'); %标准素描直方图
img=im2uint8(result);
result2=hist_matching(img,hstand); %直方图匹配

result2=im2double(result2);
  M_lab(:,:,1)=result2;
  imwrite(result,[directory,'result2.jpg']);
  M=ntsc2rgb(M_lab);

imwrite(result2,[directory,'histmatching_re.jpg']);%保存histogram matching后的影线图

% ------通常-------
subplot(2,5,1);imshow(result);
for i=1:299;
    x(i)=i;
    y(i)= tone3(300-i,i)*255;
end

lev=2;
y=wden(y,'minimaxi','s','sln',lev,'sym6');
y=mapminmax(y,0,255);
subplot(2,5,2);plot(y);
grid on;
yy = diff(y);
yy(yy<0) = -1;
yy(yy>0) = 1;
yyy = diff(yy);
mv = yyy(yyy~=0);
id = find(yyy~=0);
x0 = x(id);
y0 = y(id);
hold on;
ti=1;
for k = 1:length(id);
    if mv(k)<0
        s = '峰:';
        mf(k)=x0(k);
        nf(k)=y0(k);
    else
        s = '谷:';
        mg(ti)=x0(k);
        ng(ti)=y(id(k));
        ti=ti+1;
    end;
end;

x=1:1:length(mg);
% A=[0.02667    4.7429    -0.5810];
A=[0.04413    3.9076    2.6680];
z=polyval(A,x);
k=1:1:length(mg);
y=mg;
B1=polyfit(x,y,3);
B3=polyfit(x,y,2);
subplot(2,5,4);
plot(k,y,'r.',x,z,'b');

% ansmg= norm(y - mean(z))^2/norm(z - mean(y))^2;
RR1=sqrt(sum((y-z).^2)/(length(z)-1));
% text(5,150,num2str(ansmg));
text(5,180,num2str(RR1));

x=1:1:length(ng);
y=ng;
B2=polyfit(x,y,2);
B4=polyfit(x,y,1);
a=abs(B1(1));b=abs(B1(2));
G1=b/(0.3+b)*(1-a)*0.5+abs(B2(1));
% G1= abs(B1(1))*0.5+ abs(B2(1))*0.5;
disp([num2str(abs(B1(1))*0.5) ' + ' num2str(abs(B2(1))*0.5) ' = ' num2str(G1)]);
A=polyfit(x,y,1);
z=polyval(A,x);
subplot(2,5,3);plot(ng);
plot(x,y,'r.',x,z,'b');
% ansmg= norm(y - mean(z))^2/norm(z - mean(y))^2;
RR2=sqrt(sum((y-z).^2)/(length(z)-1));
% text(5,150,num2str(ansmg));
text(5,180,num2str(RR2))
F1=0.5*RR1+0.5*RR2;
text(10,240,[ 'G1 = ' num2str(G1)])
text(10,220,[ 'F1 = ' num2str(F1)])
% for k = 2:length(mg);
%     a(k)=mg(k)-mg(k-1);
% end
% figure;plot(a);
% hold off;
% ------通常-------
% ------色调处理-------
subplot(2,5,6);imshow(result2);

hre2=imhist(result2);
subplot(2,5,10);plot(hre2);

for i=1:299;
    x(i)=i;
    y(i)= result2(300-i,i)*255;
end

lev=2;
y=wden(y,'minimaxi','s','sln',lev,'sym6');
y=mapminmax(y,0,255);
subplot(2,5,7);plot(y);
grid on;
yy = diff(y);
yy(yy<0) = -1;
yy(yy>0) = 1;
yyy = diff(yy);
mv = yyy(yyy~=0);
id = find(yyy~=0);
x0 = x(id);
y0 = y(id);
hold on;
ti=1;
for k = 1:length(id);
    if mv(k)<0
        s = '峰:';
        mf(k)=x0(k);
        nf(k)=y0(k);
    else
        s = '谷:';
        mg(ti)=x0(k);
        ng(ti)=y(id(k));
        ti=ti+1;
    end;
end;

x=1:1:length(mg);
% A=[0.02667    4.7429    -0.5810];
A=[0.04413    3.9076    2.6680];
z=polyval(A,x);
k=1:1:length(mg);
y=mg;
B1=polyfit(x,y,3);
subplot(2,5,9);
plot(k,y,'r.',x,z,'b');

% ansmg= norm(y - mean(z))^2/norm(z - mean(y))^2;
RR3=sqrt(sum((y-z).^2)/(length(z)-1));
% text(5,150,num2str(ansmg));
text(5,180,num2str(RR3));

x=1:1:length(ng);
y=ng;
B2=polyfit(x,y,2);
a=abs(B1(1));b=abs(B1(2));
G2=b/(0.01+b)*(1-a)*0.5+abs(B2(1));
% G2= abs(B1(1))*0.5+ abs(B2(1))*0.5;
disp([num2str(abs(B1(1))*0.5) ' + ' num2str(abs(B2(1))*0.5) ' = ' num2str(G2)]);
A=polyfit(x,y,1);
z=polyval(A,x);
subplot(2,5,8);plot(ng);
plot(x,y,'r.',x,z,'b');
% ansmg= norm(y - mean(z))^2/norm(z - mean(y))^2;
RR4=sqrt(sum((y-z).^2)/(length(z)-1));
% text(5,150,num2str(ansmg));
text(5,180,num2str(RR4))
F2=0.5*RR3+0.5*RR4;
text(10,240,[ 'G2 = ' num2str(G2)])
text(10,220,[ 'F2 = ' num2str(F2)])
% for k = 2:length(mg);
%     a(k)=mg(k)-mg(k-1);
% end
% figure;plot(a);
% hold off;
% ------色调处理-------
%单张统计曲线————————————————————————
print(noi, '-dpng', resultjpg);
fprintf(fid,'%8.4f %8.4f %8.4f %8.4f %8.4f %8.4f\n',RR1,RR2,F1,RR3,RR4,F2);
end
fclose(fid);

% % _______28张统计_________
% for noi=1:2
%     directory=[cd,'\results\'];str1='gre';str2=num2str(noi);str3='.jpg';str4='4ge';
%     soucejpg=[directory,str1,str2,str3];
%     resultjpg=[str4,str2,str3];
% M=imread(soucejpg);
% 
% directory=[cd,'\results\'];
% if size(M,3)==3
% M_lab=rgb2ntsc(M); 
% work_im=M_lab(:,:,1); 
% else
%     work_im=M;
% end
% figure(noi);% figure;imshow(work_im);
% 
% work_im=im2double(work_im);
% %--------------------------
% tone=work_im;
% % -------------
% subplot(2,2,1);imshow(work_im);
% 
% for i=1:299;
%     x(i)=i;
%     y(i)= tone(300-i,i)*255;
% end
% 
% lev=2;
% y=wden(y,'minimaxi','s','sln',lev,'sym6');
% y=mapminmax(y,0,255);
% subplot(2,2,2);plot(y);
% grid on;
% yy = diff(y);
% yy(yy<0) = -1;
% yy(yy>0) = 1;
% yyy = diff(yy);
% mv = yyy(yyy~=0);
% id = find(yyy~=0);
% x0 = x(id);
% y0 = y(id);
% hold on;
% ti=1;
% for k = 1:length(id);
% %     plot(x0(k),y0(k),'r.');
%     if mv(k)<0
%         s = '峰:';
%         mf(k)=x0(k);
%         nf(k)=y0(k);
%     else
%         s = '谷:';
%         mg(ti)=x0(k);
%         ng(ti)=y(id(k));
%         ti=ti+1;
%     end;
% %     s = [s num2str(x0(k)) ',' num2str(y0(k))];
% %     text(x0(k),y0(k),s);
% end;
% % x=0:5:50;
% % y=[3 20 38 56 66 93 117 142 180 212 265];
% % A=polyfit(x,y,2);
% x=1:1:length(mg);
%  A=[0.0343    3.3033    3.5206];
% % A=[0.0488    2.7309    7.1556];
% z=polyval(A,x);
% k=1:1:length(mg);
% y=mg;
%                          A=polyfit(x,y,3);
%                          z=polyval(A,x);
% %                          disp(1);
% %                          disp(A);
% subplot(2,2,4);
% plot(k,y,'r.',x,z,'b');
% 
% % ansmg= norm(y - mean(z))^2/norm(z - mean(y))^2;
% RR2=sqrt(sum((y-z).^2)/(length(z)-1));
% % text(5,150,num2str(ansmg));
% text(5,180,num2str(RR2));
% 
% % ti2=1;
% % for k = 2:length(mg);
% %     pg(ti2)=mg(k)-mg(k-1);
% %     ti2=ti2+1;
% % end
% % x=1:1:length(pg);
% % y=pg;
% % B=polyfit(x,y,2);
% % disp(1);disp(B);
% % subplot(2,3,5);plot(pg);
% 
% x=1:1:length(ng);
% y=ng;
% B=polyfit(x,y,2);
% % B=[1.2479  175.6366];
% z=polyval(B,x);
% % disp(2);disp(A);
% subplot(2,2,3);plot(ng);
% plot(x,y,'r.',x,z,'b');
% % ansmg= norm(y - mean(z))^2/norm(z - mean(y))^2;
% RR2=sqrt(sum((y-z).^2)/(length(z)-1));
% % text(5,150,num2str(ansmg));
% text(5,180,num2str(RR2))
% % for k = 2:length(mg);
% %     a(k)=mg(k)-mg(k-1);
% % end
% % figure;plot(a);
% % hold off;
% G=abs(A(1))*0.5+ abs(B(1))*0.5;
% disp([num2str(abs(A(1))*0.5) ' + ' num2str(abs(B(1))*0.5) ' = ' num2str(G)]);
% 
% print(noi, '-dpng', resultjpg);
% end
% % _______28张统计_________