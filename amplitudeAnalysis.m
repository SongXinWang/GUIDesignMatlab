clc
clear all
close all

data = load('04_r3.csv'); % 3M Mumrane
% len = length(data)-1;
% time = 0:(len/2000)/len:len/2000;
Fs = 2000;
F1 = 50;
F2 = 400;
DT = 40;
OVERLAP = 0.95; % enhance the resolution of time
FFTNUMBER = 8;  % enhance the resolution of frequency

cuff = data(:,1);
in =  data(:,4);
out = data(:,5);

%%---- Analysis MAX Amplitude
start = 25; %s
stop  = 60; %s
duration = stop-start;
waveLen  = duration*2000; 
time     = 0:(duration)/(waveLen-1):(stop-start);


timeLong = (start*2000):(stop*2000-1);
cuff     = (cuff(timeLong)-1)*100;
in       = in(timeLong);
out      = out(timeLong);

for i = 25.7*2000 : length(in)
    if abs(in(i))>= 0.05
        in(i)=in(i)*0.1;
    end
end
% in((25.7*2000):end) = in((25.7*2000):end)*0.02;
during = 1:29*2000;

figure;
subplot(211)
plot(time(during),cuff(during));
axis([5,29,50,150])
subplot(212)
plot(time(during),in(during));
axis([5,29,-2,3])
% subplot(313)
% plot(time,out);
% axis([5,30,-2,3]);

a=a;

% filterOrder = 7;
% b = ones(filterOrder, 1)/filterOrder;
% a = 1;
% ch2f = filtfilt(b, a, in);
% ch3f = filtfilt(b, a, out);

% plot(out);
% hold on
% plot(ch3f,'r');


peakValueNorMean = zeros(1,6);
% --------------- find maxAmplitude on CH2
MPH = 0.1;
MPD = 1000;
[peakValue2,peakLocation2]=findpeaks(in,'MINPEAKHEIGHT',MPH,'MINPEAKDISTANCE',MPD);
[peakValue21,peakLocation21]=findpeaks(-in,'MINPEAKHEIGHT',MPH,'MINPEAKDISTANCE',MPD);

peakLocation2(end-6:end)=[];
peakLocation21(end-3:end)=[];

peakLocation2(28:33) = [51226 52562 53928 55326 56714 58076];
peakLocation21(28:33) = [51168 52495 53871 55356 56667 58032];

% plot(in);
% hold on
% plot(peakLocation2,in(peakLocation2),'+r');
% plot(peakLocation21,in(peakLocation21),'+k');
% % plot(ch3f,'c');
% hold off

subplot(211)
plot(time,in);
hold on
plot(peakLocation2/Fs,in(peakLocation2),'r');
plot(peakLocation21/Fs,in(peakLocation21),'r');
plot(peakLocation2/Fs,in(peakLocation2)-in(peakLocation21));
axis([5,30,-2,3])%
hold off


[peakValue3,peakLocation3]=findpeaks(out,'MINPEAKHEIGHT',MPH,'MINPEAKDISTANCE',MPD);
[peakValue31,peakLocation31]=findpeaks(-out,'MINPEAKHEIGHT',MPH,'MINPEAKDISTANCE',MPD);
peakLocation3(1:2)=[];
peakLocation3(end-4:end)=[];
peakLocation31(1)=[];
peakLocation31(end-4:end)=[];

peakLocation3(23:25) = [44535 45829 47136];
peakLocation31(23:25) = [44501 45813 47112];


subplot(212)
plot(time,out);
hold on
plot(peakLocation3/Fs,out(peakLocation3),'r');
plot(peakLocation31/Fs,out(peakLocation31),'r');
plot(peakLocation3/Fs,out(peakLocation3)-out(peakLocation31));
axis([5,30,-2,3])%
hold off

figure
plot(peakLocation3/Fs,out(peakLocation3)-out(peakLocation31));
hold on
plot(peakLocation2/Fs,in(peakLocation2)-in(peakLocation21));
axis([5,30,-2,3])%
hold off




