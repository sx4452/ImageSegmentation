function ImageSplitRegionGrow
I = imread('multifighter.jpg');
I_out = ColorRegionGrow(I);
%I_out = GrayRegionGrow(I);
imwrite(I_out, 'multifighter_RegionGrow.jpg');
end

function I_out = ColorRegionGrow(I)
set(0,'RecursionLimit', 500)
I = im2double(I);
I = rgb2hsv(I);
I_h = I(:,:,1);
I_s = I(:,:,2);
I_v = I(:,:,3);
thrH = 0.5;
thrS = 0.1;
thrV = 0.3;
thr =  0.2*thrH + 0.1*thrS + 0.7*thrV;
I_weighted = I_h*0.2+I_s*0.1+I_v*0.7;
[M, N] = size(I(:,:,1));
seed = zeros(size(I_h));
x = [fix(M*0.44),fix(M*0.22),fix(M*0.32),fix(M*0.67)];
y = [fix(N*0.56),fix(N*0.21),fix(N*0.38),fix(N*0.42)];
for i = 1:4
    seed(x(i), y(i)) = 1;
end
[I_out, ~, ~, ~] = regiongrow(I_weighted,seed,thr);
imshow(I_out);
end

function I_out = GrayRegionGrow(I)
set(0,'RecursionLimit', 500)
I = rgb2gray(I);
[M, N] = size(I);
seed = zeros(size(I));
x = [fix(M*0.44),fix(M*0.22),fix(M*0.32),fix(M*0.67)];
y = [fix(N*0.56),fix(N*0.21),fix(N*0.38),fix(N*0.42)];
for i = 1:4
    seed(x(i), y(i)) = 1;
end
imshow(seed);
thr = 50;
[I_out, ~, ~, ~] = regiongrow(I,seed,thr);
imshow(I_out);
end

function [g, NR, SI, TI] = regiongrow(f, S, T)
%REGIONGROW Perform segmentation by region growing.
%   [G, NR, SI, TI] = REGIONGROW(F, SR, T).  S can be an array (the
%   same size as F) with a 1 at the coordinates of every seed point
%   and 0s elsewhere.  S can also be a single seed value. Similarly,
%   T can be an array (the same size as F) containing a threshold
%   value for each pixel in F. T can also be a scalar, in which
%   case it becomes a global threshold.   
%
%   On the output, G is the result of region growing, with each
%   region labeled by a different integer, NR is the number of
%   regions, SI is the final seed image used by the algorithm, and TI
%   is the image consisting of the pixels in F that satisfied the
%   threshold test. 
%   Copyright 2002-2004 R. C. Gonzalez, R. E. Woods, & S. L. Eddins
%   Digital Image Processing Using MATLAB, Prentice-Hall, 2004
%   $Revision: 1.4 $  $Date: 2003/10/26 22:35:37 $
f = double(f);
% If S is a scalar, obtain the seed image.
if numel(S) == 1
   SI = f == S;
   S1 = S;
else
   % S is an array. Eliminate duplicate, connected seed locations 
   % to reduce the number of loop executions in the following 
   % sections of code.
   SI = bwmorph(S, 'shrink', Inf);  
   J = find(SI);
   S1 = f(J); % Array of seed values.
end
TI = false(size(f));
for K = 1:length(S1)
   seedvalue = S1(K);
   S = abs(f - seedvalue) <= T;
   TI = TI | S;
end
% Use function imreconstruct with SI as the marker image to
% obtain the regions corresponding to each seed in S. Function
% bwlabel assigns a different integer to each connected region.
[g, NR] = bwlabel(imreconstruct(SI, TI));
end