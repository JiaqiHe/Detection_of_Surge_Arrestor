%% 训练阶段  
ReadList1  = textread('pos_list.txt','%s','delimiter','\n');%载入正样本列表  
sz1=size(ReadList1);  
  
label1=ones(sz1(1),1); %正阳本标签  
ReadList2  = textread('neg_list.txt','%s','delimiter','\n');%载入负样本列表  
sz2=size(ReadList2);  
label2=zeros(sz2(1),1);%负样本标签  
label=[label1',label2']';%标签汇总  
total_num=length(label);  
data=zeros(total_num,1764);  

%读取正样本并计算hog特征  
for i=1:sz1(1)  
   name= char(ReadList1(i,1));  
   image=imread(strcat('C:\Users\佳琪\Documents\MATLAB\id\target\original RGB pic\',name)); 
   im=imresize(image,[64,64]);  
   img=rgb2gray(im);  
   hog =hogcalculator(img);  
   data(i,:)=hog;  
end  

%读取负样本并计算hog特征  
for j=1:sz2(1)  
   name= char(ReadList2(j,1));  
   image=imread(strcat('C:\Users\佳琪\Documents\MATLAB\id\negative_samples\original RGB pic\',name));  
   im=imresize(image,[64,64]);  
   img=rgb2gray(im);  
   hog =hogcalculator(img);  
   data(sz1(1)+j,:)=hog;  
end

error=zeros(1,10);
for i=1:10
    [train, test] = crossvalind('holdOut',length(label),0.9);
    cp = classperf(label);  
    svmStruct = svmtrain(data(train,:),label(train));  
    classes = svmclassify(svmStruct,data(test,:));  
    classperf(cp,classes,test);  
    error(1,i)=1-cp.CorrectRate;
end