im=imread('left30.jpg');
width=size(im,1);
height=size(im,2);
im_neg=im;%用于创建负样本
%%find red areas
for  x=1:width
    for y=1:height
        %if(im(x,y,1)>100&&im(x,y,1)<255&&im(x,y,2)>0&&im(x,y,2)<130&&im(x,y,3)>0&&im(x,y,3)<130)
        if(im(x,y,1)>1.75*im(x,y,2)&&im(x,y,1)>1.75*im(x,y,3))
            bim(x,y)=true;
            im_neg(x,y,1)=255;%用于创建负样本
            im_neg(x,y,2)=255;%用于创建负样本
            im_neg(x,y,3)=255;%用于创建负样本
        else
            bim(x,y)=false;
            
        end
    end
end

%Mathematical Morphology method to adjust targeted area

dilateElement=strel('square', 12) ; %控制膨胀情况
erodeElement = strel('square', 5) ;  
bim = imerode(bim,erodeElement);  
bim=imdilate(bim, dilateElement);  
bim=imfill(bim,'holes');  
imshow(bim),title('Mathematical Morphology');
  
%获取区域的'basic'属性， 'Area', 'Centroid', and 'BoundingBox'   
figure('name','identification');
stats = regionprops(bim, 'basic');  
[C,area_index]=max([stats.Area]);
imshow(im);title('after'),hold on  
rectangle('Position',[stats(area_index).BoundingBox],'LineWidth',2,'LineStyle','--','EdgeColor','r');
hold off  

%%get original boundingbox
series=stats(area_index).BoundingBox;
x_min=series(1,1);
y_min=series(1,2);
width=series(1,3);
height=series(1,4);

%%rectify parameters so as to crop the target
amplification=1.2;
edge=fix(max(width,height)*amplification);
if width<height
    x_min=fix(max(x_min-(edge/2-width/2),0));
    y_min=fix(max(y_min-0.1*height,0));
else 
    x_min=fix(max(x_min-0.1*width),0);
    y_min=fix(max(y_min-(edge/2-height/2),0));
end
cropped_target=imcrop(im,[x_min,y_min,edge,edge]);
figure('name','Target');
imshow(cropped_target);
imwrite(cropped_target,'target.jpg');

cropped_target_neg=imcrop(im_neg,[x_min,y_min,edge,edge]);%用于创建负样本
figure('name','Target');%用于创建负样本
imshow(cropped_target_neg);%用于创建负样本
imwrite(cropped_target_neg,'target_neg.jpg');%用于创建负样本