function ImageSplitRegionGrow
I = imread('multifighter.jpg');
%I_out = ColorRegionGrow(I);
I_out = GrayRegionGrow(I);
imwrite(I_out, 'multifighter_RegionGrow.jpg');
end

function I_out = ColorRegionGrow(I)
set(0,'RecursionLimit', 500)
I = im2double(I);
I = rgb2hsv(I);
I = imresize(I, 0.1);
I_h = I(:,:,1);
I_s = I(:,:,2);
I_v = I(:,:,3);
thrH = 0.5;
thrS = 0.1;
thrV = 0.4;
thr =  0.2*thrH + 0.1*thrS + 0.7*thrV;
I_weighted = I_h*0.2+I_s*0.1+I_v*0.7;
[M, N] = size(I(:,:,1));
I_out = zeros(M, N);
x = fix(M*0.44);
y = fix(N*0.56);
I_out(x, y) = 1;
I_out = FourConnection(I_weighted, I_out,x,y, thr, M, N);
end

function I_out = GrayRegionGrow(I)
set(0,'RecursionLimit', 500)
I = rgb2gray(I);
I = imresize(I, 0.1);
[M, N] = size(I);
thr = [50, 100, 150, 200, 250];
I_out = zeros(M, N);
I_out(M/2,N/2) = 1;
I_out = FourConnection(I, I_out,M/2,N/2, thr(3), M, N);
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