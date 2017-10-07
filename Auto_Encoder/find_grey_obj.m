function []=find_grey_obj(filepath,filename)

RGB=imread(filepath);
RGB_dupe=RGB;
HSV=rgb2hsv(RGB);
H=HSV(:,:,2);
width=size(H,1);
height=size(H,2);

H_min=0.08;
H_max=0.5;
for  x=1:width
    for y=1:height
        if (H(x,y)>H_min&&H(x,y)<H_max)
            H(x,y)=1;
        else
            H(x,y)=0;
        end
    end
end

H_boolean=bwareaopen(H,1500);
erodeElement = strel('square',3) ;  
dilateElement=strel('square',10) ; %¿ØÖÆÅòÕÍÇé¿ö
H_boolean=imerode(H_boolean,erodeElement);  
H_boolean=imdilate(H_boolean, dilateElement);  
H_boolean=imfill(H_boolean,'holes');  

for  x=1:width
    for y=1:height
        if (H_boolean(x,y)==false)||(RGB(x,y,1)>210||RGB(x,y,2)>210||...
           RGB(x,y,3)>210||RGB(x,y,1)<40||RGB(x,y,2)<40||RGB(x,y,3)<40)
            RGB(x,y,1)=255;
            RGB(x,y,2)=255;
            RGB(x,y,3)=255; 
            H_boolean(x,y)=false;
        else
            H_boolean(x,y)=true;
        end
    end
end
% figure('name','selected RGB areas');
% imshow(RGB);


erodeElement = strel('square',3) ;  
dilateElement=strel('square',15) ; %¿ØÖÆÅòÕÍÇé¿ö
H_boolean=imerode(H_boolean,erodeElement);  
H_boolean=imdilate(H_boolean, dilateElement);  
H_boolean=imfill(H_boolean,'holes');  
% figure('name','S_boolean after MM');
% imshow(H_boolean),title('Mathematical Morphology');

stats = regionprops(H_boolean, 'basic');  
[~,area_index]=max([stats.Area]);
% figure('name','processed S with rect');
% imshow(H);title('after process of S'),
% hold on  
% rectangle('Position',[stats(area_index).BoundingBox],'LineWidth',2,'LineStyle','--','EdgeColor','r');
% hold off

%%get original boundingbox
series=stats(area_index).BoundingBox;
x_min=series(1,1);
y_min=series(1,2);
width=series(1,3);
height=series(1,4);

%%rectify parameters so as to crop the target
amplification=0.9;%%%%%%%%%%%%%%%%%change the box amplification ratio here
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
pathname1='C:\Users\¼Ñç÷\Documents\MATLAB\id\negative_samples\original RGB pic\';
pathfile1=[pathname1 filename];
imwrite(cropped_target_original,pathfile1,'jpg');

%%crop the processed RGB pic
cropped_target_processed=imcrop(RGB,[x_min,y_min,edge,edge]);
%figure('name','cropped target in processed RGB pic');
%imshow(cropped_target_processed);
pathname2='C:\Users\¼Ñç÷\Documents\MATLAB\id\negative_samples\processed RGB pic\';
pathfile2=[pathname2 filename];
imwrite(cropped_target_processed,pathfile2,'jpg');

%%crop the processed S_boolean pic
H_boolean=bwareaopen(H,1500);
cropped_target_S_boolean=imcrop(H_boolean,[x_min,y_min,edge,edge]);
%figure('name','cropped target in processed S_boolean pic');
%imshow(cropped_target_S_boolean);
pathname3='C:\Users\¼Ñç÷\Documents\MATLAB\id\negative_samples\processed S_boolean pic\';
pathfile3=[pathname3 filename];
imwrite(cropped_target_S_boolean,pathfile3,'jpg');