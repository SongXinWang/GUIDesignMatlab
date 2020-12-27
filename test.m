clear all
clc
close all
data=load('E:\BP project interface program\Subjects\clive_bell_1.csv');
cp      = (data(:,1)-1)*100;     % cuff pressure
        microp    = data(:,4)*1000/150;     % microphone
        fs=2000;

        %% extract deflation period
        [s_def b1] = find(cp==max(cp)); % s_def: start of deflation
        s_def = s_def(1);
        cp_def1 = cp(s_def:end);
        % set deflation range
        Max_p = 140;
        Min_p = 50;
        [e_def b2] = find(cp_def1<Min_p);
        e_def = e_def(1);
        [s_add b3] = find(cp_def1<Max_p);
        s_add=s_add(1);
        cuffPressure = cp(s_def+s_add:s_def+e_def);
        max_cp = max(cuffPressure);
        min_cp = min(cuffPressure);
        range_cp = max_cp-min_cp;
        Microphone = microp(s_def+s_add:s_def+e_def);
        Meann = mean(Microphone)-mean(Microphone);
        %         Meann = 0.1;
        if flag==0
        else if flag==1
                wp=0.1;
                ws=0.06;
                Rp=0.3;
                Rs=5;
                fs2=200;
                [N1,Wn1]=buttord(wp/(fs2/2),ws/(fs2/2),Rp,Rs);
                [b1,a1]=butter(N1,Wn1,'high');

                %% for lowpass f=30Hz fs=200;
                wp=30;
                ws=32;
                Rp=0.3;
                Rs=10;
                fs2=200;
                [N2,Wn2]=buttord(wp/(fs2/2),ws/(fs2/2),Rp,Rs);
                [b2,a2]=butter(N2,Wn2,'low');

                microp_os11 = resample(Microphone, 200, 2000); % for fs=200Hz
                microp_os12 = filtfilt(b1, a1, microp_os11);
                microp_f1 = filtfilt(b2, a2, microp_os12);
                Microphone = resample(microp_f1,2000,200)+Meann;
                %                 Microphone = resample(microp_f1, length(cuffPressure),
                %                 length(microp_f1));
            else if flag==2
                    wp=30;
                    ws=25;
                    Rp=0.3;
                    Rs=2.5;
                    fs=2000;
                    [N1,Wn1]=buttord(wp/(fs/2),ws/(fs/2),Rp,Rs);
                    [b1,a1]=butter(N1,Wn1,'high');

                    %% for lowpass f=100Hz fs=2000;
                    wp=100;
                    ws=110;
                    Rp=0.3;
                    Rs=5;
                    fs=2000;
                    [N2,Wn2]=buttord(wp/(fs/2),ws/(fs/2),Rp,Rs);
                    [b2,a2]=butter(N2,Wn2,'low');

                    % microp_os21 = resample(microp_os, 200, 2000); % for fs=200Hz
                    microp_os22 = filtfilt(b1, a1, Microphone);
                    Microphone2 = filtfilt(b2, a2, microp_os22);
                    Microphone2 = 20*Microphone2./max(Microphone2);
                    wavwrite(Microphone2, fs, 16, 'test.wav');
                else if flag==3
                        wp=100;
                        ws=90;
                        Rp=0.3;
                        Rs=3;
                        fs=2000;
                        [N1,Wn1]=buttord(wp/(fs/2),ws/(fs/2),Rp,Rs);
                        [b1,a1]=butter(N1,Wn1,'high');

                        %% for lowpass f=300Hz fs=2000;
                        wp=300;
                        ws=330;
                        Rp=0.3;
                        Rs=10;
                        fs=2000;
                        [N2,Wn2]=buttord(wp/(fs/2),ws/(fs/2),Rp,Rs);
                        [b2,a2]=butter(N2,Wn2,'low');

                        % microp_os31 = resample(microp_os, 200, 2000); % for fs=200Hz
                        microp_os32 = filtfilt(b1, a1,Microphone);
                        Microphone = filtfilt(b2, a2, microp_os32)+Meann;
                    end
                end
            end
        end
        max_mp = max(Microphone);
        min_mp = min(Microphone);
        range_mp = max_mp-min_mp;
        NN = min(length(cuffPressure),length(Microphone));
        cuffPressure = cuffPressure(1:NN);
        Microphone = Microphone(1:NN);
        cuffPressure_trend = linspace(cuffPressure(1),cuffPressure(end),NN);

        % display the data in figure
        t = [1/2000:1/2000:NN/2000]; % fs = 2000Hz
        time = NN/2000;
        hold on
        plot(hData1Axes,t,cuffPressure);
        hold on
        plot(hData3Axes,t,Microphone);
        xlim(hData1Axes,[0 time]);
        ylim(hData1Axes,[min_cp-0.1*range_cp max_cp+0.1*range_cp]);       
        xlim(hData2Axes,[0 100]);
        ylim(hData2Axes,[0 1]);
        set(hData2Axes,'ytick',[ ]);
        set(hData2Axes,'xtick',[ ]);
        ylim(hData3Axes,[min_mp-0.1*range_mp max_mp+0.1*range_mp]);
        xlim(hData3Axes,[0 time]);
        xlabel(hData3Axes,'Time (s)');
        ylabel(hData3Axes,'Microphone signal (mmHg)');