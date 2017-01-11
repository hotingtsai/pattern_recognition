clear all;
close all;
clc;
run('C:\Users\hotin\Desktop\CV project\vlfeat-0.9.20/toolbox/vl_setup')
% pattern = single(rgb2gray(imread('C:\Users\hotin\Desktop\CV project\pattern_productor\pattern_model\pattern_up_2.jpg')));
% image = single(rgb2gray(imread('C:\Users\hotin\Desktop\CV project\test.jpg')));
% pattern = rgb2gray(imread('C:\Users\hotin\Desktop\CV project\pattern_productor\pattern_model\pattern_up_2.jpg'));
% image = rgb2gray(imread('C:\Users\hotin\Desktop\CV project\test.jpg'));

vid = VideoReader('C:\Users\hotin\Desktop\CV project\video_capture/test4.mp4');
frame_num = vid.NumberOfFrames;
%%
pattern = rgb2gray(read(vid,1));
% image = rgb2gray(read(vid,180));

% figure(1); imshow(pattern); hold on;
% figure(2); imshow(image); hold on;
tic
parfor i = 1:frame_num
    frame = rgb2gray(read(vid,i));
    T{i} = TFmatrix(pattern, frame, 'SURF');
    i
end
toc
t_total = toc

%%
% pattern_center = [123 68 1; 131 296 1; 317 67 1; 321 293 1; 516 64 1; 514 294 1];
pattern_center = [115 52 1; 122 294 1; 319 52 1; 322 292 1; 525 54 1; 523 295 1];
% pattern_center = [756 399 1; 750 696 1; 1156 409 1; 1158 684 1; 1531 414 1; 1534 687 1];
% pattern_center = [1025 88 1; 759 284 1; 1028 473 1; 774 655 1; 1026 830 1; 786 1008 1];
% figure(1); imshow(pattern); hold on;
% plot([pattern_center(1,1) pattern_center(2,1) pattern_center(3,1) pattern_center(4,1) pattern_center(5,1) pattern_center(6,1)],...
%     [pattern_center(1,2) pattern_center(2,2) pattern_center(3,2) pattern_center(4,2) pattern_center(5,2) pattern_center(6,2)], 'o', 'MarkerSize', 10);
figure(2); imshow(rgb2gray(read(vid,1))); hold on;
writerObj=VideoWriter('pattern_recognition4.mp4','MPEG-4');
writerObj.FrameRate=15; % ½Õ¾ãframerate
open(writerObj);

for j = 1:frame_num
    pattern_recog{1,j} = T{j}*pattern_center(1,:)';
    pattern_recog{2,j} = T{j}*pattern_center(2,:)';
    pattern_recog{3,j} = T{j}*pattern_center(3,:)';
    pattern_recog{4,j} = T{j}*pattern_center(4,:)';
    pattern_recog{5,j} = T{j}*pattern_center(5,:)';
    pattern_recog{6,j} = T{j}*pattern_center(6,:)';
    
    figure(2);
    imshow(read(vid,j));

    plot([pattern_recog{1,j}(1,1) pattern_recog{2,j}(1,1) pattern_recog{3,j}(1,1) pattern_recog{4,j}(1,1) pattern_recog{5,j}(1,1) pattern_recog{6,j}(1,1)], ...
        [pattern_recog{1,j}(2,1), pattern_recog{2,j}(2,1), pattern_recog{3,j}(2,1), pattern_recog{4,j}(2,1), pattern_recog{5,j}(2,1), pattern_recog{6,j}(2,1)], 'ro', 'MarkerSize', 50, 'LineWidth', 3);
%     text(double(pattern_recog{1,j}(1,1)),double(pattern_recog{1,j}(2,1)),'9','Color','red','FontSize',40,'FontWeight','bold','HorizontalAlignment','center');
%     text(double(pattern_recog{2,j}(1,1)),double(pattern_recog{2,j}(2,1)),'4','Color','red','FontSize',40,'FontWeight','bold','HorizontalAlignment','center');
%     text(double(pattern_recog{3,j}(1,1)),double(pattern_recog{3,j}(2,1)),'7','Color','red','FontSize',40,'FontWeight','bold','HorizontalAlignment','center');
%     text(double(pattern_recog{4,j}(1,1)),double(pattern_recog{4,j}(2,1)),'2','Color','red','FontSize',40,'FontWeight','bold','HorizontalAlignment','center');
%     text(double(pattern_recog{5,j}(1,1)),double(pattern_recog{5,j}(2,1)),'5','Color','red','FontSize',40,'FontWeight','bold','HorizontalAlignment','center');
%     text(double(pattern_recog{6,j}(1,1)),double(pattern_recog{6,j}(2,1)),'B1','Color','red','FontSize',30,'FontWeight','bold','HorizontalAlignment','center');
    text(double(pattern_recog{1,j}(1,1)),double(pattern_recog{1,j}(2,1)),'UP','Color','red','FontSize',40,'FontWeight','bold','HorizontalAlignment','center');
    text(double(pattern_recog{2,j}(1,1)),double(pattern_recog{2,j}(2,1)),'DOWN','Color','red','FontSize',40,'FontWeight','bold','HorizontalAlignment','center');
    text(double(pattern_recog{3,j}(1,1)),double(pattern_recog{3,j}(2,1)),'C','Color','red','FontSize',40,'FontWeight','bold','HorizontalAlignment','center');
    text(double(pattern_recog{4,j}(1,1)),double(pattern_recog{4,j}(2,1)),'O','Color','red','FontSize',40,'FontWeight','bold','HorizontalAlignment','center');
    text(double(pattern_recog{5,j}(1,1)),double(pattern_recog{5,j}(2,1)),'5','Color','red','FontSize',40,'FontWeight','bold','HorizontalAlignment','center');
    text(double(pattern_recog{6,j}(1,1)),double(pattern_recog{6,j}(2,1)),'B1','Color','red','FontSize',30,'FontWeight','bold','HorizontalAlignment','center');
    pause(0.01);
    F = getframe(gca);
    writeVideo(writerObj,F);
end

close(writerObj);
