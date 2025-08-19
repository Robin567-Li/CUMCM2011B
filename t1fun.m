function [x, fval,assignment] = t1fun(fuhe,num)
C = fuhe;
nPerson = size(fuhe,1);
nTask = size(fuhe,2);
f = C(:);                     
Aeq = kron(eye(nTask), ones(1, nPerson)); % 任务约束：每列和为1
beq = ones(nTask, 1);                     % n×1全1向量
A = zeros(nPerson,nPerson*nTask);
for i = 1:nTask
    A(:,[(nPerson*(i-1)+1) : nPerson*i]) = diag(C(:,i));
end
b = num*ones((nPerson), 1);  
intcon = 1:length(f);          % 所有变量为整数
lb = zeros(size(f));           % 下限为0
ub = ones(size(f));    % 上限为1
options = optimoptions('intlinprog', 'Display', 'off');
[x, fval,exitflag] = intlinprog(f, intcon, A, b, Aeq, beq, lb, ub, options);
assignment = reshape(x, [nPerson, nTask]);
end