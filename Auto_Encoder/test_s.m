function []=test_s(filepath)

RGB=imread(filepath);
RGB_dupe=RGB;
HSV=rgb2hsv(RGB);
S=HSV(:,:,2);
width=size(S,1);
height=size(S,2);

S_threshold=0.4;
for  x=1:width
    for y=1:height
        if S(x,y)<S_threshold
            S(x,y)=0;
        end
    end
end

S_boolean=bwareaopen(S,1500);
erodeElement = strel('square',3) ;  
dilateElement=strel('square',10) ; %¿ØÖÆÅòÕÍÇé¿ö
S_boolean=imerode(S_boolean,erodeElement);  
S_boolean=imdilate(S_boolean, dilateElement);  
S_boolean=imfill(S_boolean,'holes');  
figure('name','S_boolean after MM');
imshow(S_boolean),title('Mathematical Morphology');

stats = regionprops(S_boolean, 'basic');  
[C,area_index]=max([stats.Area]);
figure('name','processed S with rect');
imshow(S);title('after process of S'),
hold on  
rectangle('Position',[stats(area_index).BoundingBox],'LineWidth',2,'LineStyle','--','EdgeColor','r');
hold off


RGB_ratio=1.35;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%change the RGB ratio here: RGB ratio = R/G and R/B
for  x=1:width
    for y=1:height
        if (S_boolean(x,y)==false)||(RGB(x,y,1)<RGB_ratio*RGB(x,y,2)||RGB(x,y,1)<RGB_ratio*RGB(x,y,3)||RGB(x,y,1)<27)
            RGB(x,y,1)=255;
            RGB(x,y,2)=255;
            RGB(x,y,3)=255;            
        end
    end
end
figure('name','selected RGB areas');
imshow(RGB);

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
%imshow(cropped_target_original);
pathname1='C:\Users\¼Ñç÷\Documents\MATLAB\id\target\original RGB pic\';
filename='001.jpg';
pathfile1=[pathname1 filename];
imwrite(cropped_target_original,pathfile1,'jpg');

%%crop the processed RGB pic
cropped_target_processed=imcrop(RGB,[x_min,y_min,edge,edge]);
%figure('name','cropped target in processed RGB pic');
%imshow(cropped_target_processed);
pathname2='C:\Users\¼Ñç÷\Documents\MATLAB\id\target\processed RGB pic\';
pathfile2=[pathname2 filename];
imwrite(cropped_target_processed,pathfile2,'jpg');

%%crop the processed S pic
cropped_target_S=imcrop(S,[x_min,y_min,edge,edge]);
%figure('name','cropped target in processed RGB pic');
%imshow(cropped_target_S);
pathname3='C:\Users\¼Ñç÷\Documents\MATLAB\id\target\processed S pic\';
pathfile3=[pathname3 filename];
imwrite(cropped_target_S,pathfile3,'jpg');

%%crop the processed S_boolean pic
S_boolean=bwareaopen(S,1500);
cropped_target_S_boolean=imcrop(S_boolean,[x_min,y_min,edge,edge]);
%figure('name','cropped target in processed S_boolean pic');
%imshow(cropped_target_S_boolean);
pathname4='C:\Users\¼Ñç÷\Documents\MATLAB\id\target\processed S_boolean pic\';
pathfile4=[pathname4 filename];
imwrite(cropped_target_S_boolean,pathfile4,'jpg');