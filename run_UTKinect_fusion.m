clc;
clear;

for numClusters = 20
    load(['data_',num2str(numClusters),'\yTr']);
    load(['data_',num2str(numClusters),'\yTe']);
    F_train0 = [];
    F_test0 = [];

    for type = 1:2
        load(['data_',num2str(numClusters),'\F_train_type',num2str(type)]);
        load(['data_',num2str(numClusters),'\F_test_type',num2str(type)]);
        F_train0 = [F_train0,F_train];
        F_test0 = [F_test0,F_test];
    end


    train_data = [yTr,F_train0];
    test_data = [yTe,F_test0];

    tmp_test_elm;

    fid = ['data_',num2str(numClusters),'\fusion.txt'];
    c = fopen(fid, 'at+'); 
    fprintf(c,'%g \r\n',fix(best*10000)/100.0);
    fclose(c);
end



