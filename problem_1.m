clc,clear,close all

load("weight.mat");
load("distances.mat");
fullPath = fullfile(pwd, '2011B附件2_全市六区交通网路和平台设置的数据表.xls');
T = readtable(fullPath, 'Sheet', '全市交通路口节点数据',"Range","A2:E93");
T = removevars(T, {'Var4'});
T.Properties.VariableNames = ["xuhao", "X", "Y", "anfashu"];

scatter(T.X./10, T.Y./10, 10, 'b', 'filled'); % 蓝色实心点，大小100[1,5](@ref)
hold on
scatter(T.X(1:20)./10, T.Y(1:20)./10, 10, 'r', 'filled'); % 蓝色实心点，大小100[1,5](@ref)
scatter(T.X(14)./10, T.Y(14)./10, 100, 'g', 'filled'); % 蓝色实心点，大小100[1,5](@ref)


% % 创建digraph对象
% G = digraph(weight);
% [pathNodes, dist] = shortestpath(G, 1, 13)  %例子
% % 计算所有节点对的最短距离（距离矩阵）
% distances = distances(G);
% save("distances.mat","distances")


distances1 = distances(1:20,1:92);
result2 = find(sum(distances1 < 3) == 0);
[i,j] = min(distances1);
j(result2);
panduan_matrix = distances1 < 3;
panduan_matrix(15,28) = 1;
panduan_matrix(15,29) = 1;
panduan_matrix(16,38) = 1;
panduan_matrix(2,39) = 1;
panduan_matrix(7,61) = 1;
panduan_matrix(20,92) = 1;
anfashu = T.anfashu';
fuhe = T.anfashu'.*panduan_matrix;
fuhe(find(fuhe == 0)) = 10e6;

for num = 9:-0.1:8   % 8.6√   8.4解不出来的 
    try
        [x, fval, assignment] = t1fun(fuhe,num);
    catch
        zuidarenwushu = num + 0.1
        break
    end
end


result = cell(20,1);
for i = 1:20
    result{i} = find(assignment(i,:) == 1);
end

res = zeros(20,2);
for k = 1:20
    res(k,1) = length(result{k});
    fprintf("第%d个交警平台管辖的节点:",k)
    fprintf(" %d",result{k})
    fprintf("\n")
    for kk = result{k}
        res(k,2) = res(k,2) + T.anfashu(kk);
    end
end

T = table([1:20]',res(:,1),res(:,2),'VariableNames',{'交警平台序号','管辖节点数','负荷'})
fprintf("3分钟到不的点:")
fprintf(" %d",result2)
fprintf("\n")
fprintf("\n总案发率（案发效*路程）:%6f\n",fval)  % 122.8000
fprintf("\n标准差为:%6f\n",std(res(:,2)))       % 2.002998
fprintf("\n总路程为:%6f\n",sum(sum(assignment.*distances1)))   % 137.4178
fprintf("\n最案发数为（案发效*路程）:%6f\n",zuidarenwushu)  % 8.5
% 6.6+6.9+7.2+8.1+7.3+6.2+2.4+8.5+2.5+4.8+6.1+7.3+7.9+8.4+5.5+5.7+7.6+5.2+7+1.6


% C = fuhe;
% nPerson = size(fuhe,1);
% nTask = size(fuhe,2);
% fun = @(x) fuhe.*x(1:92)';
% Aeq = kron(eye(nTask), ones(1, nPerson)); % 任务约束：每列和为1
% beq = ones(nTask, 1);                     % 17×1全1向量
% lb = zeros(nPerson*nTask,1);              % 下限为0
% ub = ones(nPerson*nTask,1);               % 上限为1
% options = optimoptions('fminimax', 'Display', 'iter-detailed', 'UseParallel', true);
% [x, fval, exitflag] = fminimax(fun, zeros(1840,1), [], [], Aeq, beq, lb, ub, [], options);
% assignment = reshape(x, [nPerson, nTask])



