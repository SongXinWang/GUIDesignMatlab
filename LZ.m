% �ó�������ʵ�������ź����е�LZ�����Է���������PΪ�����ź�����ת���ɵ�0��1��������
% ����P�ĳ���ΪN��ʵ��ֻ�����ǰN-3��
% P=[1 0 1 0 0 0 0 0 0 0 0 0 1 1 1 1 1 0 0 0 0 1 0 1 0 1 0 0 0 1 0 0 1 1 1 1 1 1 1 1 1 0 1 0 1 0 0 0 0 1 1 0 1 0 1 1]';
function C=LZ(data)
x=data;
xx=mean(x);
N=length(x);
P=zeros(N,1);
for i=1:N
    if x(i)<xx
        P(i)=0;
    else 
        P(i)=1;
    end
end
S=P(1);
Q=P(2);
SQ=[S;Q];
SQ1=P(1);
QQ=mat2str(Q);
v=mat2str(SQ1);
c=1;
t=strmatch(QQ,v);
if t>=1
else
    c=c+1;
    v=strvcat(v,QQ);
end
A=P(3:length(P));
for i=1:length(A)
   Q=A(1);
   QQ=mat2str(Q);
   for j=2:(length(A))
       t=strmatch(QQ,v);
       if t>=1
          Q=[Q;A(j)];
          QQ=mat2str(Q);
       end 
   end
  t=strmatch(QQ,v);
  if t>=1
  else 
   c=c+1;
   v=strvcat(v,QQ);
  end
m=length(Q);
A=A(1+m:length(A));
   if length(A)<3
         break;
   end
end
B=log(2)*(N-3)/log(N-3);
C=c/B;


        
