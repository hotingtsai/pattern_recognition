clear;clc;
gray_scale = 255;
img_scale = 1/2;
filename = 'pattern_down';
v_resize = 50;
scale_cut = 0.15;


img = imresize(imread(strcat('./pattern_model/',filename,'.jpg')),img_scale);
%img = imread('test.jpg');
img_gray = rgb2gray(img);

figure(1)
img_gray_raw = [];
for n=1:size(img_gray,1)
img_gray_raw = [img_gray_raw img_gray(n,:)];
end
[n_img_gray_raw,gray_value]=hist(double(img_gray_raw),gray_scale);
hist(double(img_gray_raw),gray_scale)
hold on
plot(round(gray_value),n_img_gray_raw,'g')
set(gca,'XLim',[0 255]);

figure(2)
img_bw = img_gray >= 27; %im2bw(up)
%img_bw = img_gray >= 120; %im2bw(down)
img_bw = imresize(img_bw,[v_resize v_resize]);
img_bw = img_bw(1+round(v_resize*scale_cut) : v_resize-round(v_resize*scale_cut),1+round(v_resize*scale_cut) : v_resize-round(v_resize*scale_cut));
img_bw = imresize(img_bw,[v_resize v_resize]);
imshow(img_bw);
imwrite(img_bw,strcat('./pattern_model_bw/',filename,'_model_bw.tiff'),'TIFF');
