function feature = extract_feature(file,type);
load(file);
X0 = skeleton.X';
Y0 = skeleton.Y';
Z0 = skeleton.Z';

if type == 3
    % only for comparision
    feature = [];
    for t = 1:size(X0,2)
        pose = [X0(:,t),Y0(:,t),Z0(:,t)];
        Dist = pdist2(pose,pose,'euclidean');
        Dist = reshape(Dist,[],1);
        feature = [feature, Dist];
    end
else
    feature = [];
    for t1 = 1:size(X0,2)-1
    for t2 = t1+1:size(X0,2)
        pose1 = [X0(:,t1),Y0(:,t1),Z0(:,t1)];
        pose2 = [X0(:,t2),Y0(:,t2),Z0(:,t2)];

        if type == 1
            Dist1 = pdist2(pose1,pose1,'euclidean');
            Dist2 = pdist2(pose2,pose2,'euclidean');

            Dist = [Dist1,Dist2];
            Dist = reshape(Dist,[],1);
        end
        
        if type == 2
            Dist1 = pdist2(pose1,pose1,'euclidean');
            Dist2 = pdist2(pose2,pose2,'euclidean');

            Dist = Dist2 - Dist1;
            Dist = reshape(Dist,[],1);
        end

        feature = [feature, Dist];
    end
    end
end


