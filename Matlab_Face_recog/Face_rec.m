filenames = dir(fullfile('C:\Users\Siddhartha\Documents\MATLAB\images', '*.jpg'));
test_dir = 'C:\Users\Siddhartha\Documents\MATLAB\images\test';
test_img = 'image_0003.jpg';
filename_t = fullfile(test_dir,test_img);
img_t = imread(filename_t);
img_gray_t =rgb2gray(img_t);
img_resized_t = imresize(img_gray_t,img_dim);
n_img = numel(filenames);
num_eig_faces=20;
img_dim=[48,64];
images=[];
for i=1:n_img
    filename=fullfile('C:\Users\Siddhartha\Documents\MATLAB\images',filenames(i).name);
    img = imread(filename);
    img_gray=rgb2gray(img);
    img_resized = imresize(img_gray,img_dim);
    if i==1
        images = zeros(prod(img_dim), n_img);
    end
    images(:,i) = img_size(:); 
end
mean = sum(images,2)/n_img;
shifted_img = images-repmat(mean,1,n_img);
[eig_vec, score, evalue] = princomp(images');
prim_comp = eig_vec(:,1:num_eig_faces); 
features = prim_comp'*shifted_img;
%classification
feature_vector = prim_comp'*(double(img_resized_t(:)) - mean);
%for n=1:n_img
 %   scores = 1/(1+(norm(features(:,n)-feature_vector)));
%end
score = arrayfun(@(n) 1 / (1 + norm(features(:,n) - feature_vector)), 1:n_img)

[max_score,img_indx] = max(scores);
% display the result
figure, imshow([img_resized_t reshape(images(:,img_indx), img_dim)]);
title(sprintf('matches %s, score %f', filenames(img_indx).name, max_score));







