%% Train
clear;
clc
edge=28;
No_of_all_samples=200;
No_of_positive_samples=100;
x=cell(1,No_of_all_samples);
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
    x{i}=gray;
end

for i=(No_of_positive_samples+1):No_of_all_samples
    imagename=sprintf(formatSpec1,i-No_of_positive_samples);
    filepath=[path_neg imagename];
    pic=imread(filepath);
    pic=imresize(pic,[edge,edge]);  
    gray=rgb2gray(pic);
    gray=im2double(gray);
    x{i}=gray;
end

rng('default')

hiddenSize1 = 100;

autoenc1 = trainAutoencoder(x,hiddenSize1, ...
    'MaxEpochs',400, ...
    'L2WeightRegularization',0.004, ...
    'SparsityRegularization',4, ...
    'SparsityProportion',0.15, ...
    'ScaleData', false);

% plotWeights(autoenc1);

feat1 = encode(autoenc1,x);

hiddenSize2 = 50;
autoenc2 = trainAutoencoder(feat1,hiddenSize2, ...
    'MaxEpochs',100, ...
    'L2WeightRegularization',0.002, ...
    'SparsityRegularization',4, ...
    'SparsityProportion',0.1, ...
    'ScaleData', false);

feat2 = encode(autoenc2,feat1);

softnet = trainSoftmaxLayer(feat2,t,'MaxEpochs',400);

deepnet = stack(autoenc1,autoenc2,softnet);

% view(deepnet)

%% test

No_of_all_samples_test=200;
No_of_positive_samples_test=100;
x_test=cell(1,No_of_all_samples_test);
t_test=zeros(1,No_of_all_samples_test);
t_test(1,1:No_of_positive_samples_test)=1;

path_pos='C:\Users\¼Ñç÷\Documents\MATLAB\id\target\original RGB pic\';
path_neg='C:\Users\¼Ñç÷\Documents\MATLAB\id\negative_samples\original RGB pic\';
formatSpec1='%04d.jpg';

for i=1:No_of_positive_samples_test
    imagename=sprintf(formatSpec1,i+100);
    filepath=[path_pos imagename];
    pic=imread(filepath);
    pic=imresize(pic,[edge,edge]);  
    gray=rgb2gray(pic);
    gray=im2double(gray);
    x_test{i}=gray;
end

for i=(No_of_positive_samples_test+1):No_of_all_samples_test
    imagename=sprintf(formatSpec1,i-No_of_positive_samples_test+100);
    filepath=[path_neg imagename];
    pic=imread(filepath);
    pic=imresize(pic,[edge,edge]);  
    gray=rgb2gray(pic);
    gray=im2double(gray);
    x_test{i}=gray;
end

inputSize = edge*edge;

xTest = zeros(inputSize,numel(x_test));
for i = 1:numel(x_test)
    xTest(:,i) = x_test{i}(:);
end

y = deepnet(xTest);
plotconfusion(t_test,y);

%% fine tuning
xTrain = zeros(inputSize,numel(x));
for i = 1:numel(x)
    xTrain(:,i) = x{i}(:);
end

deepnet = train(deepnet,xTrain,t);

%% Test again
y = deepnet(xTest);
plotconfusion(t_test,y);

%save net deepnet