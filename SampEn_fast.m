function SampEn = SampEn_fast(x, m, r)
%
%           Ref.    Richman JS, Moorman JR
%                   Physiological time-series analysis using approximate
%                   entropy and sample entropy
%                   Am J Physil Heart Circ Physiol, 2000

% $ Author:  Chengyu Liu (bestlcy@sdu.edu.cn) 
%            Institute of Biomedical Engineering,
%            Shandong University
% $Last updated:  2013.03.21


if size(x,1)<size(x,2);
    x=x';
end
x = zscore(x); % normalization for signal
N    = length(x);

indm = hankel(1:N-m, N-m:N-1); % m
inda = hankel(1:N-m, N-m:N);   % m+1
ym   = x(indm);
if m  == 1
    ym = ym(:);
end
ya   = x(inda);

% using pdist for saving time
% but need a large memory
cheb = pdist(ym, 'chebychev'); % maximum coordinate difference
cm   = sum(cheb <= r)*2 / (size(ym, 1)*(size(ym, 1)-1));

cheb = pdist(ya, 'chebychev');
ca   = sum(cheb <= r)*2 / (size(ya, 1)*(size(ya, 1)-1));
SampEn = -log(ca/cm);