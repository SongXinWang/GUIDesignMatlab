clc
clear

load 10.mat;
EEG_Original =MK(:,6:8);%选择三导脑电信号
l=MK(1,10);

%% EEG预处理及作图
EEG_Processed = EEG_Preprocessing(EEG_Original);%EEG预处理

EEG_Fp1_O=EEG_Original(1:30001,1);%预处理后alpha波形图
N1=size(EEG_Fp1_O);
tscale=200;
dt1=tscale./200000;
t1=0:dt1:(N1-1).*dt1;
figure
subplot(2,1,1)
plot(t1,EEG_Fp1_O);
title('Original EEG');
ylabel('Amplitude(μV)');
xlabel('Time(sec)');
h=gca;
set(h,'FontSize',12);

EEG_Fp1=EEG_Processed(2000:8000,1);%预处理后alpha波形图
N2=size(EEG_Fp1);

tscale=300;
dt2=tscale./60000;
t2=0:dt2:(N2-1).*dt2;

subplot(2,1,2)
plot(t2,EEG_Fp1);
title('Processed Alpha Band');
ylabel('Amplitude(μV)');
axis([-inf,inf,-20,20]);
xlabel('Time(sec)');
h=gca;
set(h,'FontSize',12);

%% 特征提取
Fea = zeros(1,12);

 y1=EEG_Processed(:,1); %读取三个通道的脑电信号
 y2=EEG_Processed(:,2);
 y3=EEG_Processed(:,3);

  %熵计算
  m=3;
  r=0.2;
  w_y1=zeros(30,2000);
  w_y2=zeros(30,2000);
  w_y3=zeros(30,2000);
  APEn_single=zeros(30,3);
  SEn_single=zeros(30,3);
  FEn_single=zeros(30,3);

for i=1:30                  %全信号可分为30段，进而求均值
    w_y1(i,:)=y1(2000*(i-1)+1:2000*i);
    w_y2(i,:)=y2(2000*(i-1)+1:2000*i);
    w_y3(i,:)=y3(2000*(i-1)+1:2000*i);
    
    APEn_single(i,1)=ApEn(m, r, w_y1(i,:));
    APEn_single(i,2)=ApEn(m, r, w_y2(i,:));
    APEn_single(i,3)=ApEn(m, r, w_y3(i,:));
%      
    
    SEn_single(i,1)=SampEn_fast(w_y1(i,:), m, r);
    SEn_single(i,2)=SampEn_fast(w_y2(i,:), m, r);
    SEn_single(i,3)=SampEn_fast(w_y3(i,:), m, r);
    
    FEn_single(i,1)=Fuzzy_Entropy(m, r, w_y1(i,:));
    FEn_single(i,2)=Fuzzy_Entropy(m, r, w_y2(i,:));
    FEn_single(i,3)=Fuzzy_Entropy(m, r, w_y3(i,:));
%     
    
 
    
end


 Fea(1,1)= l;
 Fea(1,2:4)=mean(APEn_single);
 Fea(1,5:7)=mean(SEn_single);
 Fea(1,8:10)=mean(FEn_single);

 
 %% 抑郁识别
 load train_data.mat;
 data_train=train_data(:,2:10);
 label_train=train_data(:,1); 
 data_test=Fea(1,2:10);
 label_test=Fea(1,1); 
 
model = classRF_train(data_train,label_train);
[Predict_label(1,1),votes] = classRF_predict(data_test,model);

model = libsvmtrain(label_train,data_train,'-t 2 -c 181 -g 256');
[Predict_label(3,1),acc,~] = libsvmpredict(label_test,data_test,model);
  
     
knn = ClassificationKNN.fit(data_train, label_train,'Distance','seuclidean','NumNeighbors',2);%构建knn模型
[Predict_label(2,1), Scores] = predict(knn,data_test);%预测分类


