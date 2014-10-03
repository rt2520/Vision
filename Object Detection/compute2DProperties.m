function [db, out_img] = compute2DProperties(orig_img, labeled_img)
%labels = findDistinctLabels(labeled_img);
%Use above if the labels can be any set of numbers
%I am going to assume the if there are n objects then labels are 1,2,...,n
labels = 1:1:max(labeled_img(:));
num_labels = size(labels , 2);
areas = zeros(1 , num_labels);
first_mom_i = zeros(1 , num_labels);
first_mom_j = zeros(1 , num_labels);
sec_mom_i = zeros(1 , num_labels);
sec_mom_j = zeros(1 , num_labels);
sec_mom_cross = zeros(1 , num_labels);
char_fn = logical(im2bw(orig_img, .5));
for i = 1: size(orig_img, 1)
    for j = 1: size(orig_img, 2)
        %obj_col = find(labels == labeled_img(i,j), 1);
        %Use above if the labels can be any set of numbers
        %But since the labels are 1,2,3...,n the label of a pixel becomes
        %its column id in the database
        if (labeled_img(i,j) > 0)
            obj_col = labeled_img(i,j);
            areas(obj_col) = areas(obj_col) + char_fn(i,j);
            first_mom_i(obj_col) = first_mom_i(obj_col) + (i * char_fn(i,j));
            first_mom_j(obj_col) = first_mom_j(obj_col) + (j * char_fn(i,j));
            sec_mom_i(obj_col) = sec_mom_i(obj_col) + (i * i * char_fn(i,j));
            sec_mom_j(obj_col) = sec_mom_j(obj_col) + (j * j * char_fn(i,j));
            sec_mom_cross(obj_col) = sec_mom_cross(obj_col) + (i * j * char_fn(i,j));
        end
    end    
end
db = zeros(7 ,num_labels);
%Obj Ids
db(1 , :) = labels;
%Row positions of centroids
db(2 , :) = first_mom_i ./ areas;
%Column positions of centroids
db(3 , :) = first_mom_j ./ areas;
a_vec = sec_mom_i + (db(2 , :) .* db(2 , :) .* areas) - ((2 .* db(2 , :)) .* first_mom_i);
c_vec = sec_mom_j + ((db(3 , :) .* db(3 , :)) .* areas) - ((2 .* db(3 , :)) .* first_mom_j);
b_vec = 2 .* (sec_mom_cross + ((db(2 , :) .* db(3 , :)) .* areas) - ((db(3 , :)) .* first_mom_i) - ((db(2 , :)) .* first_mom_j));

tmp_vec = sqrt((b_vec .* b_vec) + ((a_vec - c_vec) .* (a_vec - c_vec))) ./ 2;
%Min Inertias
db(4 , :) = ((a_vec + c_vec) ./ 2) - tmp_vec; 
%A/a+c = compactness feature
db(7 , :) = areas ./ (a_vec + c_vec);
%Orientations
db(5 , :) = atan2(b_vec , a_vec - c_vec) ./ 2;
%Roundedness
db(6 , :) = db(4 , :) ./ (((a_vec + c_vec) ./ 2) + tmp_vec);
fh1 = figure();
imshow(orig_img);
hold on
plot((db(3,:))', (db(2,:))','ws', 'MarkerFaceColor', [1 0 1]);
line_endsx = db(2 , :) + 40 .* cos(db(5 , :));
line_endsy = db(3 , :) + 40 .* sin(db(5 , :));
for i = 1 : size(db , 2)
    line([db(3,i), line_endsy(i)], [db(2,i), line_endsx(i)],...
            'LineWidth',4, 'Color', [0, 1, 0]);
end
out_img = saveAnnotatedImg(fh1);


function labels = findDistinctLabels(labeled_img)
index = 1;
[rows, cols] = find(labeled_img > 0);
labels = zeros(size(rows , 1) , 1);
for i=1:size(rows , 1)
    %Check if current label already exists in labels, if not add it
    if (isempty(find(labels == labeled_img(rows(i), cols(i)), 1)))
        labels(index) = labeled_img(rows(i), cols(i));
        index = index + 1;
    end
end
%Remove Trailing zeros
labels(labels == 0) = [];

function annotated_img = saveAnnotatedImg(fh)
figure(fh); % Shift the focus back to the figure fh

% The figure needs to be undocked
set(fh, 'WindowStyle', 'normal');

% The following two lines just to make the figure true size to the
% displayed image. The reason will become clear later.
img = getimage(fh);
truesize(fh, [size(img, 1), size(img, 2)]);

% getframe does a screen capture of the figure window, as a result, the
% displayed figure has to be in true size. 
frame = getframe(fh);
frame = getframe(fh);
pause(0.5); 
% Because getframe tries to perform a screen capture. it somehow 
% has some platform depend issues. we should calling
% getframe twice in a row and adding a pause afterwards make getframe work
% as expected. This is just a walkaround. 
annotated_img = frame.cdata;
