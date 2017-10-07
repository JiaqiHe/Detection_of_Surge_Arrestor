clc; 
clear ;  
%% ѵ���׶� 
fileID1 = fopen('pos_list.txt','r');
ReadList1  = textscan(fileID1,'%s');%�����������б�  
sz1=size(ReadList1{1});  
  
label1=ones(sz1(1),1); %��������ǩ  

fileID2 = fopen('neg_list.txt','r');
ReadList2  = textscan(fileID2,'%s','Delimiter','\n');%���븺�����б�  
sz2=size(ReadList2{1});  
label2=zeros(sz2(1),1);%��������ǩ  
label=[label1',label2']';%��ǩ����  
total_num=length(label);

cellSize = [8 8];
hogFeatureSize = 1764;
data=zeros(total_num,hogFeatureSize);  

%��ȡ������������hog����  
for i=1:sz1(1)  
   name= char(ReadList1{1}{i});  
   image=imread(strcat('C:\Users\����\Documents\MATLAB\id\target\original RGB pic\',name)); 
   img=imresize(image,[64,64]);  
   data(i,:)=extractHOGFeatures(img, 'CellSize', cellSize);
end  

%��ȡ������������hog����  
for j=1:sz2(1)  
   name= char(ReadList2{1}{j});  
   image=imread(strcat('C:\Users\����\Documents\MATLAB\id\negative_samples\original RGB pic\',name));  
   img=imresize(image,[64,64]);   
   data(sz1(1)+j,:)=extractHOGFeatures(img, 'CellSize', cellSize);
end  

[train, test] = crossvalind('holdOut',length(label),0.5);  
cp = classperf(label);  
svmStruct = fitcecoc(data(train,:),label(train));
[classes,initial_states,~] = predict(svmStruct, data(test,:));
classperf(cp,classes,test);
%confMat = confusionmat(label(test), classes);
cp.CorrectRate   
