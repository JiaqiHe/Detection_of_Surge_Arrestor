%% k折交叉检验     原理：西瓜书《机器学习》P26

clc
load indices_matrix
edge=28;
inputSize = edge*edge;
No_of_all_samples=1200;
No_of_positive_samples=600;
x=cell(1,No_of_all_samples);
t=zeros(1,No_of_all_samples);
t(1,1:No_of_positive_samples)=1;

path_pos='C:\Users\佳琪\Documents\MATLAB\id\target\original RGB pic\';
path_neg='C:\Users\佳琪\Documents\MATLAB\id\negative_samples\original RGB pic\';
formatSpec1='%04d.jpg';

for i=1:No_of_positive_samples
    imagename=sprintf(formatSpec1,i);%%%%%%%修改正样本的取值
    filepath=[path_pos imagename];
    pic=imread(filepath);
    pic=imresize(pic,[edge,edge]);  
    gray=rgb2gray(pic);
    gray=im2double(gray);
    x{i}=gray;
end

for i=(No_of_positive_samples+1):No_of_all_samples
    imagename=sprintf(formatSpec1,i-No_of_positive_samples);%%%%%修改负样本的取值
    filepath=[path_neg imagename];
    pic=imread(filepath);
    pic=imresize(pic,[edge,edge]);  
    gray=rgb2gray(pic);
    gray=im2double(gray);
    x{i}=gray;
end

xTrain = zeros(inputSize,numel(x));
for i = 1:numel(x)
    xTrain(:,i) = x{i}(:);
end
xTrain = xTrain';
t=t';

c=zeros(5,2);
for j=1:5        %execute 2-fold cross validation j times
    
    %indices = crossvalind('Kfold',t,2);
    %cp = classperf(t);
    indices = indices_matrix(:,j);

    for i = 1:2 
        test = (indices == i); train = ~test;
        c(j,i) = train_and_test(xTrain(train,:)',xTrain(test,:)',t(train,:)',t(test,:)');
    end

end

% error=zeros(1,10);
% indices=crossvalind('Kfold',t,10);
% for i=1:10
%     test = (indices == i); train = ~test;
%     error(1,i) = train_and_test(xTrain(train,:)',xTrain(test,:)',t(train,:)',t(test,:)');
% end
