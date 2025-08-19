clc,clear,close all

fullPath = fullfile(pwd, '2011B附件2_全市六区交通网路和平台设置的数据表.xls');
T = readtable(fullPath, 'Sheet', '全市交通路口节点数据',"Range","A2:E583");
T = removevars(T, {'Var4'});
T.Properties.VariableNames = ["xuhao", "X", "Y", "anfashu"];
jjpt = readtable(fullPath, 'Sheet', '全市交巡警平台',"Range","B2:B81");
luko = readtable(fullPath, 'Sheet', '全市交通路口的路线',"Range","A2:B929");
churuluko = readtable(fullPath, 'Sheet', '全市区出入口的位置',"Range","B2:B18");
ttt = readmatrix(fullPath, 'Sheet', '全市交通路口的路线',"Range","A2:B929");

scatter(T.X(jjpt.Var1)./10, T.Y(jjpt.Var1)./10, 10, 'b', 'filled') 
hold on
scatter(T.X(churuluko.Var1)./10, T.Y(churuluko.Var1)./10, 10, 'k', 'filled') 

for i = 1:928
    plot([T.X(luko.Var1(i))./10, T.X(luko.Var2(i))./10],[T.Y(luko.Var1(i))./10, T.Y(luko.Var2(i))./10],'b') 
end

tot = {};
smallArray = [32];
while true
    bigArray = fun(smallArray);
    mask = ismember(bigArray, smallArray);
    smallArray = bigArray;
    result = bigArray(~mask);
    tot{end+1} = result';
    if any(ismember(bigArray, churuluko.Var1))
        break
    end
end

scatter(T.X(32)./10, T.Y(32)./10, 30, 'k', 'filled') 

for i = 4   %    选择展示第1-10级拦截路口
    jibieluko = cell2mat(tot(i))'
    shuliang = length(jibieluko)
    scatter(T.X(tot{i})./10, T.Y(tot{i})./10, 10, 'r', 'filled') % 
end
