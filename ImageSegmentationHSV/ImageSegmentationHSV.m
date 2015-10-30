function ImageSegmentationHSV
I = imread('book.jpg');
I = rgb2gray(I);
I = im2double(I);
I = 1.0 - I;
se = strel('disk', 10);
I_new = imtophat(I, se);
[row, col] = find(I_new>0.2);
I_out = zeros(size(I));
for i = 1:size(row)
    I_out(row(i),col(i)) = 1.0;
end
imwrite(I_out,'book_out.jpg');
end
