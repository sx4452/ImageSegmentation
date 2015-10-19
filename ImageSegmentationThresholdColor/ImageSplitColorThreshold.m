function ImageSplitThreshold
I = imread('multifighter.jpg');
I_out = ImageSplitColorThr(I);
%I_out = ThresholdSplit(I);
imwrite(I_out, 'multifighter_threshold.jpg');
end

function I_out = ImageSplitColorThr(I)
I = im2double(I);
I = rgb2hsv(I);
I = imresize(I, 1);
I_h = I(:,:,1);
I_s = I(:,:,2);
I_v = I(:,:,3);
thrH = 0.5;
thrS = 0.1;
thrV = 0.4;
thr =  0.2*thrH + 0.1*thrS + 0.7*thrV;
I_weighted = I_h*0.2+I_s*0.1+I_v*0.7;
[row col] = find(I_weighted < thr);
I_out = zeros(size(I_h));
for i = 1:size(row)
    I_out(row(i),col(i)) = 1;
end
end

function I_bw = ThresholdSplit(I)
I = rgb2gray(I);
level = graythresh(I);
disp(level);
I_bw = im2bw(I, level);
end
