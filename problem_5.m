clc,clear,close all

load("weight.mat");
load("distances.mat");
load("dis.mat");
fullPath = fullfile(pwd, '2011B附件2_全市六区交通网路和平台设置的数据表.xls');
T = readtable(fullPath, 'Sheet', '全市交通路口节点数据',"Range","A2:E583");
T = removevars(T, {'Var4'});
T.Properties.VariableNames = ["xuhao", "X", "Y", "anfashu"];
jjpt = readtable(fullPath, 'Sheet', '全市交巡警平台',"Range","B2:B81");
luko = readtable(fullPath, 'Sheet', '全市交通路口的路线',"Range","A2:B929");
churuluko = readtable(fullPath, 'Sheet', '全市区出入口的位置',"Range","B2:B18");
ttt = readmatrix(fullPath, 'Sheet', '全市交通路口的路线',"Range","A2:B929");

% mat = inf(582,582);
% targetPoint = [T.X./10, T.Y./10];
% points = [T.X./10, T.Y./10];
% distances = pdist2(targetPoint, points, 'euclidean');
% for i = 1:size(ttt,1)
%     mat(ttt(i,1),ttt(i,2)) = 1;
%     mat(ttt(i,2),ttt(i,1)) = 1;
% end
% weight = distances.*mat;
% weight(isnan(weight)) = 0;
% weight;
% save('weight.mat', 'weight');

result = distances(table2array(jjpt),table2array(churuluko));
matt = result < repmat(dis_list',80,1) + 3;
result1 = result.*matt;     %    行号是交警平台按excel里按循序排好的，列号是出入口（按循序）
det(result1(1:17,:))    %   证明有效  前17个交警平台可以在罪犯没到达出入口之前到出入口

C = result1;
C(C == 0) = 1000;
nPerson = 80;
nTask = 17;

% 目标函数向量化
f = C(:);                      % 340×1向量

% 约束条件构建
Aeq = kron(eye(nTask), ones(1, nPerson)); % 任务约束：每列和为1
beq = ones(nTask, 1);                     % 17×1全1向量

A = repmat(eye(nPerson), 1, nTask);       % 人员约束：每行和≤1
b = ones(nPerson, 1);                     % 20×1全1向量

% 变量范围及整数约束
intcon = 1:length(f);          % 所有340个变量为整数
lb = zeros(size(f));           % 下限为0
ub = ones(size(f));            % 上限为1

% 求解混合整数规划
options = optimoptions('intlinprog', 'Display', 'final');
[x, fval] = intlinprog(f, intcon, A, b, Aeq, beq, lb, ub, options);

% 重构分配矩阵（20×17）
assignment = reshape(x, [nPerson, nTask]);

disp(['总时间: ', num2str(fval)]);

[i,j] = find(assignment == 1);
aa = table2array(jjpt);
bb = table2array(churuluko);
aa = aa(i);
bb = bb(j);
cc = [aa,bb]  %  第一列为交警平台 ，第二列为出入口
assignment .* C ;
max(max(assignment .* C))  
