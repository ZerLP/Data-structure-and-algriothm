function f=G_S(Cnum,Dnum,channel_list,due_list)
%D2DΪ����M��cueΪŮ��
qmax=3;

F=channel_list;
M=due_list;
x_stable=zeros(Dnum,Cnum);
x_match=zeros(Dnum,Cnum);

M_origin = M;
F_origin = F;
%% define couple list
M_sg = ones(Dnum,1);
M_cp = zeros(Dnum,1);
F_cp = zeros(Cnum,1);
Mlove_rank = zeros(Dnum,1);
Flove_rank = zeros(Cnum,1);
Mlove_score = zeros(1);
Flove_score = zeros(1);
F_mark = zeros(Cnum,Dnum);

M_favor_rank=Cnum;
F_favor_rank=Dnum;

%% maching...
times = 0;
% ��û���к��ǵ���ʱ����ƥ��ɹ��ˣ�ͬʱ��ƥ��Ҳ���ȶ���
% ��ʵ�������� M_sg �� F_cp ���ô���һ����:
% while �������ȿ�����sum(M_sg)>0����������δȫ�ѵ���Ҳ������
% ~all(F_cp),��Ů����δȫ�ҵ�����
while sum(M_sg)>0
    % M: courtship
    for i=1:Dnum                                 % ����ÿ������
        if M_sg(i)==1                           % �������i��ǰ�ǵ���
            for j=1:M_favor_rank      %Cnum      % �Ͱ�ϲ���̶ȴӸߵ��͸�ÿλŮ������(����Ů���Ƿ���)������i��ϲ����Ů�����M(i, j)��ϲ���ȼ�Ϊj
                if M(i,j)~=0                    % ���Ů��j��û����ԡ�ѡ��û�оܾ����Լ���Ů������ϲ������һ����Ů��j������i��ϲ���ȼ�Ϊk
                    for k=1:F_favor_rank   %Dnum            % ��������
                        if F(M(i,j),k)==i      %������ϲ����Ů��M(i��j)��ƫ���б���������i�ŵ�kλ      
                            F_mark(M(i,j),k)=1; %��ʱ������k
                            break;
                        end
                    end  %��ѭ��������Ů��M(i,j)�յ�����������
                    break;
                end
            end
        end
    end
    
    % F: response
    for i=1:Cnum                         
        if sum(F_mark(i,:)~=0)                          % ���Ů��i�Ѿ��յ�����һ���������
            for j=1:F_favor_rank                        % ��������j                
                if F_mark(i,j)==1                       % �������j��Ů��i��׹�
                    F_cp(i)=F(i,j);                     % Ů��i�����������F(i,j)
                    M_cp(F(i,j))=i;                     % ��Ӧ������jҲ����Ů��i
                    M_sg(F(i,j))=0;                     % ͬʱ���Ǹ�����ժ���˵�����ñ��
                    x_match(F(i,j),i)=1;                % ���������ƥ�����                              
                   if j<Dnum                              % ���Ů�����ܵ����鲻�������Լ��ϲ�������������Ը���ϲ���������оܾ�Ȩ
                        Id2c=sum(x_match(F(i,j),:).*Idc1);
                        dnum=sum(x_match(F(i,j),:));              
                       while (Id2c(1,j)>5.54E-04) && (dnum<=1)   %Ic_th
                           [~,YY_F_cp]=size(F_cp');
                           if (sum(F_cp(i,:)))~=0
                               for jj=1:YY_F_cp
                                   if F_mark(i,jj)~=0
                                       Flove_rank(i,jj)=jj;
                                   end
                               end
                           end
                           %[X_flag,Y_flag]=max(Flove_rank(i,:));
                           for kk=j:Dnum
                               if F_mark(i,kk)==1
                                   F_mark(i,kk)==0;
                                   for s=1:Cnum
                                       if M(F(i,kk),s)==i
                                        M(F(i,kk),s)=0;  % Ȼ�����������һ�ź��˿�(��������ѷ���)
                                        M_sg(F(i,kk),i)=1;
                                        x_match(F(i,kk),i)=0;
                                        F_cp(i,kk)=0;%�޳���������D2D
                                       end
                                   end
                               end
                               break;
                           end
                            Id2c=sum(x_match(F(i,j),:).*Idc1);
                       end
                end
            end
            continue;
        end
    end

times=times+1;
fprintf('��%d��ƥ�����\n',times);
end
  % F: response
%  for i=1:Cnum                         
%         if sum(F_mark(i,:)~=0)                          % ÿ���յ������Ů��(�����Ƿ���)��Ů��i�����յ�һ������
%             for j=1:F_favor_rank             %Dnum
%                 
%                 if F_mark(i,j)==1                       % ���Ů��i�յ�����j������
%                     F_cp(i)=F(i,j);                     % �������Ů������CP
%                     M_cp(F(i,j))=i;                     % ��Ӧ������Ҳ����CP
%                     M_sg(F(i,j))=0;                     % ͬʱ���Ǹ�����ժ���˵�����ñ��
%                     x_match(F(i,j),i)=1;                
%                     if j<qmax                             % ���Ů�����ܵ����鲻�������Լ��ϲ�������������Ը���ϲ���������оܾ�Ȩ
%                         for k=j+1:Dnum                   % ��鿴����ϲ��������(��)�����ܿ��ܲ�ֹһ�������Ƿ���������
%                             if F_mark(i,k)==1           % ����
%                                 F_mark(i,k)=0;          % ��ô�����ӵ�����������������(����֮ǰ�����飬�������ѵ�����)
%                                 
%                                 for s=1:Cnum             
%                                     if M(F(i,k),s)==i
%                                         M(F(i,k),s)=0;  % Ȼ�����������һ�ź��˿�(��������ѷ���)
%                                         M_sg(F(i,k))=1; % ���Ǹ��������»ص�����������
%                                         break;
%                                     end
%                                 end
%                             end
%                         end
%                     end
%                     break;
%                 end
%                 
%             end
%         else
%             continue;                   % ����ʱ����û�յ������Ů��
%         end
%     end
%     times = times+1; 
%     fprintf('%d��ƥ�����\n',times);
%     end
%     f = x_match;
% 

end

                           
                     