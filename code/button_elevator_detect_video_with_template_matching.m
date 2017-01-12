clear;clc;clear mex
img_scale = 1/2;
v_resize = 50;
scale_cut = 0.1;
threshold_confid = 0.85;
confid_temp = [];
w_before = 0;
confid_sum = 0;

vid = VideoReader('./video_capture/test1.mp4');
pattern_up = imread('./pattern_productor/pattern_model_bw/pattern_up_model_bw.tiff');
pattern_down = imread('./pattern_productor/pattern_model_bw/pattern_down_model_bw.tiff');

fig = figure(1);
set(gcf,'outerposition',get(0,'screensize'));
idx = 80
%for idx = 1:vid.NumberOfFrames 
img = imresize(read(vid,idx),img_scale); 
img_gray = rgb2gray(img);
img_bw = img_gray >= 27; %im2bw
%img_bw = im2bw(img,graythresh(img));

Marker_size = 4 ;
se = strel('square',4);

img_bw_close = imclose(img_bw,se);
img_bw_open = imopen(img_bw_close,se);
img_bw_open = imfill(~img_bw_open,'holes');
[L,NUM] = bwlabel(logical(img_bw_open),4);

img = cat(3,img(:,:,1)',img(:,:,2)',img(:,:,3)');%rotation 90 deg

for i = 1:NUM
[r,c] = find(L == i);
eval(['r',num2str(i),'=r;']);
eval(['c',num2str(i),'=c;']);
end


subplot(1,4,1)

for i = 1:NUM
size_tune_r = round((max(eval(['r',num2str(i)])) - min(eval(['r',num2str(i)])))*scale_cut);
size_tune_c = round((max(eval(['c',num2str(i)])) - min(eval(['c',num2str(i)])))*scale_cut);

img_target = img_bw(min(eval(['r',num2str(i)]))+size_tune_r:max(eval(['r',num2str(i)]))-size_tune_r , min(eval(['c',num2str(i)]))+size_tune_c:max(eval(['c',num2str(i)]))-size_tune_c)';
img_target = imresize(img_target,[v_resize v_resize]);
eval(['img_target' num2str(i) '= img_target;']);
end

img_blank = ones(v_resize,10)';
pattern_show = [img_target1;img_blank;img_target2];
%imshow(img_bw_open(min(r2):max(r2),min(c2):max(c2))')
%imshow(img_bw_open')
imshow(pattern_show);


subplot(1,4,2)
pattern_show = [pattern_up;img_blank;pattern_down];
imshow(pattern_show);
%imshow(img_bw');




subplot(1,4,3)
%%%%%%%  XOR template_matching start %%%%%%%
pattern_up_xor = xor(img_target1,pattern_up);
pattern_up_xor = imclose(pattern_up_xor,se);
pattern_up_xor = imopen(pattern_up_xor,se);
confid(1,1) = length(find(pattern_up_xor == 0))/(size(pattern_up_xor,1)*size(pattern_up_xor,2));
pattern_up_xor11 = pattern_up_xor;

pattern_down_xor = xor(img_target1,pattern_down);
pattern_down_xor = imclose(pattern_down_xor,se);
pattern_down_xor = imopen(pattern_down_xor,se);
confid(1,2) = length(find(pattern_down_xor == 0))/(size(pattern_down_xor,1)*size(pattern_down_xor,2));
pattern_down_xor12 = pattern_down_xor;

pattern_up_xor = xor(img_target2,pattern_up);
pattern_up_xor = imclose(pattern_up_xor,se);
pattern_up_xor = imopen(pattern_up_xor,se);
confid(2,1) = length(find(pattern_up_xor == 0))/(size(pattern_up_xor,1)*size(pattern_up_xor,2));
pattern_up_xor21 = pattern_up_xor;

pattern_down_xor = xor(img_target2,pattern_down);
pattern_down_xor = imclose(pattern_down_xor,se);
pattern_down_xor = imopen(pattern_down_xor,se);
confid(2,2) = length(find(pattern_down_xor == 0))/(size(pattern_down_xor,1)*size(pattern_down_xor,2));
pattern_down_xor22 = pattern_down_xor;
imshow([pattern_up_xor11;img_blank;pattern_up_xor21])
subplot(1,4,4)
imshow([pattern_down_xor12;img_blank;pattern_down_xor22])
%{
if isempty(confid_temp)
    confid = confid;
else
    confid = confid*(1-w_before) + confid_temp*w_before;
end
confid_temp = confid;
confid_sum = confid_sum + confid;%for knowing avg of confid
confid_avg = confid_sum/idx
plot(idx,confid(1,1),'b.',idx,confid(1,2),'g.',idx,confid(2,1),'r.',idx,confid(2,2),'k.');
l = legend('img_t1 -> p_up','img_t1 -> p_down','img_t2 -> p_up','img_t2 -> p_down','Location','South');
set(l, 'Interpreter', 'none')
axis([0 vid.NumberOfFrames 0 1])
hold on
%}
%%%%%%%  XOR template_matching end %%%%%%%%%
%{
subplot(1,4,4)

imshow(img);

[v_confid,r_confid] = max(confid);
for c_confid = 1:size(v_confid,2)
    
if v_confid(c_confid) > threshold_confid
   state = c_confid;
else
   state = 0;
end  

switch state
    case 1
        hold on
        num_target = r_confid(c_confid);
        plot(mean(eval(['r',num2str(num_target)])),mean(eval(['c',num2str(num_target)])),'ro','MarkerSize',20);
        text(mean(eval(['r',num2str(num_target)])),mean(eval(['c',num2str(num_target)]))+50,'UP','Color','red','FontSize',10)
    case 2
        hold on
        num_target = r_confid(c_confid);
        plot(mean(eval(['r',num2str(num_target)])),mean(eval(['c',num2str(num_target)])),'ro','MarkerSize',20);
        text(mean(eval(['r',num2str(num_target)])),mean(eval(['c',num2str(num_target)]))+50,'DOWN','Color','red','FontSize',10)
end %switch

end
%}

%{
hold on
plot(mean(r1),mean(c1),'ro','MarkerSize',20);
text(mean(r1),mean(c1)+100,'UP','Color','red','FontSize',10)

hold on
plot(mean(r2),mean(c2),'ro','MarkerSize',20);
text(mean(r2),mean(c2)+100,'DOWN','Color','red','FontSize',10)
%}

%F(idx) = getframe(fig);
%end

%movie2avi(F,'button_up_down_detect_result.avi','compression','none','fps',30);

