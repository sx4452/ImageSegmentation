function ImageSplit
I = imread('junshizhandoujizhuomianbizhi_399688_10.jpg');
I = rgb2gray(I);
imwrite(I, 'multifighter_gray.jpg');
d=splitmerge(I,2,@predicate);%调用splitmerge函数对图像进行分裂合并。
%d=ThresholdSplit(I);
%d=RegionGrow(I);
imwrite(d, 'multifighter_gray_split.jpg');
end

%本程序通过使用一个基于四叉树分解的分裂合并原则来分隔图像f，
%其中mindim是一个2的正整数次幂的数，它规定了被准许的子图像四叉树区域的最小维数。
function  g=splitmerge(f,mindim,fun)
%下面的三个语句实现用0填充图像，保证下面的函数qtdecomp可以将区域分到1*1的大小。
Q=2^nextpow2(max(size(f)));
[M,N]=size(f);
f=padarray(f,[Q-M,Q-N],'post');
S=qtdecomp(f,@split_test,mindim,fun);%用matlab自带的函数开始进行分裂图像。
Lmax=full(max(S(:)));%使用full求得最大区域的大小，因为S是一个稀疏阵。
g=zeros(size(f));
MARKER=zeros(size(f));
%下面的for循环开始进行合并.
for K=1:Lmax
    [vals,r,c]=qtgetblk(f,S,K);%使用函数qtgetblk，在四叉树分解中得到实际的四叉区域像素值。
    if ~isempty(vals)
        for I=1:length(r)
            xlow=r(I);
            ylow=c(I);
            xhigh=xlow+K-1;
            yhigh=ylow+K-1;
            region=f(xlow:xhigh,ylow:yhigh);
            flag=predicate2(region);
            if flag
                g(xlow:xhigh,ylow:yhigh)=1;
                MARKER(xlow,ylow)=1;
            end
        end
    end
end
g=bwlabel(imreconstruct(MARKER,g));%使用函数bwlabel获得每一个连接区域，并用不同的整数值标注。
g=g(1:M,1:N);
end

%本函数是splitmerge函数的一部分，它决定是否quardregion被分解，函数值返回v.
%逻辑值为真的应该被分解，否则不被分解。
%在每一块上进行分解测试，如果谓词函数predicate返回TRUE，该区域就被分解，v的适当的元素值就被置为true，否则置为false。
function v=split_test(B,mindim,fun)
K=size(B,3);
v(1:K)=false;
for I=1:K
    quadregion=B(:,:,I);
    if size(quadregion,1)<=mindim
        v(I)=false;
        continue
    end
    flag=feval(fun,quadregion);
    if flag
        v(I)=true;
    end
end
end

%本函数用来设置flag的值
function flag=predicate(region)
sd=std2(region);%计算标准偏差
flag=(sd>2);%sd标准偏差
end

function flag2=predicate2(region)
m=mean2(region);%计算平均值
flag2=(m<100);%m平均值范围。
end

function I_bw = ThresholdSplit(I)
level = graythresh(I);
disp(level);
I_bw = im2bw(I, level);
end


function I_out = RegionGrow(I)
set(0,'RecursionLimit', 500)
I = imresize(I, 0.1);
[M, N] = size(I);
thr = [50, 100, 150, 200, 250];
%pX = [fix(M/2-10+rand(1)*10), fix(M/2-10+rand(1)*10), fix(M/2-10+rand(1)*10), fix(M/2-10+rand(1)*10)];
%pY = [fix(N/2-10+rand(1)*10), fix(N/2-10+rand(1)*10), fix(N/2-10+rand(1)*10), fix(N/2-10+rand(1)*10)];
%x = fix(M/2-10+rand(1)*10);
%y = fix(N/2-10+rand(1)*10);
%I_out(x,y) = 1;
%I_out = FourConnection(I, I_out, x, y, thr(3),M,N);
I_out = zeros(M, N);
I_out(M/2,N/2) = 1;
I_out = FourConnection(I, I_out,M/2,N/2, thr(3), M, N);
%I_out = FourConnection(I, I_out, pX(2), pY(2), thr(3), M, N);
%I_out = FourConnection(I, I_out, pX(3), pY(3), thr(3), M, N);
end

function I_out = FourConnection(I_in, I_out, x, y, thr, M, N)
if(I_out(x-1, y) == 0 && I_in(x-1, y) <= thr)
    I_out(x-1, y) = 1;
    if(x<M-2 && y <N-2 && x > 2 && y > 2)
        I_out = FourConnection(I_in, I_out, x-1, y, thr,M ,N);
    end
end
if(I_out(x+1, y) == 0 && I_in(x+1, y) <= thr)
    I_out(x+1, y) = 1;
    if(x<M-2 && y <N-2&& x > 2 && y > 2)
        I_out = FourConnection(I_in, I_out, x+1, y, thr, M, N);
    end
end
if(I_out(x, y-1) == 0 && I_in(x, y-1) <= thr)
    I_out(x, y-1) = 1;
    if(x<M-2 && y <N-2&& x > 2 && y > 2)
        I_out = FourConnection(I_in, I_out, x, y-1, thr, M, N);
    end
end
if(I_out(x, y+1) == 0 && I_in(x, y+1) <= thr)
    I_out(x, y+1) = 1;
    if(x<M-2 && y <N-2&& x > 2 && y > 2)
        I_out = FourConnection(I_in, I_out, x, y+1, thr, M, N);
    end
end
end

