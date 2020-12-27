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
in((29.16*2000):(29.24*2000)) = in((29.16*2000):(29.24*2000))*0.02;


figure;
subplot(211)
plot(time,cuff);
axis([5,30,50,150])
subplot(212)
plot(time,in);
axis([5,30,-2,3])