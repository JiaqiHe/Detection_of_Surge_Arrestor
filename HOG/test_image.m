%% ѵ����ɺ󱣴� svmStruct���ɶ�������Ķ�����з�����������ִ������ѵ���׶δ���  
clear all
load svmStruct  
test=imread('C:\Users\����\Documents\MATLAB\id\target\original RGB pic\0250.jpg');  
     
im=imresize(test,[64,64]); 
% �ϰ汾������hogcalculator��svmclassify

% figure;  
% imshow(im);  
% img=rgb2gray(im);  
% hogt =hogcalculator(img);  
% classes = svmclassify(svmStruct,hogt);%classes��ֵ��Ϊ������  

% �°汾������extractHOGFeatures��predict

features = extractHOGFeatures(im, 'CellSize', [8 8]);
predictedLabels = predict(svmStruct, features);