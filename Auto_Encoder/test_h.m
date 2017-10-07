function []=test_h(filepath,filename)

RGB=imread(filepath);
RGB=imresize(RGB,[640,640]);
RGB_dupe=RGB;
HSV=rgb2hsv(RGB);
H=HSV(:,:,1);
width=size(H,1);
height=size(H,2);

H_threshold=0.05;
for  x=1:width
    for y=1:height
        if H(x,y)<H_threshold
            H(x,y)=1;
        else
            H(x,y)=0;
        end
    end
end

% subplot(2,2,1),imshow(H);title('（a）二值化后的H图像');
H_boolean=bwareaopen(H,500);
% subplot(2,2,2),imshow(H_boolean);title('（b）去除零散像素点后的二值图像');
erodeElement = strel('square',3) ;  
dilateElement=strel('square',10) ; %控制膨胀情况
H_boolean=imerode(H_boolean,erodeElement);  
H_boolean=imdilate(H_boolean, dilateElement);  
H_boolean=imfill(H_boolean,'holes');  
% subplot(2,2,3),imshow(H_boolean);title('（c）数学形态学处理后的目标');
RGB_ratio=1.3;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%change the RGB ratio here: RGB ratio = R/G and R/B
for  x=1:width
    for y=1:height
        if (H_boolean(x,y)==false)||(RGB(x,y,1)<RGB_ratio*RGB(x,y,2)||RGB(x,y,1)<RGB_ratio*RGB(x,y,3))
            RGB(x,y,1)=255;
            RGB(x,y,2)=255;
            RGB(x,y,3)=255; 
            H_boolean(x,y)=0;
        else
            H_boolean(x,y)=true;
        end
    end
end

for  x=1:width
    for y=1:height
        if ~(RGB(x,y,1)==255&&RGB(x,y,2)==255&&RGB(x,y,3)==255)
            H_boolean(x,y)=true;
        else
            H_boolean(x,y)=false;
        end
    end
end
%figure('name','selected RGB areas');
%imshow(RGB);
% subplot(2,2,4);imshow(RGB);title('（d）处理后的RGB图像');

erodeElement = strel('square',3) ;  
dilateElement=strel('square',10) ; %控制膨胀情况
H_boolean=imerode(H_boolean,erodeElement);  
H_boolean=imdilate(H_boolean, dilateElement);  
H_boolean=imfill(H_boolean,'holes');  
%figure('name','S_boolean after MM');
%imshow(H_boolean),title('Mathematical Morphology');

stats = regionprops(H_boolean, 'basic');  
[~,area_index]=max([stats.Area]);
figure('name','processed S with rect');
figure;
%subplot(1,3,1);
imshow(RGB_dupe);title('（a）算法发现的目标区域'),
hold on  
rectangle('Position',[stats(area_index).BoundingBox],'LineWidth',2,'LineStyle','--','EdgeColor','r');
hold off

%%get original boundingbox
series=stats(area_index).BoundingBox;
x_min=series(1,1);
y_min=series(1,2);
width=series(1,3);
height=series(1,4);

%%rectify parameters so as to crop the target
amplification=1.05;%%%%%%%%%%%%%%%%%change the box amplification ratio here
edge=fix(max(width,height)*amplification);
if width<height
    x_min=fix(max(x_min-(edge/2-width/2),0));
    y_min=fix(max(y_min-(amplification-1)/2*height,0));
else 
    x_min=fix(max(x_min-(amplification-1)/2*width,0));
    y_min=fix(max(y_min-(edge/2-height/2),0));
end


%%crop the original RGB pic and save into directed directory
cropped_target_original=imcrop(RGB_dupe,[x_min,y_min,edge,edge]);
%figure('name','cropped target in original RGB pic');
% subplot(1,3,2);
% imshow(cropped_target_original);title('（b）原始图片样本');
pathname1='C:\Users\佳琪\Documents\MATLAB\id\target\original RGB pic\';
pathfile1=[pathname1 filename];
imwrite(cropped_target_original,pathfile1,'jpg');

%%crop the processed RGB pic
cropped_target_processed=imcrop(RGB,[x_min,y_min,edge,edge]);
%figure('name','cropped target in processed RGB pic');
% subplot(1,3,3);
% imshow(cropped_target_processed);title('（c）处理后图片样本');
pathname2='C:\Users\佳琪\Documents\MATLAB\id\target\processed RGB pic\';
pathfile2=[pathname2 filename];
imwrite(cropped_target_processed,pathfile2,'jpg');

%%crop the processed S_boolean pic
H_boolean=bwareaopen(H,1500);
cropped_target_S_boolean=imcrop(H_boolean,[x_min,y_min,edge,edge]);
%figure('name','cropped target in processed S_boolean pic');
%imshow(cropped_target_S_boolean);
pathname3='C:\Users\佳琪\Documents\MATLAB\id\target\processed S_boolean pic\';
pathfile3=[pathname3 filename];
imwrite(cropped_target_S_boolean,pathfile3,'jpg');