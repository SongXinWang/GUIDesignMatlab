function PeakLoca = FindPeak2(x)
%FINDPEAK          Finding peaks

sL    = ceil(length(x)/10);
threT = zeros(10, 1);
for k = 1:10
    if k*sL > length(x)
        las = length(x);
    else
        las = k*sL;
    end
    xTemp    = x((k-1)*sL+1:las);
    sTemp    = sort(xTemp);
    threT(k) = mean(sTemp(end-20:end))*0.7; %0.8
end

% threshold
thre = min(threT);
temp = x;
temp(temp < thre) = thre;
dtemp = diff(temp);
peak1 = find(dtemp(1:end - 1).*dtemp(2:end) < 0) + 1;
peak1(diff(peak1) < 0.55*mean(diff(peak1))) = []; %0.55

% false negative
meanHR  = mean(diff(peak1));
newpeak = [];
indn    = find(diff(peak1) > 1.5*meanHR); % position of possibly missing beats 1.5
for k   = 1:length(indn)
    MissNum = ceil(length(peak1(indn(k)):peak1(indn(k) + 1)) / meanHR); % number of possibly missing beats
    for mn  = 1:MissNum
        fid = floor(peak1(indn(k)) + mn*1.2*meanHR);
        if fid  > length(x)
            fid = length(x);
        end
        tRR = x(floor(peak1(indn(k)) + (mn-1)*1.2*meanHR):fid);
        [maxn, indt] = max(temp(end-floor(0.4*meanHR):end));
        newpeak = [newpeak; indt + floor(peak1(indn(k)) + mn*1.2*meanHR) - floor(0.4*meanHR) - 1];
    end
end
peak2 = sort([peak1; newpeak]);

% false positive
peak3 = peak2;
peak3(diff(peak3) < 0.7*mean(diff(peak3))) = [];

% real peak
PeakLoca = [];
for k   = 1:length(peak3)
    inf = peak3(k) - 300;
    if inf  < 1
        inf = 1;
    end
    ine = peak3(k) + 200;
    if ine  > length(x)
        ine = length(x);
    end
    [maxp, indp] = max(x(inf:ine));
    PeakLoca = [PeakLoca; indp + inf - 1];
end
PeakLoca = unique(PeakLoca);

% prediction
RRbeforePredict = diff(PeakLoca);
partNum = floor(length(RRbeforePredict) / 5);
MatPeak = reshape(RRbeforePredict(1:partNum*5), 5, partNum);
MatStd  = std(MatPeak);
[minstd, minind] = min(MatStd);
tempS   = (minind-1)*5;
tempE   = minind*5 + 1;
meanHR  = mean(MatPeak(:, minind));
lenRR   = length(PeakLoca);

iCnt  = 1;
while 1
    if tempE+iCnt > length(PeakLoca)
        break;
    end
    if (PeakLoca(tempE+iCnt) - PeakLoca(tempE+iCnt-1)) < 0.55*meanHR
        PeakLoca(tempE+iCnt) = []; % interplated beat
    elseif (PeakLoca(tempE+iCnt) - PeakLoca(tempE+iCnt-1)) > 1.48*meanHR
        tempRR = x(PeakLoca(tempE+iCnt-1)+floor(0.88*meanHR):PeakLoca(tempE+iCnt-1)+floor(1.18*meanHR));
        [maxr, indr] = max(tempRR);
        PeakLoca = [PeakLoca(1:tempE+iCnt-1); indr+PeakLoca(tempE+iCnt-1)+floor(0.88*meanHR)-1; PeakLoca(tempE+iCnt:end)];
        iCnt = iCnt + 1;      % possibly missing beat
    else
        iCnt = iCnt + 1;
    end
end

iCnt  = 1;
while 1
    if tempS-iCnt < 1
        break;
    end
    if (PeakLoca(tempS-iCnt+1) - PeakLoca(tempS-iCnt)) < 0.55*meanHR
        PeakLoca(tempS-iCnt) = []; % interplated beat
    elseif (PeakLoca(tempS-iCnt+1) - PeakLoca(tempS-iCnt)) > 1.48*meanHR
        tempRR = x(PeakLoca(tempS-iCnt+1)-floor(1.18*meanHR):PeakLoca(tempS-iCnt+1)-floor(0.88*meanHR));
        [maxr, indr] = max(tempRR);
        PeakLoca = [PeakLoca(1:tempS-iCnt); indr+PeakLoca(tempS-iCnt+1)-floor(1.18*meanHR)-1; PeakLoca(tempS-iCnt+1:end)];
        % iCnt = iCnt + 1;      % possibly missing beat
    else
        iCnt = iCnt + 1;
    end
end

% real peak
peak3    = PeakLoca;
PeakLoca = [];
for k   = 1:length(peak3)
    inf = peak3(k) - 200;
    if inf  < 1
        inf = 1;
    end
    ine = peak3(k) + 200;
    if ine  > length(x)
        ine = length(x);
    end
    [maxp, indp] = max(x(inf:ine));
    PeakLoca = [PeakLoca; indp + inf - 1];
end
PeakLoca = unique(PeakLoca);