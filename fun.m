function [smallArray] = fun(smallArray)

    fullPath = fullfile(pwd, '2011B附件2_全市六区交通网路和平台设置的数据表.xls');
    T = readtable(fullPath, 'Sheet', '全市交通路口节点数据',"Range","A2:E583");
    T = removevars(T, {'Var4'});
    T.Properties.VariableNames = ["xuhao", "X", "Y", "anfashu"];
    ttt = readmatrix(fullPath, 'Sheet', '全市交通路口的路线',"Range","A2:B929");
    [r, c] = find(ismember(ttt, smallArray));
    for i = 1:length(r)
        if c(i) == 1
            c(i) = 2;
        elseif c(i) == 2
            c(i) = 1;
        end
        smallArray(end + 1) = ttt(r(i),c(i));
    end

end