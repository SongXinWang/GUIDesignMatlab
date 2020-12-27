function CS = Cross_SampEn(x,y,m,r)
%******************************************************
% $ This function is usded for calcualting the cross sample entropy
% (C-SampEn) for two time series. 

% x and y are two time series.
% m is embedding dimension and m is usually set as 2.
% r is threshold value and r is usually set as 0.1-0.25.

% $ Please cite the following paper when you chossing the entropy parameter.
% Zhao L N, Wei S S, Zhang C Q, Zhang Y T and LiuC Y. Determination of sample entropy and fuzzy measure entropy parameters for distinguishing congestive heart failure from normal sinus rhythm subjects. Entropy, 2015, 17(9): 6270-6288.
%
% $ Author:  Chengyu Liu (bestlcy@sdu.edu.cn) 
%           Institute of Biomedical Engineering,
%           Shandong University
% $Last updated:  2014.06.01

if length(x)>=length(y),
    N = length(y);
else
    N =length(x);
end
x     = zscore(x); % normalization for signal
y     = zscore(y); % normalization for signal
num_B = zeros(N-m,1);
num_A = zeros(N-m,1);
for i = 1:N-m
    for j = 1:N-m
        if max(abs(x(i:i+m-1)-y(j:j+m-1))) <= r
            num_B(i) = num_B(i)+1;
        end
    end
    num_B(i) = num_B(i)/(N-m);
end
Bm = mean(num_B);

for i = 1:N-m
    for j = 1:N-m
        if max(abs(x(i:i+m)-y(j:j+m))) <= r
            num_A(i) = num_A(i)+1;
        end
    end
    num_A(i) = num_A(i)/(N-m);
end
Am = mean(num_A);

CS = -log(Am/Bm);