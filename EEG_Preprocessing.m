function EEG = EEG_Preprocessing(EEG_Original)


for i=1:3    
    
%%小波去眼电噪声，并提取3.65到50.875Hz之间的信号
N=6;[C(:,i),L(:,i)]=wavedec(EEG_Original(:,i),N,'sym3');%sym3的小波函数与EOG的波形最相似
cd1(:,i)=detcoef(C(:,i),L(:,i),1);%101.25-200Hz
cd2(:,i)=detcoef(C(:,i),L(:,i),2);%50.875-101.25Hz
cd3(:,i)=detcoef(C(:,i),L(:,i),3);%25.6875-50.875hz
cd4(:,i)=detcoef(C(:,i),L(:,i),4);%13.09375-25.6825Hz
cd5(:,i)=detcoef(C(:,i),L(:,i),5);%6.796875-13.09375Hz
cd6(:,i)=detcoef(C(:,i),L(:,i),6);%3.65-6.79Hz
ca6(:,i)=appcoef(C(:,i),L(:,i),'sym3',6);%0.5-3.65Hz
Y6(:,i)=wrcoef('d',C(:,i),L(:,i),'sym3',6);
Y5(:,i)=wrcoef('d',C(:,i),L(:,i),'sym3',5);

if((mean(abs(Y6(:,i)))>20)) 
   cd6(:,i)=changewavedec(cd6(:,i)',length(cd6(:,i)),1.5,0.2)';
end
if((mean(abs(Y5(:,i)))>20)) 
   cd5(:,i)=changewavedec(cd5(:,i)',length(cd5(:,i)),1.5,0.2)';
end
Cc(:,i)=[ca6(:,i)
    cd6(:,i)
    cd5(:,i)
    cd4(:,i)
    cd3(:,i)
    cd2(:,i)
    cd1(:,i)];
Y6(:,i)=wrcoef('d',Cc(:,i),L(:,i),'sym3',6);
Y5(:,i)=wrcoef('d',Cc(:,i),L(:,i),'sym3',5);
Y4(:,i)=wrcoef('d',Cc(:,i),L(:,i),'sym3',4);
Y3(:,i)=wrcoef('d',Cc(:,i),L(:,i),'sym3',3);
Y(:,i)=Y3(:,i)+Y4(:,i)+Y5(:,i)+Y6(:,i);

%巴特沃斯带通滤波器提取α波
fs=200;
Fs=1000;    
y(:,i)=resample(Y(:,i),fs,Fs);   %重采样

N=65536; %2^16
fft_y(:,i)=fft(y(:,i),N);%进行fft变换
mag_y(:,i)=abs(fft_y(:,i));%求幅值
f_y(:,i)=(0:length(fft_y(:,i))-1)'*fs/length(fft_y(:,i));%进行对应的频率转换
% figure(3)
% subplot(2,1,1)
% plot(f_y,mag_y);%做频谱图

Wn=[7.5,14]/(fs/2);     %提取8-13Hzα波
[b,a]=butter(6,Wn);     %通过butter函数计算N阶巴特沃斯数字滤波器系统函数分子、分母多项式的系数向量b、a 系数按z的-1次幂的升幂排列
[h,f]=freqz(b,a,512,fs); %求数字低通滤波器的频率响应,使用n个样本点在整个单位圆计算频率响应
y1(:,i)=filter(b,a,y(:,i)); % 计算滤波后的波形

fft_y1(:,i)=fft(y1(:,i),N); % 滤波后波形的幅频响应
f_y1(:,i)=(0:length(fft_y1(:,i))-1)'*fs/length(fft_y1(:,i));%进行对应的频率转换


ifft_y(:,i)=real(ifft(fft_y(:,i)));
ifft_y1(:,i)=real(ifft(fft_y1(:,i)));

end

 ifft_y1([1:300],:)=[];   %截去前1.5秒（300个点）因巴特沃斯滤波造成的坏数据
 EEG = ifft_y1([1:60000],:);






