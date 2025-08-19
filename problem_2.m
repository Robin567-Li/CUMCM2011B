clc,clear,close all

load("weight.mat");
load("distances.mat");
fullPath = fullfile(pwd, '2011B附件2_全市六区交通网路和平台设置的数据表.xls');
T = readtable(fullPath, 'Sheet', '全市交通路口节点数据',"Range","A2:E93");
T = removevars(T, {'Var4'});
T.Properties.VariableNames = ["xuhao", "X", "Y", "anfashu"];
entrance_out = readtable(fullPath, 'Sheet', '全市区出入口的位置',"Range","C2:C14");

entrance_out = table2array(entrance_out);
C_orig = distances(1:20,entrance_out);
C1 = [C_orig,0.0001.*ones(20,7)]; 

while true   % minmax
    mat_result = C1;
    [M, linearIdx] = max(C1(:));
    [row, col] = ind2sub(size(C1), linearIdx);  % 精确定位坐标
    maxx = C1(row, col);
    C1(row, col) = 0;
    if det(C1) == 0
        break
    end
end

C1(row, col) = maxx;
result = C1(:,1:13);
fprintf("到达的最长时间为%6f分钟\n",maxx)

C = result;
C(find(C == 0)) = 10e6;
nPerson = 20;
nTask = 13;

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

% 输出结果
% disp('最优分配矩阵（行为交警平台，列为封锁点）:');
% disp(assignment);              % 每列有且仅有一个1，每行至多一个1
disp(['总时间: ', num2str(fval)]);

[i,j] = find(assignment == 1);
T = table(i,entrance_out(j),'VariableNames',{'交警平台序号','围堵的节点'})
maxx