clc,clear,close all

load("weight.mat");
load("distances.mat");
fullPath = fullfile(pwd, '2011B附件2_全市六区交通网路和平台设置的数据表.xls');
T = readtable(fullPath, 'Sheet', '全市交通路口节点数据',"Range","A2:E583");
T = removevars(T, {'Var4'});
T.Properties.VariableNames = ["xuhao", "X", "Y", "anfashu"];
jjpt = readtable(fullPath, 'Sheet', '全市交巡警平台',"Range","B2:B81");

dis1 = distances(table2array(jjpt),:);
[i,j] = find(min(dis1)<3 == 0);

t_4 = j

[i,j] = find((distances(t_4,:) < 3) == 1);

t_4_3 = unique(j')

dis = (distances(t_4_3,t_4) < 3).*distances(t_4_3,t_4);
scatter(T.X(t_4)./10, T.Y(t_4)./10, 10, 'b', 'filled');
anfashu = T.anfashu;
anfashu = anfashu(t_4)';
fuhe = dis.*anfashu;
% fuhe(find(fuhe == 0)) = 10e6;

% [x, fval, assignment] = t4fun(fuhe,20);
% result = cell(294,1);
% for i = 1:294
%     result{i} = find(assignment(i,:) == 1);
% end
% for i = 1:294
%     if length(cell2mat(result(i))) > 0
%         fprintf(" %d",cell2mat(result(i)))
%         fprintf("\n")
%     end
% end
% fval



