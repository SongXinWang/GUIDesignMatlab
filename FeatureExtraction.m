function Fea = FeatureExtraction(MK)
EEG_Original =MK(:,6:8);%选择三导脑电信号
l=MK(1,10);
EEG_Processed = EEG_Preprocessing(EEG_Original);%EEG预处理
EEG_Fp1_O=EEG_Original(1:30001,1);%预处理后alpha波形图
N1=size(EEG_Fp1_O);
tscale=200;
dt1=tscale./200000;
EEG_Fp1=EEG_Processed(2000:8000,1);%预处理后alpha波形图
N2=size(EEG_Fp1);
tscale=300;
dt2=tscale./60000;
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
    SEn_single(i,1)=SampEn_fast(w_y1(i,:), m, r);
    SEn_single(i,2)=SampEn_fast(w_y2(i,:), m, r);
    SEn_single(i,3)=SampEn_fast(w_y3(i,:), m, r);
    
    FEn_single(i,1)=Fuzzy_Entropy(m, r, w_y1(i,:));
    FEn_single(i,2)=Fuzzy_Entropy(m, r, w_y2(i,:));
    FEn_single(i,3)=Fuzzy_Entropy(m, r, w_y3(i,:));  
end


 Fea(1,1)= l;
 Fea(1,2:4)=mean(APEn_single);
 Fea(1,5:7)=mean(SEn_single);
 Fea(1,8:10)=mean(FEn_single);
end


