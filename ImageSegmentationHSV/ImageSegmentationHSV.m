function ImageSegmentationHSV
I = imread('book.jpg');
I = rgb2gray(I);
I = im2double(I);
I = 1.0 - I;
se = strel('disk', 10);
I_out = imtophat(I, se);
imwrite(I_out,'book_out.jpg');
end
