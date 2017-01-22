clc;
clear;

for numClusters = 80
    load(['data_',num2str(numClusters),'\yTr']);
    load(['data_',num2str(numClusters),'\yTe']);
    F_train0 = [];
    F_test0 = [];

    for type = 3
        load(['data_',num2str(numClusters),'\F_train_type',num2str(type)]);
        load(['data_',num2str(numClusters),'\F_test_type',num2str(type)]);
        F_train0 = [F_train0,F_train];
        F_test0 = [F_test0,F_test];
    end


    
%     train_data = [yTr,F_train0];
%     test_data = [yTe,F_test0];
%     tmp_test_elm;

    train_data0 = [yTr,F_train0];
    test_data0 = [yTe,F_test0];
    
    data = [train_data0;test_data0];

%     GA = 35.4;
%     CC = 10;
    
    all = 0;
    Confus = zeros(max(data(:,1)),max(data(:,1)));
    for m = 1:size(data,1)
        test_data = data(m,:);
        train_data = [data(1:m-1,:);data(m+1:end,:)];
        tmp_test_elm;
        all = all + best;
        Confus = Confus + ConfusMatrix;
    end
    best = all / m;

    fid = ['data_',num2str(numClusters),'\fusion_leave one out.txt'];
    c = fopen(fid, 'at+'); 
    fprintf(c,'%d ',type);
    fprintf(c,'%g \r\n',fix(best*10000)/100.0);
    fclose(c);
end



