function EEG = EEG_Preprocessing(EEG_Original)


for i=1:3    
    
%%С��ȥ�۵�����������ȡ3.65��50.875Hz֮����ź�
N=6;[C(:,i),L(:,i)]=wavedec(EEG_Original(:,i),N,'sym3');%sym3��С��������EOG�Ĳ���������
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

%������˹��ͨ�˲�����ȡ����
fs=200;
Fs=1000;    
y(:,i)=resample(Y(:,i),fs,Fs);   %�ز���

N=65536; %2^16
fft_y(:,i)=fft(y(:,i),N);%����fft�任
mag_y(:,i)=abs(fft_y(:,i));%���ֵ
f_y(:,i)=(0:length(fft_y(:,i))-1)'*fs/length(fft_y(:,i));%���ж�Ӧ��Ƶ��ת��
% figure(3)
% subplot(2,1,1)
% plot(f_y,mag_y);%��Ƶ��ͼ

Wn=[7.5,14]/(fs/2);     %��ȡ8-13Hz����
[b,a]=butter(6,Wn);     %ͨ��butter��������N�װ�����˹�����˲���ϵͳ�������ӡ���ĸ����ʽ��ϵ������b��a ϵ����z��-1���ݵ���������
[h,f]=freqz(b,a,512,fs); %�����ֵ�ͨ�˲�����Ƶ����Ӧ,ʹ��n����������������λԲ����Ƶ����Ӧ
y1(:,i)=filter(b,a,y(:,i)); % �����˲���Ĳ���

fft_y1(:,i)=fft(y1(:,i),N); % �˲����εķ�Ƶ��Ӧ
f_y1(:,i)=(0:length(fft_y1(:,i))-1)'*fs/length(fft_y1(:,i));%���ж�Ӧ��Ƶ��ת��


ifft_y(:,i)=real(ifft(fft_y(:,i)));
ifft_y1(:,i)=real(ifft(fft_y1(:,i)));

end

 ifft_y1([1:300],:)=[];   %��ȥǰ1.5�루300���㣩�������˹�˲���ɵĻ�����
 EEG = ifft_y1([1:60000],:);






