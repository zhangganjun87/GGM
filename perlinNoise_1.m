function zmat = perlinNoise_1()
%网上找的柏林噪声demo
%先定义变长大小，精度，以整数为参考点。默认最小点为0
limx = [0 64];
limy = [0 64];
dx = 1/16;
dy = 1/16;
%第一步：定义网格和各随机向量矩阵
minx = limx(1);
maxx = limx(2);
miny = limy(1);
maxy = limy(2);
numx = maxx - minx + 1;
numy = maxy - miny + 1;
numx_z = (maxx - minx)/dx + 1;
numy_z = (maxy - miny)/dy + 1;

[uxmat, uymat] = randxymat(numx + 1, numy + 1); %生成随机向量阵，边缘多了一行一列
zmat = zeros(numy_z, numx_z); %生成计算点网格，预设随机云图

j = 0;
for x = minx:dx:maxx
    j = j + 1;
    k = 0;
    for y = miny:dy:maxy
        k = k + 1;
        
        %n00计算
        ddx = x - floor(x);
        ddy = y - floor(y);
        ux = uxmat(floor(y) - miny + 1, floor(x) - minx + 1);
%         display(fprintf('ux: %f', ux));
        uy = uymat(floor(y) - miny + 1, floor(x) - minx + 1);
        n00 = GridGradient(ux, uy, ddx, ddy);
        
        %n10计算
        ddx=x-floor(x)-1;
        ddy=y-floor(y);
        ux=uxmat(floor(y)-miny+1,floor(x)-minx+2);%注意边缘点数据关联问题，这就是前面多了一行一列的原因
        uy=uymat(floor(y)-miny+1,floor(x)-minx+2);
        n10=GridGradient(ux,uy,ddx,ddy);
        
        %n01计算
        ddx=x-floor(x);
        ddy=y-floor(y)-1;
        ux=uxmat(floor(y)-miny+2,floor(x)-minx+1);
        uy=uymat(floor(y)-miny+2,floor(x)-minx+1);
        n01=GridGradient(ux,uy,ddx,ddy);
        
        %n11计算
        ddx=x-floor(x)-1;
        ddy=y-floor(y)-1;
        ux=uxmat(floor(y)-miny+2,floor(x)-minx+2);
        uy=uymat(floor(y)-miny+2,floor(x)-minx+2);
        n11=GridGradient(ux,uy,ddx,ddy);
        
        %然后再加权
        n0=lerp(n00,n10,x-floor(x));%参见后面的
        n1=lerp(n01,n11,x-floor(x));
        zmat(k,j)=lerp(n0,n1,y-floor(y));%把最终数据n存储到相应的矩阵中
    end
end
zmat = zmat + 0.5;
zmat(zmat > 1) = 1;
zmat(zmat < 0) = 0;

% 生成图像
% [xmat,ymat]=meshgrid(minx:dx:maxx,miny:dy:maxy);
figure;
% pcolor(xmat,ymat,zmat)
% shading interp
imshow(zmat);
end

function u = GridGradient(ux,uy,dx,dy)%数组相乘，其实就是点积，也可以用dot()函数替换
    u = ux*dx + uy*dy;
end

function u=lerp(a,b,t)%权重相加
    tw=6*t.^5-15*t.^4+10*t.^3;    %6*t.^5-15*t.^4+10*t.^3;%3*t.^2-2*t.^3;%
    u=(1-tw)*a + tw*b;
end

function [uxmat,uymat]=randxymat(numx,numy)        %单位圆内随机向量
    num=numx*numy;
    uxmat=zeros(numy,numx);
    uymat=zeros(numy,numx);
    %采用不断生成随机向量，然后检测是否在单位圆内的方法。这个方法维度越高效率越低。
    for j=1:num
        k=0;
        while k==0
            randxy=rand(1,2);   %生成一个1行2列的范围在(0,1)的随机数
            if (randxy(1)-0.5)^2+(randxy(2)-0.5)^2<=0.25
                k=k+1;
                uxmat(j)=randxy(1);
                uymat(j)=randxy(2);
            end
        end
    end
    uxmat=(uxmat-0.5)*2;%把随机向量调整为[-1,1]之间，这样生成的图像好看。
    uymat=(uymat-0.5)*2;
end