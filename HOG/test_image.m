%% 训练完成后保存 svmStruct即可对新输入的对象进行分类了无需再执行上面训练阶段代码  
clear all
load svmStruct  
test=imread('C:\Users\佳琪\Documents\MATLAB\id\target\original RGB pic\0250.jpg');  
     
im=imresize(test,[64,64]); 
% 老版本，调用hogcalculator和svmclassify

% figure;  
% imshow(im);  
% img=rgb2gray(im);  
% hogt =hogcalculator(img);  
% classes = svmclassify(svmStruct,hogt);%classes的值即为分类结果  

% 新版本，调用extractHOGFeatures和predict

features = extractHOGFeatures(im, 'CellSize', [8 8]);
predictedLabels = predict(svmStruct, features);