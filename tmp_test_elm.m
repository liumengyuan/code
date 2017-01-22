


ga00 = 0.000000001:0.000000001:0.000000009;
ga0 = 0.00000001:0.00000001:0.00000009;
ga1 = 0.0000001:0.0000001:0.0000009;
ga2 = 0.000001:0.000001:0.000009;
ga3 = 0.00001:0.00001:0.00009;
ga4 = 0.0001:0.0001:0.0009;
ga5 = 0.001:0.001:0.009;
ga6 = 0.01:0.01:0.09;
ga7 = 0.1:0.1:0.9;
ga8 = 1:0.2:150;

%ga11 = 100:0.2:200;
% 35.4;%
GA = [0.01,0.1,1,10];%[ga0, ga1, ga2, ga3, ga4, ga5, ga6, ga7, ga8];
%GA = [ga1, ga2, ga3, ga4, ga5, ga6, ga7, ga8];
% 10;%
CC = [10,100];%[10, 100, 1.0e+3, 1.0e+4, 1.0e+5, 1.0e+6, 1.0e+7, 1.0e+8]; 
%CC = [10, 100, 1.0e+3, 1.0e+4, 1.0e+5, 1.0e+6, 1.0e+7]; 

%GA = ga11;

best_acc = zeros(1, length(CC));

best = 0;
best_C = 0;
best_gamma = 0;
best_ConfusMatrix = [];

all_acc = zeros(length(CC), length(GA));

for pp = 1:length(CC)
    para_C = CC(pp);
    accy = zeros(1,length(GA));
    
    for trial = 1:length(GA);
        gamma = GA(trial);
        [TrainingTime, TestingTime, TrainAC, TestAC, TY, ConfusMatrix] = elm_kernel(train_data, test_data, 1, para_C, 'RBF_kernel',gamma);
        accy(trial) = TestAC;
        all_acc(pp,trial) = TestAC;
        
        if (TestAC > best)
            best = TestAC;
            best_C = para_C;
            best_gamma = gamma;
            best_ConfusMatrix = ConfusMatrix;
        end
        
    end
    
    best_acc(pp) = max(accy);  
    %disp(max(accy));
end

out_acc = max(best_acc);
fprintf('Max ACC = %f\n\n', out_acc);





