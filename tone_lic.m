function g = tone_lic(noiseImg, srcImg)

size_f=size(noiseImg);
if size_f(1)>size_f(2) 
    d = size_f(2) * 2 - size_f(1);  
    m0=zeros(size_f(1),size_f(1));
    m0(:,1:size_f(2))=noiseImg;
    m0(:,size_f(2):end)=noiseImg(:,size_f(2):-1:d );
    w0=size_f(1)/70;
else
    d = size_f(1) * 2 - size_f(2);
    m0 = zeros(size_f(2),size_f(2));
    m0(1:size_f(1),:) = noiseImg;
    m0(size_f(1):end,:)= noiseImg(size_f(1):-1: d,:);
    w0=size_f(2)/70;
end

options.bound = 'sym';
options.histogram = 'linear';
options.verb = 1;
options.spot_size = 1.3;

[sx,sy]=size(m0);
sigma = 20;
[x,y]=meshgrid(1:sx,1:sy);
t=max(sx,sy);

%%交叉直线
z=(y)*1.8-(x); 
z1=-x+1.5*y;

v=zeros(sy,sx,2);
[v(:,:,1),v(:,:,2)]=gradient(z);

v2(:,:,1)=(v(:,:,2)-1)./v(:,:,1);
v2(:,:,2)=-1;
v2 = perform_blurring(v2, sigma, options);
v2 = perform_vf_normalization(v2);

options.dt = 0.5;
sigma = 1.8;
% M0 = perform_blurring(m0, sigma, options);
M0 = m0;
w = 35;
options.M0 = M0;

I=srcImg;
[m, n, p] = size(I);
k = 3;
[C, label, J] = kmeans(I, k);
I1 = reshape(C(label, :), m, n, p);
t_s = im2bw(I1);
[imx,imy]=size(srcImg);
MK1=ones(sx,sy);
t_s1=~t_s;
tone = M0;
tone2=M0;
for o=1:imx
    for p=1:imy
        if t_s1(o,p)==1
        else
           tone(o,p)=1;
        end
    end
end
    options.M0 = tone;
    tone3 = perform_lic(v2, w, options);
for o=1:imx
    for p=1:imy
        if t_s(o,p)==0
            tone2(o,p)=1;
        end
    end
end
    options.M0 = tone2;
    tone4 = perform_lic(v2, w, options);
for o=1:imx
    for p=1:imy
        if t_s(o,p)==1
            MK1(o,p)=tone4(o,p);
        else
            MK1(o,p)=tone3(o,p);  
        end
    end
end

g=MK1(1:size_f(1),1:size_f(2));

end

