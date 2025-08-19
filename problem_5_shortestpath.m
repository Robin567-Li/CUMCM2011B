clc,clear,close all

load("weight.mat");
load("distances.mat");
fullPath = fullfile(pwd, '2011B附件2_全市六区交通网路和平台设置的数据表.xls');
T = readtable(fullPath, 'Sheet', '全市交通路口节点数据',"Range","A2:E583");
T = removevars(T, {'Var4'});
T.Properties.VariableNames = ["xuhao", "X", "Y", "anfashu"];
jjpt = readtable(fullPath, 'Sheet', '全市交巡警平台',"Range","B2:B81");
luko = readtable(fullPath, 'Sheet', '全市交通路口的路线',"Range","A2:B929");
churuluko = readtable(fullPath, 'Sheet', '全市区出入口的位置',"Range","B2:B18");
ttt = readmatrix(fullPath, 'Sheet', '全市交通路口的路线',"Range","A2:B929");

hold on
scatter(T.X(jjpt.Var1)./10, T.Y(jjpt.Var1)./10, 10, 'r', 'filled') 
scatter(T.X(jjpt.Var1)./10, T.Y(jjpt.Var1)./10, 10, 'r', 'filled') 

dis_list = zeros(17,1);
G = digraph(weight);
num = 1;
for i = churuluko.Var1'
    [path, dis] = shortestpath(G, 32, i);
    dis_list(num) = dis;
    num  = num +1;
    fprintf("罪犯从32到%d耗时%.2f分钟,路径为",i,dis)
    fprintf('%d ', path)
    fprintf('\n')
    plot(T.X(path)./10, T.Y(path)./10, 'o-'); 
end
save("dis.mat",'dis_list')
