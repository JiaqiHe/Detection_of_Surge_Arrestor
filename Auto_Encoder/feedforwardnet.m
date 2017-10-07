clear;
clc
edge=16;
No_of_all_samples=50;
No_of_positive_samples=25;
x=zeros(edge*edge,No_of_all_samples);
t=zeros(1,No_of_all_samples);
t(1,1:No_of_positive_samples)=1;

path_pos='C:\Users\¼Ñç÷\Documents\MATLAB\id\target\original RGB pic\';
path_neg='C:\Users\¼Ñç÷\Documents\MATLAB\id\negative_samples\original RGB pic\';
formatSpec1='%04d.jpg';

for i=1:No_of_positive_samples
    imagename=sprintf(formatSpec1,i);
    filepath=[path_pos imagename];
    pic=imread(filepath);
    pic=imresize(pic,[edge,edge]);  
    gray=rgb2gray(pic);
    gray=im2double(gray);
    gray=gray(:);
    x(:,i)=gray;
end

for i=(No_of_positive_samples+1):No_of_all_samples
    imagename=sprintf(formatSpec1,i-No_of_positive_samples);
    filepath=[path_neg imagename];
    pic=imread(filepath);
    pic=imresize(pic,[edge,edge]);  
    gray=rgb2gray(pic);
    gray=im2double(gray);
    gray=gray(:);
    x(:,i)=gray;
end


net=feedforwardnet(50);
net=train(net,x,t);
