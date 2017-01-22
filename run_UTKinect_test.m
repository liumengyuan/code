clc;
clear;

for numClusters = 80

mkdir(['data_',num2str(numClusters),'\']);

for type = 2

activityType = {'a01', 'a02', 'a03', 'a04', ...
    'a05', 'a06', 'a07', 'a08', 'a09', ...
    'a10'};

F_f = [];
sub_index = [];
sample_label = [];

% load Action3D_sample_list    %%%% a list of samples (corresponding to the samples used in many papers, a few samples are not used due to wrong skeleton for skeleton-based action recognition methods)
NumAct = size(activityType,2);

Dir = dir(['UTKinect_skeleton/','*.mat']);
sample_list = [];
for i = 1:size(Dir,1)
   sample_list{i,1} = Dir(i,1).name(1,1:end-13); 
end

sample_cout = 1;

for i = 1:length(sample_list)
    clc;
    disp([length(sample_list) i]);
    depth_name = sprintf('UTKinect_skeleton/%s_skeleton.mat',sample_list{i});
    
    if exist(depth_name,'file')        
        
        %%% //  extract depth feature
        feature = extract_feature(depth_name,type);
        for kkk = 1:size(feature,1)
            feature(kkk,:) = (feature(kkk,:) - min(feature(kkk,:))) ./ (eps+max(feature(kkk,:)) - min(feature(kkk,:)));
        end
        
        F_f{sample_cout} = feature;  %%% corresponding to all the block LBP features for all front DMMs        
        sample_cout = sample_cout + 1; 
        clear depth
        %%%% record subject index
        sub_index = [sub_index, str2double(sample_list{i}(6:7))];
        %%%% record sample label
        sample_label = [sample_label, str2double(sample_list{i}(2:3))];
        
    end
                      
end



%% Assemble training and testing data before generating Fisher Vector features for the training and testing data
tic
train_index = [1 2 3 4 5]; % training subject numbers
F_train_size = zeros(1,NumAct);
F_test_size  = zeros(1,NumAct);
F_train_f = cell(1,1);
F_test_f = cell(1,1);

yTr = [];
yTe = [];

for i = 1:NumAct 
    F1 = F_f(sample_label==i);
    
    ID = sub_index(sample_label==i);
    for k = 1:length(train_index)
        ID(ID==train_index(k)) = 0;
    end
    F_train_f = [F_train_f, F1(ID==0)];
    F_test_f  = [F_test_f, F1(ID>0)];

    F_train_size(i) = sum(ID==0);
    F_test_size(i)  = size(F1,2) - F_train_size(i);
    yTr = [yTr; i*ones(F_train_size(i), 1)];
    yTe = [yTe; i*ones(F_test_size(i), 1)];
end

F_train_f = F_train_f(2:end);
F_test_f = F_test_f(2:end);


Mat_F_train_f = cell2mat(F_train_f);
if size(Mat_F_train_f,2) > 1000000
    ind = randperm(size(Mat_F_train_f,2));
    Mat_F_train_f = Mat_F_train_f(:,ind(1,1:1000000));
end
%% Fisher Vector Encoding to get Fisher Vector Features

%%%% GMM parameters (mean, cov, prior) are estimated using the training
%%%% data

[means_f, covariances_f, priors_f] = vl_gmm(Mat_F_train_f, numClusters);  %%% we treat front, size, top as three different sources, so will get three sets of Fisher vector

fea_dim_f = size(feature,1);

Tr_f = zeros(fea_dim_f*2*numClusters, length(F_train_f));

for i = 1:length(F_train_f)
    FV_f = vl_fisher(F_train_f{i}, means_f, covariances_f, priors_f, 'Improved');  %%%% get Fisher vectors for the training data using the GMM parameters
    Tr_f(:,i) = FV_f;
end

%%%%% testing samples %%%%%%%
Te_f = zeros(fea_dim_f*2*numClusters, length(F_test_f));

for i = 1:length(F_test_f)
    FV_f = vl_fisher(F_test_f{i}, means_f, covariances_f, priors_f, 'Improved');  %%%% get Fisher vectors for the testing data using the GMM parameters
    Te_f(:,i) = FV_f;

end
toc

%% Classification
tic
F_train = [Tr_f;];
F_test  = [Te_f;];

%%%%//////////////////////// LDA //////////////////////%%%%%

fea = F_train';
gnd = yTr;
options = [];
options.Fisherface = 1;
[eigvector, eigvalue] = LDA(gnd, options, fea);
F_train = fea*eigvector;
fea = F_test';
F_test  = fea*eigvector;
toc

save(['data_',num2str(numClusters),'\yTr'],'yTr');
save(['data_',num2str(numClusters),'\yTe'], 'yTe');
save(['data_',num2str(numClusters),'\F_train_type',num2str(type)],'F_train');
save(['data_',num2str(numClusters),'\F_test_type',num2str(type)], 'F_test');

    end
end


