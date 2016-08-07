input_dir = 'C:\Users\Siddhartha\Documents\MATLAB\images';
image_dims = [100, 150];
input_dir = 'C:\Users\Siddhartha\Documents\MATLAB\images\';
test_dir = 'C:\Users\Siddhartha\Documents\MATLAB\images\test';
test_img = 'image_0449.jpg';
filename_t = fullfile(test_dir,test_img);
img_t = imread(filename_t);
img_gray_t =rgb2gray(img_t);
input_image = imresize(img_gray_t,image_dims);
filenames = dir(fullfile(input_dir, '*.jpg'));
num_images = numel(filenames);
images = [];
for n = 1:num_images
    filename = fullfile(input_dir, filenames(n).name);
    img_original = imread(filename);
    img_gray=rgb2gray(img_original);
    img = imresize(img_gray,image_dims);
    if n == 1
        images = zeros(prod(image_dims), num_images);
    end
    images(:, n) = img(:);
end 
% steps 1 and 2: find the mean image and the mean-shifted input images
mean_face = sum(images,2)/num_images;
shifted_images = images - repmat(mean_face, 1, num_images);
 
% steps 3 and 4: calculate the ordered eigenvectors and eigenvalues
[evectors, score, evalues] = princomp(images');
 
% step 5: only retain the top 'num_eigenfaces' eigenvectors (i.e. the principal components)
num_eigenfaces = 20;
evectors = evectors(:, 1:num_eigenfaces);
 
% step 6: project the images into the subspace to generate the feature vectors
features = evectors' * shifted_images;
% calculate the similarity of the input to each training image
feature_vec = evectors' * (double(input_image(:)) - mean_face);
similarity_score = arrayfun(@(n) 1 / (1 + norm(features(:,n) - feature_vec)), 1:num_images)
 
% find the image with the highest similarity
[match_score, match_ix] = max(similarity_score);
fprintf ('%f %d',match_score,match_ix); 
% display the result
figure, imshow([input_image reshape(images(:,match_ix), image_dims)]);
title(sprintf('matches %s, score %f', filenames(match_ix).name, match_score));

