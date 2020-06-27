
function f = Gale_Shapley( GAMMA_switch, I, GAMMA_controller, J, lammd_expand )

global x_initial
global alpha
global beta
global lammd_expand

% I ��������ƫ���б���������ţ��н�������
% J ��������ƫ���б���������ţ��н�������
accept_num = 6;  % Ů������������
Male = I;
Female = J';
[ M_num, F_num ] = size( I );


x_stable = zeros( M_num, F_num );
x_match = zeros( M_num, F_num );

M_origin = Male;
F_origin = Female;
%% define couple list
M_sg = ones( M_num, 1 );% �������ķ�����
M_cp = zeros(M_num,1); 
F_cp = zeros(F_num,1);
Mlove_rank = zeros(M_num,1);
Flove_rank = zeros(F_num,1);
Mlove_score = zeros(1);
Flove_score = zeros(1);
F_mark = zeros(F_num,M_num);  % ������кű�ʾ������ܷ����кű�ʾ���ܷ������������


M_favor_rank = F_num;
F_favor_rank = M_num;


times = 0;
while sum(M_sg)>0
 % M: courtship
 for i=1:M_num % ����ÿ������
if M_sg(i)==1  % �������ǰ�ǵ���
     for j=1:M_favor_rank 
            if Male(i,j)~=0 % ����i��ϲ����Ů�����M(i, j)��ϲ���ȼ�Ϊj
               for k=1: F_favor_rank  % Ů��j������i��ϲ���ȼ�Ϊk
                  if Female(Male(i,j),k)==i
                           F_mark(Male(i,j),k)=1; % Ů���յ��ı����
                               break;
                  end
        end
 break;
 end
 end
 end
 end

 % F: response
  for i=1:F_num   % Ů��i  
 if sum(F_mark(i,:)~=0)  % ÿ���յ������Ů��(�����Ƿ���)
  for j=1:F_favor_rank
 
 if F_mark(i,j)==1  % ֻ����������ϲ��������������
  F_cp(i,j)=Female(i,j);   % �������Ů������CP
  M_cp(Female(i,j))=i;   % ��Ӧ������Ҳ����CP
    M_sg(Female(i,j))=0;  % ͬʱ���Ǹ�����ժ���˵�����ñ��
  x_match(Female(i,j), i) = 1;%%%��Ҫ����λ��


   %if j<accept_num  % ���������������� 
  maintain_load = sum( lammd_expand.*x_match );  % ���������ά�ֵĸ�����
 maintain_num = sum( x_match );  % ���������ά�ֵĽ���������
 if maintain_load( 1, i ) > alpha*beta(i)  % ��ά�ֵĸ�������������������������
  % if sum( lammd_expand(:,j).*x_match ) > alpha*beta(j) || accept_num < sum( x_match(:, j) )

  while maintain_load( 1, i ) > alpha*beta(i)
 %�ҵ���ǰ�ϲ��������
  [ ~, YY_F_cp ] = size( F_cp ); %size�����У�����
 
  if sum(F_cp(i,j-1))~=0 % ����ÿ���ǵ����Ů��
 for jj=1:YY_F_cp
 if F_mark(i,jj)~=0
 Flove_rank(i,jj)=jj; % ��Ů����ǰ������������jϲ���ģ����F_cpʹ�ã�
 
 end
 end
 end

[X_flag, Y_flag] = max( Flove_rank(i,:) ) ;


 for kk=j:M_num % ��ϲ���ȼ�����j��[j+1��num]�����������ӵ������
if F_mark(i,kk)==1  % ��֮ǰ���յ�kk�ı���飬���ӵ�
F_mark(i,kk)=0;
 for s=1:F_num 
if Male(Female(i,kk),s)==i
Male(F_cp( i, kk ), s)=0; % Ȼ�����������һ�ź��˿�(��������ѷ���)
M_sg( F_cp( i, kk ) )=1; % ���Ǹ��������»ص�����������
x_match( F_cp( i, kk ), i ) = 0;
 F_cp( i, kk ) = 0;% �ߵ��ȼ����Ľ�����
 
 
end
 end
end
  break;
 end
  maintain_load = sum( lammd_expand.*x_match );
  end
 end
%break;
end
 end
 else
 continue; % ����ʱ����û�յ������Ů��
 end

end
times = times+1;
% fprintf('��%d��ƥ�����\n',times);


%% ����ÿ���˶��Լ���/Ů���ѵ�����̶�
% ����ÿ������
 for iii=1:M_num 
if M_sg(iii)~=1  % ����ÿ���ǵ��������
for jjj=1:M_favor_rank 
if Male(iii,jjj)~=0
Mlove_rank(iii)=jjj;% ��������ǰ��Ů��������jϲ����
  break;
end
end
end
 end
  % ����ÿ��Ů��
 for iii=1:F_num
 if sum(F_mark(iii,:))~=0   % ����ÿ���ǵ����Ů��
 for j=1:F_favor_rank
 if F_mark(iii,jjj)~=0
  Flove_rank(iii)=jjj;  % ��Ů����ǰ������������jϲ����
  break;
 end
 end
 end
 end
  % ����ÿ��ƥ�����Ů���Լ���Ů��/���ѵ�ϲ���̶�
  Mlove_score( times )=sum( sum(Mlove_rank) )/M_num;
  Flove_score( times )=sum( sum(Flove_rank) )/F_num;
end
fprintf('ȫ��ƥ����ɣ�һ��ƥ����%d��\n',times);

f = x_match;
end
