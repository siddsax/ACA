tdir = 'faces';
idir = 'test_faces';
size = [48,64];
filename = dir(fullfile(tdir,'*.jpg'));
num_img = numel(filename);
images=[];
for n=1:num_img
    filenames = fullfile(tdir,filename(n).name);
    img = imread(filenames);
    if n==1
        img = zeros(prod(size),num_img);
    end
    images(:,n)=img(:);
end
mean_img = mean(img,2);
normalized = img-repmat(mean_img,1,num_img);
[eigenvector,score,eigenval]=princomp(normalized');
principalc=eigenvector(prod(size),1:20);
features=principalc'*normalized;

input_img = imread(fullfile(idir,image_0003.jpg));
feature_vector = principalc'*(input_img-repmat(mean_img,1,num_img));

similarity_score=arrayfun(@(n) 1/(1+norm(feature_vector(:,1)-features(:,n))),1:num_img);
[match_score,matching]=max(similarity_score);

imshow([input_image reshape(images(:,matching),size)]);
title(sprintf('matches %s,score %f',filesname(matching).name,match_score));
