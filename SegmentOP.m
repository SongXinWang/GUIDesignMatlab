function [v_T_Ft t] = SegmentOP(cp, Fs, Resp)
%
% function: segments oscillometric pulse (OP) waveform
%
% IN:
%     cp:    cuff pressure [mmHg] sampled at Fs
%     Fs:    sample rate [smpls/s]
%     bPlot: boolean flag: 1-plot decomposition, 0-do not plot
%     str:   string for title (plot)
%
% OUT:
%     v_T_Ft:  segmentation (vector of sample indices of foot)
%     v_OP_Pk: vector of OP peaks  
%     v_T_Pk:  vector of cp values at OP peaks    
%     rmse:    qi value
%

% cp=cp_mmHg; 
% Fs=Fd;
% bPlot=1; 
% str=str(1:end-4);
%
L = numel(cp);


% vector to store oscillometric pulse peaks 
v_OP_Pk  = zeros(1000, 1); 
% vector to store time markers of oscillometric pulse peaks 
v_T_Pk   = zeros(1000, 1); 

% vector to store time markers of oscillometric pulse peaks 
v_T_Ft   = zeros(1000, 1); 

% LPF
n      = 6; Wn = 20/Fs/2;
[b, a] = butter(n, Wn);
xL     = filtfilt(b, a, cp);
Wn     = 0.5/Fs/2;
[d, c] = butter(4, Wn, 'high');
x      = filtfilt(d, c, xL);

% LPF for Respiration 
n      = 6; Wn = 20/Fs/2;
[b, a] = butter(n, Wn);
Respfilt = filtfilt(b, a, Resp);

% detect peak CP
iTM = 0; iT0 = 0; CPM = 0;
for k=1:L
    if( cp(k)>CPM )
        CPM = cp(k);
        iTM = k;
    end
    if( iTM>0 )
        % verify cp
        if( CPM>=140 && cp(k)<=150 )
            iT0 = k;
            iTM = 0; % reset
        end
    end
    if( CPM>=140 && cp(k)<35 )
        iTE = k;
        break
    end
end

t   = iT0:iTE;
y   = x(t);
ycp = cp(t);

%[~, locs] = findpeaks(y);
[pks, locs] = findpeaks(y);

% parse peaks
Np = numel(locs);
j  = 1;
for k=1:Np
    i2 = locs(k);
    % search foot
    if(k==1)
        i0 = 1; 
    else
        i0 = locs(k-1);
    end
    %[~, locs1] = findpeaks(-y(i0:i2));
    [pks1, locs1] = findpeaks(-y(i0:i2));
    if( isempty(locs1)==0 )
        % verify delta P
        dP = y(i2) - y(locs1(1)+i0-1);
        if( dP>0.1 )
            bValid = 0;
            if( j==1 )
                bValid = 1;
            else
                % verify time delta
                tO = v_T_Ft(j-1);
                tN = locs1(1)+i0-1; 
                if( (tN-tO)>=0.5*Fs )
                    bValid = 1;
                else
                    % verify delta P (prev pulse)
                    if( dP>0.6*dP_pre )
                        bValid = 1;
                    end
                end
            end
            if( bValid )
                v_T_Ft(j) = locs1(1)+i0-1;
                dP_pre    = dP;
                j = j+1;
            end
        end
    end
end

v_T_Ft(j:end) = []; % foot time marker series

% build OP waveform
Ns = numel(v_T_Ft); OP = []; xOP = [];


% plot((1:numel(ycp))/Fs, ycp), title(str)
% hold on,  
% y_min = min(cp); y_max = max(cp);  
% for l=1:Ns
%     plot([v_T_Ft(l) v_T_Ft(l)]/Fs, [y_min y_max], 'Color', [0.7 0.7 0.7])
% end
% ylim([y_min-10 y_max+10])
% xlim([0 numel(ycp)/Fs])
% hold off, ylabel('CP [mmHg]')
% set(gca, 'TickLength', [0 0]), 
% xlabel('Time [s]')
   
