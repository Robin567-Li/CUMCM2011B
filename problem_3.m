clc,clear,close all

load("weight.mat");
load("distances.mat");

fullPath = fullfile(pwd, '2011B附件2_全市六区交通网路和平台设置的数据表.xls');
T = readtable(fullPath, 'Sheet', '全市交通路口节点数据',"Range","A2:E93");
T = removevars(T, {'Var4'});
T.Properties.VariableNames = ["xuhao", "X", "Y", "anfashu"];

t1_3 = find(sum(distances(1:20,1:92) < 3) == 0)
[i,j] = find((distances(t1_3,:) < 3) == 1);
t1_3_3 = unique(j')  

tot  = cell(3456,1);
num = 0;
for i = t1_3_3
    for j = t1_3_3
        for m = t1_3_3
            for n = t1_3_3
                res = distances([i,j,m,n],t1_3) < 3;
                rr = sum(res);
                flag = any(rr(:) == 0);
                if flag == 0
                    num = num +1 ;
                    tot{num} = [i,j,m,n];
                end
            end
        end
    end
end



% ss = [];
% sss = [];
% for i = 1:length(tot)
%     dis = distances([1:20,tot{i}],1:92) < 3;
%     fuhe = dis.*T.anfashu';
%     fuhe(find(fuhe == 0)) = 10e6;
%     s = 0;
%     for num = 9:-0.1:0  % 8.5
%         try
%             [x, fval, assignment] = t1fun(fuhe,num);
%             result = cell(24,1);
%             for j = 1:24
%                 result{j} = find(assignment(j,:) == 1);
%             end
%             res = zeros(24,1);
%             for k = 1:24
%                 for kk = result{k}
%                     res(k,1) = res(k,1) + T.anfashu(kk);
%                 end
%             end
%             s = num;
%         catch
%             break
%         end
%     end
%     ss = [ss,s];   %  全是 8.5
%     sss = [sss,std(res)];   % 2.0852   91  [i,j] = min(sss)   28 48 87 38
% end



dis = distances([1:20,[28 48 87 38]],1:92) < 3;  %  24 ----92
fuhe = dis.*T.anfashu';
fuhe(find(fuhe == 0)) = 10e6;
[x, fval, assignment] = t1fun(fuhe,8.5);
result = cell(24,1);
for i = 1:24
    result{i} = find(assignment(i,:) == 1);
end
res = zeros(24,2);
for k = 1:24
    res(k,1) = length(result{k});
    fprintf("第%d个交警平台管辖的节点:",k)
    fprintf(" %d",result{k})
    fprintf("\n")
    for kk = result{k}
        res(k,2) = res(k,2) + T.anfashu(kk);
    end
end
T = table([1:24]',res(:,1),res(:,2),'VariableNames',{'交警平台序号','管辖节点数','负荷'})
fprintf("\n总案发率:%6f\n",fval)
fprintf("\n标准差为(3456种情况下最小的):%6f\n",std(res(:,2)))
fprintf("\n总路程为:%6f\n",sum(sum(assignment.*distances([1:20,[28 48 87 38]],1:92))))

